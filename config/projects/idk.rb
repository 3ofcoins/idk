name "idk"
maintainer "Maciej Pasternacki <maciej@3ofcoins.net>"
homepage "https://github.com/3ofcoins/idk/"

replaces        "idk"
install_path    "/opt/idk"

build_version Omnibus::BuildVersion.new.semver
build_iteration 1

dependency "preparation"

dependency "idk-bundle"
dependency "idk-gems"
dependency "idk-cli"
dependency "idk-solo"

dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"

def platform_version
  if platform == 'arch'
    machine
  else
    super
  end
end
