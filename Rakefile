# -*- ruby -*-

require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end

task :installer do
  of = "pkg/idk-installer.sh"
  cmd = "curl -o #{of}"
  cmd << " -v" if ENV['VERBOSE']
  if $stderr.tty?
    cmd << " -#"
  else
    cmd << " -s -S"
  end
  cmd << " -H 'If-None-Match: \"#{Digest::MD5.hexdigest(File.read(of))}\"'" if File.exist? of
  cmd << " https://s3.amazonaws.com/downloads.3ofcoins.net/idk-installer.sh"
  sh cmd
end

Rake::Task.tasks.select { |t| t.name.start_with? 'kitchen:' }.each do |t|
  task t => :installer
end

namespace :idk do
  desc "Prepare a description to paste into GitHub's release page"
  task :describe_release do
    require 'filesize'
    require 'fog'
    require 'minigit'

    version = ENV['VERSION'] || MiniGit::Capturing.describe.strip.sub(/-.*$/, '')

    desc_md = <<EOF
Infrastructure Development Kit #{version}
===============================#{'=' * version.length}

Downloads
---------

EOF

    connection = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      path_style: true)
    bucket = connection.directories.get('downloads.3ofcoins.net')
    bucket.files.all(prefix: "idk/#{version}").each do |file|
      next if file.key =~ /\.json$/
      pretty_size = Filesize.from("#{file.content_length} B").pretty
      public_url = file.service.request_url(bucket_name: bucket.key, object_name: file.key)

      remarks = case File.basename(file.key)
                when /mac_os_x\.10\.7\.\d+\.sh$/
                  'also for OSX 10.6'
                end

      line = " - [#{File.basename(file.key)}](#{public_url}) &mdash; #{pretty_size}"
      line << " (#{remarks})" if remarks
      desc_md << "#{line}\n"
    end

    desc_md << <<EOF

Changes
-------

EOF
    found = nil
    prev = nil
    File.open('CHANGELOG.md').lines.each do |line|
      if !found
        found = true if line.strip == version
        next
      end

      if line =~ /^-+$/
        if prev then break else next end
      end

      desc_md << prev if prev && !prev.empty?
      prev = line
    end

    puts desc_md
  end
end
