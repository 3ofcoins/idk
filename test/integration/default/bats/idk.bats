@test "idk command exists" {
    command -v idk
}

@test "idk runs" {
    idk version
}

@test "idk profile is loaded in login shells" {
    bash --login -c '[ "x$idk_profile_loaded" != "x" ]'
}

@test "idk path is injected in front of everything in login shells" {
    test `bash --login -c 'which idk'` == /opt/idk/bin/idk
}

@test "idk setup stamp exists" {
    test -f /var/local/idk/user/`whoami`/setup.stamp
}
