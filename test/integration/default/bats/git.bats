@test "git is installed" {
    git version
}

@test "git-annex is installed" {
    # git-annex is in /usr/local/bin on arch, bats executes in a
    # non-login shell that doesn't have it it $PATH.
    bash --login -c 'git annex version'
}
