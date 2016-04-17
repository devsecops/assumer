# Assumer Change Log #

## Version 0.4.0 ##

* First public release

## Version 0.3.0 ##

* Lots of small tweaks to work around the various issues that Windows has.
  * Did you know that Windows treats `''` and `""` differently?  The more you know...
  * Users on Windows can use their default browser
* Documentation updates

## Version 0.2.9 ##

** Unreleased, used for debugging only **

## Version 0.2.8 ##

* Provide an option for using the CA Certificate store bundled with the AWS SDK.  The default is to use the system's certificate, but this is sometimes misconfigured.
* Write the temporary credentials in a manner that allows for easy use on Windows

## Version 0.2.7 ##

* Addition of `--debug` flag
* Fixes to web browser opening; now works on Windows and Linux
* Documentation [addition](Options.md): Explanation of all flags and options when invoked

## Version 0.2.6 ##

* First public release!
* Introduction of `-p` flag to optionally drop into a pry prompt.  `-p` and `-g` can be combined for a console login link and pry shell, or both can be omitted for just the temporary credential file generation.
