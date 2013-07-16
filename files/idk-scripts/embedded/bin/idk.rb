#!/opt/idk/embedded/bin/ruby

require 'pathname'
require 'thor'

class IDKCLI < Thor
  check_unknown_options! except: [ :exec ]
  stop_on_unknown_option! :exec

  map '-h' => :help,
      '--help' => :help

  desc 'exec COMMAND ...', 'Run a shell command in IDK context'
  def exec(*command)
    setup_env
    Kernel.exec(*command)
  end

  desc :solo, 'Set up the workstation with chef-solo'
  def solo
    setup_env
    Dir::chdir "/opt/idk/solo" do
      Kernel.exec(*maybe_sudo('chef-solo', '-c', 'solo.rb', '-j', 'dna.json'))
    end
  end

  private

  VAR = Pathname.new('/var/local/lib/idk')

  def var_path
    @var_path ||=
      begin
        vp = VAR.join('user', Etc.getpwuid.name)
        if vp.exist?
          fatal! "#{vp} is not owned by user" unless vp.owned?
          fatal! "#{vp} is a symlink" if vp.symlink?
          fatal! "#{vp} is not a directory" unless vp.directory?
        else
          vp.mkpath
        end
        vp.chmod(0700)
        vp
      end
  end

  def user_gem_dir
    @user_gem_dir ||= var_path.join('rubygems', 'default')
  end

  def setup_env
    ENV['GEM_HOME'] = user_gem_dir.to_s
    ENV['GEM_PATH'] = "#{user_gem_dir}:#{Gem.default_dir}"
    ENV['PATH'] = "/opt/idk/embedded/bin:#{user_gem_dir.join('bin')}:#{ENV['PATH']}"
    say_status 'ADVICE', "Add this line to your .profile: source /opt/idk/profile.sh", :yellow unless ENV['idk_profile_loaded']
  end

  def maybe_sudo(*cmd)
    if Process::Sys.getuid.zero?
      cmd
    else
      if cmd.length == 1
        "sudo #{cmd.first}"
      else
        ['sudo', *cmd]
      end
    end
  end

  def fatal!(message)
    say_status 'FATAL', message, :red
    exit 1
  end
end

$0 = ENV.delete('IDK0') || $0
IDKCLI.start(ARGV)
