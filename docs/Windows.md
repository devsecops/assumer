# Running Assumer on Windows #

*This document is a work in progress*


1. Download Ruby 2.2.* from http://rubyinstaller.org/downloads/
1. Build the Assumer gem
1. Install the gem.  Open a cmd.exe window and type `gem install `, then drag-and-drop the gem file into the window and press enter.
  * If the required gems are not installed, here is a list of dependencies that can be downloaded and installed individually:
	  * https://rubygems.org/downloads/pry-0.10.3.gem
	  * https://rubygems.org/downloads/trollop-2.1.2.gem
	  * https://rubygems.org/downloads/coderay-1.1.1.gem
	  * https://rubygems.org/downloads/method_source-0.8.2.gem
	  * https://rubygems.org/downloads/slop-3.4.0.gem
	  * https://rubygems.org/downloads/aws-sdk-core-2.2.20.gem
	  * https://rubygems.org/downloads/jmespath-1.1.3.gem
1. Download CACERT.PEM to allow SSL communications from http://curl.haxx.se/ca/cacert.pem
1. Open Command Prompt and run
 * `set AWS_ACCESS_KEY_ID=AKIA_ACCESS_KEY_HERE`
 * `set AWS_SECRET_ACCESS_KEY=5_SECRET_KEY_HERE_J`
 * `set SSL_CERT_FILE=c:\path\to\where\you\saved\cacert.pem`
1. Now you can run assumer commands in the terminal window

If you do not need to use the GUI, you can skip the steps involving `cacert.pem` and enable the [AWS bundled certificates](/docs
/Options.md#enable-aws-bundled-ca-certificate)
