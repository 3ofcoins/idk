@test "i am not root" {
      ! test `whoami` == 'root'
}

@test "i can sudo" {
      test `sudo whoami` == 'root'
}
