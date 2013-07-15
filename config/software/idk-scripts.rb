name "idk-scripts"

dependency "rsync"
dependency "ruby"

source path: File.expand_path("files/#{name}", Omnibus.project_root)

build do
  gem "install thor --no-rdoc --no-ri -v 0.18.1"
  command "#{install_dir}/embedded/bin/rsync -a --exclude '*~' ./ #{install_dir}"
end

