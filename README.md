Infrastructure Development Kit
==============================

Infrastructure Development Kit, or IDK, is a one-stop package
containing software collection needed to develop and manage server
infrastructure using Opscode Chef and related tools.

> **WARNING:** this package is still alpha. It is still a bit of
> a moving target, and you should expect some rough edges.

Included software
-----------------

 - Chef 11.4.4
 - Knife plugins:
   - chef-vault
   - knife-briefcase
   - knife-config
   - knife-dns-update
   - knife-dwim
   - knife-essentials
 - Testing tools:
   - Test Kitchen 1.0.0.alpha.7 with kitchen-vagrant
   - Chefspec 1.3.1
   - Strainer 3.0.4
   - Foodcritic 2.20
 - Berkshelf 2.0.7
 - Omnibus 1.2.0
 - Pry 0.9.12.2
 - Rake 10.1.0
 - Thor 0.18.1
 - Vendorificator 0.5-pre

IDK includes also chef-solo recipes that make sure that following
software is installed on your workstation:

 - Git
 - Git-annex
 - Virtualbox
 - Vagrant
 - Vagrant plugins:
   - vagrant-plugin-bundler
   - vagrant-berkshelf
   - vagrant-omnibus
   - vagrant-exec

Installation and setup
----------------------

Download package for your OS from
https://github.com/3ofcoins/idk/releases and install it. Then run
`/opt/idk/bin/idk setup` to configure your workstation and
environment. You should be ready to roll at that moment.

Usage
-----

If `idk setup` executed successfully, you should have all relevant
commands in your path. Everything should Just Work. If it's not so,
[please contact us](https://github.com/3ofcoins/idk/issues).

Issues and Suggestions
----------------------

Please file any issues, questions, or suggestions (especially for
other software that may need to be configured) at
[GitHub Issues](https://github.com/3ofcoins/idk/issues).
