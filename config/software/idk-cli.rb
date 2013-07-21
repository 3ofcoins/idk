name "idk-cli"
version project.build_version

dependency "ruby"
dependency "rubygems"

source path: File.expand_path("files/#{name}", Omnibus.project_root)

build do
  gem "build -V ./idk-cli.gemspec", :env => { 'IDK_CLI_VERSION' =>  version }
  gem "install ./idk-cli-#{version}.gem --no-rdoc --no-ri"
  command "#{install_dir}/embedded/bin/rsync --exclude='*~' -a ./files/ #{install_dir}"
end
