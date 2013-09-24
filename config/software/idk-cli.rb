name "idk-cli"
version project.build_version.gsub(/[^a-z0-9\.]+/, '.')

# List of wrapped tools that will be added to $PATH
wrapped = [
  'berks',
  'chef-apply',
  'chef-shell',
  'chef-solo',
  'chef-zero',
  'foodcritic',
  'kitchen',
  'knife',
  'mina',
  'shef',
  'strainer',
  'thor',
  'vendor' ]

dependency "rsync"
dependency "ruby"
dependency "rubygems"

source path: File.expand_path("files/#{name}", Omnibus.project_root)

build do
  gem "build -V ./idk-cli.gemspec", env: { 'IDK_CLI_VERSION' =>  version }
  gem "install ./idk-cli-#{version}.gem --no-rdoc --no-ri"
  command "#{install_dir}/embedded/bin/rsync --exclude='*~' -a ./files/ #{install_dir}"
  block do
    wrapped.each do |cmd|
      FileUtils.ln_sf 'idk', "#{install_dir}/bin/#{cmd}",
                      verbose: !!ENV['DEBUG']
    end
  end
end
