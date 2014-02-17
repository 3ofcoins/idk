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
  chmod 0755, of
end

Rake::Task.tasks.select { |t| t.name.start_with? 'kitchen:' }.each do |t|
  task t => :installer
end

autoload :Fog, 'fog'
autoload :JSON, 'json'
autoload :MiniGit, 'minigit'

def bucket
  $idk_s3 ||= Fog::Storage.new(
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    endpoint: 'https://s3.amazonaws.com/',
    path_style: true)
  $idk_bucket ||= $idk_s3.directories.get('downloads.3ofcoins.net')
end

def idk_version
  $idk_version ||= ENV['VERSION'] || ENV['GIT_DESCRIBE'] || MiniGit::Capturing.describe.strip.sub(/-.*$/, '')
end

namespace :idk do
  task :publish do
    Dir["pkg/*.json"].each do |meta_path|
      meta_json = File.read(meta_path)
      meta = JSON[meta_json]

      puts "Uploading #{meta['basename']} ..."
      bucket.files.create key: "idk/#{idk_version}/#{meta['basename']}",
                          body: File.open(File.join(File.dirname(meta_path), meta['basename'])),
                          public: true

      meta_filename = File.basename(meta_path)
      puts "Uploading #{meta_filename} ..."
      bucket.files.create key: "idk/#{idk_version}/#{meta_filename}",
                          body: meta_json,
                          public: true
    end
  end

  task :manifest do
    pkgs = {}
    meta = []
    bucket.files.all(prefix: "idk/").each do |file|
      if file.key =~ /\.json$/
        metum = JSON[file.body]
        metum['key'] = "#{file.key.sub(/\/[^\/]*$/,'')}/#{metum['basename']}"
        meta << metum
      else
        pkgs[file.key] = file
      end
    end
    meta.each do |metum|
      file = pkgs[metum.delete 'key']
      metum['bytes'] = file.content_length
      metum['url'] = file.public_url
      raise ValueError, "#{metum['basename']} md5 mismatch" if metum['md5'] != file.etag
    end

    bucket.files.create key: 'idk/manifest.json',
                        body: JSON[meta],
                        public: true
  end

  desc "Prepare a description to paste into GitHub's release page"
  task :describe_release do
    require 'filesize'

    desc_md = <<EOF
Infrastructure Development Kit #{idk_version}
===============================#{'=' * idk_version.length}

Downloads
---------

EOF

    bucket.files.all(prefix: "idk/#{idk_version}").each do |file|
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
        found = true if line.strip == idk_version
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
