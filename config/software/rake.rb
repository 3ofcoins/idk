name 'rake'
version '10.1.1'

dependency 'ruby'
dependency 'rubygems'

build do
  block do
    rake_bin = "#{install_dir}/embedded/bin/rake"
    FileUtils.rm rake_bin if File.exist? rake_bin
  end
  gem "install #{name} --no-rdoc --no-ri -v #{version}"
end
