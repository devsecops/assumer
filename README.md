# Assumer #

## Overview ##
The Assumer gem is an interface allowing the user to assume role into an account.  Credentials can be loaded anywhere the AWS STS Client knows to load credentials from (ENV, profile, etc.)

## Content ##
Assumer will assume-role on a target account and generate temporary API keys for that account.  It can optionally drop you into a pry session or load the AWS console in the context of the role assumed in the target account depending on how Assumer was called.

## Installation ##

Assumer requires a Ruby version >= 2.1

Install with `gem install assumer`

### Build from Source ###

1. Clone the repository
1. Change directory into the newly-cloned repository
  * `cd assumer`
1. Change directory into the `source` folder, where the gem's source code lives
  * `cd source`
1. Build and install the gem
  * `gem build assumer.gemspec`
1. Install the gem
  * `gem install assumer-0.4.1.gem`

## Usage ##

**Having trouble running Assumer on Windows?  Please see our [document](/docs/Windows.md) with some troubleshooting steps.**

You can use the gem on the command line.  For an in-depth explanation of options, see [this file](/docs/Options.md); what follows is a simplistic overview.
  * `assumer -h` To see help text
  * `assumer -a 123456789012 -r "target/role-name" -A 987654321098 -R 'control/role-name' `
To request a console, pass the `-g` flag
  * `assumer -a 123456789012 -r target_role/target_path -A 987654321098 -R control_role/control_path -g`
To request a pry console, pass the `-p` flag
  * `assumer -a 123456789012 -r target_role/target_path -A 987654321098 -R control_role/control_path -p`
Why not both?
  * `assumer -a 123456789012 -r target_role/target_path -A 987654321098 -R control_role/control_path -p -g`

Or use the gem in your code:
```ruby
require 'assumer'
# First Jump
control_creds = Assumer::Assumer.new(
  region: aws_region,
  account: control_plane_account_number,
  role: control_plane_role,
  serial_number: serial_number, # if you are using MFA, this will be the ARN for the device
  profile: credential_profile_name # if you don't want to use environment variables or the default credentials in your ~/.aws/credentials file
)
# Second jump
target_creds = Assumer::Assumer.new(
  region: aws_region,
  account: target_plane_account_number,
  role: target_account_role,
  credentials: control_creds
)
```


## Notes ##
 1. To be able to use this utility you will need to have permission to assume-role against the role you specify!
