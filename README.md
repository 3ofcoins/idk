Infrastructure Development Kit
==============================

Infrastructure Development Kit, or IDK, is a one-stop package
containing software collection needed to develop and manage server
infrastructure using Opscode Chef and related tools.

> **WARNING:** this package is still alpha. Rough edges expected.

Included software
-----------------

 - Chef 11.12.2
 - Knife plugins:
   - chef-vault
   - knife-annex
   - knife-backup
   - knife-briefcase
   - knife-cleanup
   - knife-config
   - knife-dns-update
   - knife-dwim
   - knife-ec2
   - knife-essentials
 - Testing tools:
   - Test Kitchen 1.2.1 with kitchen-vagrant
   - Chefspec 3.4.0
   - Strainer 3.3.0
   - Foodcritic 3.0.3
 - Berkshelf 3 (from git)
 - Omnibus 3.0.0
 - Pry 0.9.12.6
 - Rake 10
 - Thor 0.18.1
 - Mina 0.3.0
 - Capistrano 3.1.0
 - Vendorificator 0.5.3

IDK includes also chef-solo recipes that make sure that following
software is installed on your workstation:

 - Git
 - Git-annex

Installation and setup
----------------------

Download package for your OS from
https://github.com/3ofcoins/idk/releases and install it. Then, as a
user, run `idk setup` to configure your workstation and
environment. You should be ready to roll at that moment.

Usage
-----

If `idk setup` executed successfully, you should have all relevant
commands in your path. Everything should Just Work. If it's not so,
[it's an issue](https://github.com/3ofcoins/idk/issues).

Issues and Suggestions
----------------------

Please file any issues, questions, or suggestions (especially for
other software that may need to be configured) at
[GitHub Issues](https://github.com/3ofcoins/idk/issues).
