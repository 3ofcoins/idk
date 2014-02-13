setup () {
      . /opt/idk/profile.sh
}

@test "knife" {
      knife --version
      test `which knife` == /opt/idk/bin/knife
}

@test "chef-solo" {
      chef-solo --version
      test `which chef-solo` == /opt/idk/bin/chef-solo
}

@test "chef-shell" {
      chef-shell --version
      test `which chef-shell` == /opt/idk/bin/chef-shell
}

@test "strainer" {
      strainer --version
      test `which strainer` == /opt/idk/bin/strainer
}

@test "foodcritic" {
      foodcritic --version
      test `which foodcritic` == /opt/idk/bin/foodcritic
}

@test "chef-zero" {
      chef-zero --version
      test `which chef-zero` == /opt/idk/bin/chef-zero
}

@test "berks" {
      berks version
      test `which berks` == /opt/idk/bin/berks
}

@test "vendor" {
      vendor --version
      test `which vendor` == /opt/idk/bin/vendor
}

@test "mina" {
      mina --version
      test `which mina` == /opt/idk/bin/mina
}

@test "cap" {
      cap --version
      test `which cap` == /opt/idk/bin/cap
}

@test "thor" {
      thor version
      test `which thor` == /opt/idk/bin/thor
}
