# Assumer Options #

This document is an in-depth explanation of the various options (or flags) that Assumer supports.

## Command Line Tool ##

The `assumer` gem includes an executable Ruby script that automates the process of double-jumping and assuming a role within a target account.  This script can optionally use those temporary credentials to open a web browser so that the AWS Console can be accessed, drop into a Pry shell, or both.

As of Assumer v0.4.2, the flags available are:
```
$ assumer -h
Parameters:
  -a, --target-account=<s>     Target AWS account to assume into
  -r, --target-role=<s>        The role in the target account
  -A, --control-account=<s>    Control Plane AWS account
  -R, --control-role=<s>       The role in the control account
These parameters are optional:
  -e, --region=<s>             AWS region to operate in
  -u, --username=<s>           Your IAM username (default: Output of `whoami`)
  -o, --profile=<s>            Profile name from ~/.aws/credentials
  -g, --gui                    Open a web browser to the AWS console with these credentials
  -p, --pry                    Open a pry shell with these credentials
  -n, --enable-aws-bundled-ca-cert    Option to enable the certificate store bundled with the AWS SDK
  -d, --debug                  Output debugging information
  -v, --version                Print version and exit
  -h, --help                   Show this message
```

### Required Parameters ###

#### Target Account ####

* Short: `-a`
* Long: `--target-account=`

This parameter specifies the AWS account that you will ultimately assume a role into; this is the second jump in the 'double-jump'.

Example: `123456789012`

This parameter requires a 12-digit AWS account number.  If the provided account number is invalid, assumer will output an error message:

`Error: argument --target-account Must be a 12-digit AWS account number.`

#### Target Role ####

* Short: `-r`
* Long: `--target-role=`

This parameter specifies the role that will be assumed in the target account.  The assumer tool will build the ARN from the account number and knowledge of AWS syntax, leaving just the role path and name to be specified.

Example: `my-role-path/my-target-role-name`

This parameter requires the ultimate rolename be syntactically valid.  There is no way to verify a role is valid from the start, just that it *appears* to be a valid role.  The error message is:

`Error: argument --target-role Invalid target role.`

#### Control Account ####

* Short: `-A`
* Long: `--control-account=`

This parameter specifies the AWS account acting as a control plane to the account you want to assume-role into; this is the first jump in the 'double-jump'.

Example: `123456789012`

This parameter requires a 12-digit AWS account number.  If the provided account number is invalid, assumer will output an error message:

`Error: argument --control-account Must be a 12-digit AWS account number.`

#### Control Role ####

* Short: `-R`
* Long: `--control-role=`

This parameter specifies the role that will be assumed in the control plane account.  The assumer tool will build the ARN from the account number and knowledge of AWS syntax, leaving just the role path and name to be specified.

Example: `my-role-path/my-control-role-name`

This parameter requires the ultimate rolename be syntactically valid.  There is no way to verify a role is valid from the start, just that it *appears* to be a valid role.  The error message is:

`Error: argument --control-role Invalid target role.`

### Optional Flags ###

#### Region ####

* Short: `-e`
* Long: `--region=`

This parameter allows specifying the AWS region to operate in.  The default is `us-west-2`.  Any AWS region name can be specified.

Example: `us-east-1`

#### Username ####

* Short: `-u`
* Long: `--username=`

This parameter allows overriding the host operating system reported username for the IAM username associated with your MFA device.

The default is to query the host operating system for `whoami` and use that value.

#### Profile ####
* Short: `-o`
* Long: `--profile=`

This parameter allows the user to set which credential profile to use from their `.aws/credentials` file.

**Note:** The AWS SDK looks for credentials in this order:
1. ENV['AWS_ACCESS_KEY_ID'] and ENV['AWS_SECRET_ACCESS_KEY']
1. The shared credentials ini file at ~/.aws/credentials (more information)
1. From an instance profile (when running on EC2)

If you are having unexpected access denied errors, it may be from credentials that have been previously loaded into your shell's environment, *or* specifying an incorrect profile.

#### GUI ####
* Short: `-g`
* Long: `--gui`

This parameter requests Assumer to build a URL for access to the AWS console with the final assumed credentials, and open it with the default web browser.

#### Prompt ####
* Short: `-p`
* Long: `--pry`

This parameter requests Assumer to spawn a Pry shell with the final assumed credentials made available within the shell.  This allows for interactive usage of the AWS Ruby SDK with the assume-role credentials.

## Enable AWS Bundled CA Certificate ##

* Short: **this option does not have a guaranteed short option**
* Long: `--enable-aws-bundled-ca-cert`

This parameter is used to signal to the SDK that it should use the certificate store bundled with the SDK instead of relying on the system's CA store.  This can manifest itself as an error that looks like: `Seahorse::Client::Http::Error: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed from...`  When this happens, a user can fix their installation of certificates, configure their system with certificates (such as the ones from [cURL](https://curl.haxx.se/docs/caextract.html)), or pass this option to use the bundled certificates.  This option *only* applies to HTTPS requests made by the AWS SDK, and not any other HTTPS requests made by the gem.

#### Debug ####
* Long: `--debug`

This option will output a lot of debugging information about options set and internal going-ons of Assumer.

#### Version ####
* Short: `-v`
* Long: `--version`

This flag will cause Assumer to print it's version string *and exit*.  Not compatible with other options.

#### Help ####
* Short: `-h`
* Long: `--help`

This flag will cause Assumer to print it's help text, including summarized information for all these flags, *and exit*.  Not compatible with other options.



## Ruby Gem ##
