Changes
=======

0.1.4
-----
 - Bumped Vendorificator to include bugfixes
 - Bumped Chefspec

0.1.3
-----
 - Bumped dmg cookbook & Vendorificator to fix ugly bugs.

0.1.2
-----
 - Bumped some gems
 - Chef-solo setup doesn't try to install git or git-annex when
   they're already installed

0.1.1
-----
 - Updated Vendorificator to include a bugfix

0.1.0
-----
 - Stopped trying to install Virtualbox & Vagrant, it proved
   problematic and didn't bring much value
 - Upgraded included gems and other software
 - Run knife with bundler for faster startup

0.0.6
-----
 - Include knife-annex
 - Unify var directory in /var/local/idk
 - Handle situation when `user_var` doesn't exist and can't be created
 - Bump Chef gems

0.0.5
-----
 - Drop `idk sudo`, it's `idk exec --root` now
 - Bump solo cookbooks
 - Kind of support Snow Leopard

0.0.4
-----
 - Add knife-ec2
 - Script fix for makeselfinst
 - Include Mina

0.0.3
-----
 - Fix sudo
 - Link chef-solo
 - Correctly run chef-solo
 - UX consistency
 - Build with Docker
 - Bump gems

0.0.2
-----

 - Don't run chef-solo from postinst scripts, it tries to use apt and
   bombs
 - Build 32-bit Ubuntu packages
 - Upgrade cookbokos for chef-solo

0.0.1
-----

 - Initial release, NFY
