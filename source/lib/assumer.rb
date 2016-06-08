require 'assumer/version'
require 'aws-sdk-core'
require 'mfa'

module Assumer
  # The regex that AWS uses to verify if a role's ARN is valid
  AWS_ROLE_REGEX = %r{arn:aws:iam::\d{12}:role/?[a-zA-Z_0-9+=,.@\-_/]+}
  class AssumerError < StandardError; end
  # This class provides the main functionallity to the Assumer gem

  class Assumer
    # This is the only thing clients are allowed to access
    # It will be an STS::AssumeRoleCredentials object created by AWS
    attr_accessor :assume_role_credentials

    ##
    # Creates the Assumer object
    #
    # @param [String] region The AWS region to establish a connection from (if left nil, Assumer will try and use it's current region)
    # @param [String] account The AWS account number without dashes
    # @param [String] role The ARN for the role to assume
    # @param [String] serial_number The Serial Number of an MFA device
    # @param [Assumer] credentials An assumer object (to support double-jumps)

    def initialize(region: nil, account: nil, role: nil, serial_number: nil, credentials: nil, profile: nil)
      @region = region ? region : my_region # if region is passed in, use it, otherwise find what region we're in and use that
      @account = account
      @role = verify_role(role: role)
      # If we are being passed credentials, it's an Assumer instance, and we can
      # get the creds from it.  Otherwise, establish an STS connection
      @sts_client = establish_sts(region: @region,
                                  passed_credentials: credentials,
                                  credentials_profile: profile
                                 )
      @serial_number = serial_number # ARN for the user's MFA serial number

      opts = {
        client: @sts_client,
        role_arn: @role,
        role_session_name: 'AssumedRole'
      }
      # Don't specify MFA serial number or token code if they aren't needed
      unless @serial_number.nil?
        opts[:serial_number] = @serial_number
        opts[:token_code] = MFA.new.request_one_time_code
      end
      @assume_role_credentials = Aws::AssumeRoleCredentials.new(opts)

    rescue Aws::STS::Errors::AccessDenied => e
      raise AssumerError, "Access Denied: #{e.message}"
    end

    ##
    # Verifies the requested role is valid
    # Only checks syntax, does not guarantee the role exists or can be assumed into
    # @param [String] role The ARN of the role to be verified
    # @return [String] The ARN of a valid role
    # @raise [AssumerError] If the ARN is invalid, an exception is raised
    def verify_role(role:)
      raise AssumerError, "Invalid ARN for role #{role}" if role =~ AWS_ROLE_REGEX
      role
    end

    private

    ##
    # Establish an AWS STS connection to retrieve tokens
    # @param [String] region An AWS region to establish a connection in
    # @param [Assumer] passed_credentials An Assumer object that has established a connection to an account.  Used for double-jumps.
    # @param [String] credentials_profile The credentials profile to load from the user's .aws/credentials file
    # @return [Aws::STS::Client] The Secure Token Service client
    def establish_sts(region: nil, passed_credentials: nil, credentials_profile: nil)
      throw AssumerError.new('No region provided') if region.nil?
      opts = { region: region }

      # If credentials were passed in, use those to build the STS client
      opts.merge!(
        access_key_id: passed_credentials.assume_role_credentials.credentials.access_key_id,
        secret_access_key: passed_credentials.assume_role_credentials.credentials.secret_access_key,
        session_token: passed_credentials.assume_role_credentials.credentials.session_token
      ) unless passed_credentials.nil?

      # If a profile is specified, read those from the ~/.aws/credentials file
      # Or anywhere AWS STS Client knows where to load them from
      opts[:profile] = credentials_profile unless credentials_profile.nil?
      @sts_client = Aws::STS::Client.new(opts)
    end

    ##
    # Determine the region this code is being called in by contacting the AWS
    # metadata service
    # @return [String] AWS Region Assumer is being called in OR 'us-east-1' if unable to be determined
    # @raise [AssumerError] If the region cannot be determined, an exception is raised
    def my_region
      require 'net/http'
      require 'json'
      metadata_uri = URI('http://169.254.169.254/latest/dynamic/instance-identity/document/')
      request = Net::HTTP::Get.new(metadata_uri.path)
      response = Net::HTTP.start(metadata_uri.host, metadata_uri.port) do |http|
        http.read_timeout = 10
        http.open_timeout = 10
        http.request(request)
      end
      JSON.parse(response).fetch('region', 'us-east-1')
    rescue => e
      raise AssumerError, "Could not determine region (are you running in AWS?): #{e.message}"
    end
  end
end
