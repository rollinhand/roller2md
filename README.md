# roller2md
This Ruby script is a converter for extracting blog posts from an 
[Apache Roller](https://roller.apache.org) blog to Markdown scripts. This script was 
written to extract the posts directly from [MySQL](http://www.mysql.org) database and 
convert the content to Markdown as it can be used by the [Jekyll](https://jekyllrb.com) 
system used on [GitHub](https://github.com).

The script needs some additional gems to work properly as defined in the Gemfile:
* mysql2 - A simple, fast Mysql library for Ruby, binding to libmysql.
* upmark - A HTML to Markdown converter. 

Read the instructions provided in this README to install dependencies and required 
libraries as the original MySQL headers.

This script was tested on macOS and Ubuntu.

## Prerequisites
You have to install MySQL Header files on your system to get this script working.

### On Ubuntu
```
sudo apt-get install libmysqlclient-dev
```

### On macOS
Get the disk image from mysql.org and install client and server on your machine. 

## Install additional gems
This _application script_ comes with a Gemfile defining needed dependencies. If you have
[Bundler](http://http://bundler.io) installed, you can make sure everything is installed
by calling
```
bundle install
```

Otherwise I recommend installing Bundler with
```
gem install bundler
```

### Dump MySQL
If you don't have direct access to your MySQL database or the MySQL port is not open to
the world, dump your database and import your dump to a local database. You can do this
with the following commands:

#### Create dump
This command dumps your database to export.sql
```
mysqldump --add-drop-table --user=_username_ --password=_password_ --result-file=export.sql rollerdb
```
Download the created SQL file to your local machine and import it.

#### Import dump
Use this instructions to import the dump:
Create a new database:
```
mysql -u username -p
CREATE DATABASE IF NOT EXISTS rollerdb;
QUIT;
```

Read in export file:
```
mysql -u _username_ -p rollerdb < export.sql
```


