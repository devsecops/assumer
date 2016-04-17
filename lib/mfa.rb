module Assumer
  ##
  # A class to manage methods of obtaining OTP codes for MFA
  class MFA
    attr_reader :otp
    ##
    # A method to prompt for the user's OTP MFA code on the CLI
    # @return [String] The MFA code entered by the user
    def request_one_time_code
      until @otp =~ /\d{6}/
        print 'Enter MFA: '
        $stdout.flush
        @otp = $stdin.gets(7).chomp
        $stderr.puts 'MFA code should be 6 digits' if @otp !~ /\d{6}/
      end
      @otp
    end
  end
end
