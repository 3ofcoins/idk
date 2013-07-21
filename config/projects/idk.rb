name "idk"
maintainer "Maciej Pasternacki <maciej@3ofcoins.net>"
homepage "https://github.com/3ofcoins/idk/"

replaces        "idk"
install_path    "/opt/idk"

version, wip = Omnibus::BuildVersion.new.semver.split('+')
version = Gem::Version.new(version).bump.to_s << '.wip' << wip if wip
build_version version
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
