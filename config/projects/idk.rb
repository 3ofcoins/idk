name "idk"
maintainer "Maciej Pasternacki <maciej@3ofcoins.net>"
homepage "https://github.com/3ofcoins/idk/"

replaces        "idk"
install_path    "/opt/idk"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

dependency "chef-gem"

# idk dependencies/components
# dependency "somedep"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
