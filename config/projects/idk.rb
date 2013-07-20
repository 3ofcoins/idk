name "idk"
maintainer "Maciej Pasternacki <maciej@3ofcoins.net>"
homepage "https://github.com/3ofcoins/idk/"

replaces        "idk"
install_path    "/opt/idk"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

dependency "preparation"

dependency "chef-gem"
dependency "berkshelf"
dependency "idk-bundle"
dependency "idk-cli"
dependency "idk-solo"

dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
