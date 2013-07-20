name "idk-cli"

dependency "ruby"
dependency "rubygems"

source path: File.expand_path("files/#{name}", Omnibus.project_root)

build do
  gem "build -V ./idk-cli.gemspec"
  gem "install ./idk-cli*.gem --no-rdoc --no-ri"
  command "install -m 0644 profile.sh #{install_dir}"
  command "install -m 0755 idk #{install_dir}/bin"
end
