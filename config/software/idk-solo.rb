name "idk-solo"

dependency "berkshelf"
dependency "rsync"

source :path => File.expand_path("files/#{name}", Omnibus.project_root)

build do
  command "mkdir -p #{install_dir}/solo"
  command "#{install_dir}/embedded/bin/rsync --exclude='*~' --delete -a ./ #{install_dir}/solo"
  command("#{install_dir}/embedded/bin/berks install --path cookbooks", :cwd => "#{install_dir}/solo", :env => Omnibus::Builder::BUNDLER_BUSTER.merge('OMNIBUS_ROOT' => Omnibus.project_root))
end
