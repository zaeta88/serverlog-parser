# README

Test application to parse the webserver logs into a more readable report, showing the total number of visits by page
and the unique number of visits by page, both of them ordered by count and name of the visisted page.

the format of the log we are currently supporting is the following:
Ex: /path-to-site 127.0.0.1

* Instalation:

After cloning the repository use "bundle install" to get dependencies installed and the project ready to go

* To run the script use:

ruby ./parser.rb path-to-file.log

Where the path-to-file.log is the file we want to parse

* Extra commands to get an especific report:

You can use --unique and --all to get an specific report like:

ruby ./parser.rb path-to-file.log --unique

and that way you'll get only the unique views report

* Test that the app works and get the desired result:

rspec

* Test the style is correct use:

rubocop