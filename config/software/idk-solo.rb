name "idk-solo"

dependency "berkshelf"
dependency "rsync"

source :path => File.expand_path("files/#{name}", Omnibus.project_root)

build do
  command "mkdir -p #{install_dir}/solo"
  command "#{install_dir}/embedded/bin/rsync --exclude='*~' --delete -a ./ #{install_dir}/solo"
  command "#{install_dir}/embedded/bin/berks vendor cookbooks",
          cwd: "#{install_dir}/solo",
          env: Omnibus::Builder::BUNDLER_BUSTER.merge(
    'OMNIBUS_ROOT' => Omnibus.project_root,
    'PATH' => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    'LC_ALL' => 'en_US.UTF-8')
end
