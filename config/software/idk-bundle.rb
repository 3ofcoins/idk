name "idk-bundle"

dependency "bundler"

source path: File.expand_path("files/#{name}", Omnibus.project_root)

build do
  require 'fileutils'
  gemfile_dir = "#{install_dir}/embedded/etc"
  block do
    FileUtils.mkdir_p gemfile_dir
    FileUtils.cp 'Gemfile', gemfile_dir
    FileUtils.cp 'Gemfile.lock', gemfile_dir
  end
  bundle "install --gemfile=#{gemfile_dir}/Gemfile --deployment"
end
