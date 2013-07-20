name "idk-bundle"

dependency "bundler"

source path: File.expand_path("files/#{name}", Omnibus.project_root)

build do
  require 'fileutils'
  gemfile_dir = "#{install_dir}/embedded/etc"
  block do
    FileUtils.mkdir_p gemfile_dir
    FileUtils.cp "#{project_dir}/Gemfile", gemfile_dir, :verbose => true
    FileUtils.cp "#{project_dir}/Gemfile.lock", gemfile_dir, :verbose => true
  end
  bundle "install --gemfile=#{gemfile_dir}/Gemfile"
end
