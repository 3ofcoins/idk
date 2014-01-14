name 'rake-gem'
version '10.1.1'

dependency 'ruby'
dependency 'rubygems'

build do
  block do
    rake_bin = "#{install_dir}/embedded/bin/rake"
    FileUtils.rm_f rake_bin if File.exist? rake_bin
  end
  gem "install rake --no-rdoc --no-ri -v #{version}"
end
