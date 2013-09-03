require 'pathname'
require 'shellwords'

require 'thor'

module IDK
  VERSION = (Gem.loaded_specs['idk-cli'].version.to_s rescue 'INLINE')

  module Path
    ROOT = Pathname.new('/opt/idk')
    EMBEDDED = ROOT.join('embedded')
    SOLO = ROOT.join('solo')

    VAR = Pathname.new('/var/local/lib/idk')

    def self.user_var
      @user_var ||=
        begin
          user_var = VAR.join('user', Etc.getpwuid.name)
          if user_var.exist?
            fatal! "#{user_var} is not owned by user" unless user_var.owned?
            fatal! "#{user_var} is a symlink" if user_var.symlink?
            fatal! "#{user_var} is not a directory" unless user_var.directory?
          else
            user_var.mkpath
          end
          user_var.chmod(0700)
          user_var
        end
    end

    def self.gem_home
      @user_gem_home ||= user_var.join('rubygems', 'default').to_s
    end

    def self.gem_path
      "#{gem_home}:#{Gem.default_dir}"
    end
  end

  class CLI < Thor
    include Thor::Actions

    check_unknown_options! except: [ :exec ]
    stop_on_unknown_option! :exec

    map '-h' => :help,
        '--help' => :help,
        '--version' => :version

    desc 'exec COMMAND ...', 'Run a shell command in IDK context'
    def exec(*command)
      exec! *command
    end

    desc 'sudo COMMAND ...', 'Run a shell command in IDK context as root'
    def sudo(*command)
      opts = (command.last.is_a?(Hash) ? command.pop : {})
      opts[:as_root] = true
      command << opts
      exec! *command
    end

    desc :setup, "Set up the workstation and user's environment"
    def setup
      profile_sh = Path::ROOT.join('profile.sh')

      inside ENV['HOME'] do
        profiles = []

        # find bash's preferred init file
        bash_preferred = %w[.bash_profile .bash_login].
          find { |f| File.exist?(f) }
        profiles << bash_preferred if bash_preferred

        zsh_preferred = %w[.zprofile .zlogin].
          map { |f| ENV['ZDOTDIR'] ? File.join(ENV['ZDOTDIR'], f) : f }.
          find { |f| File.exist?(f) }
        if zsh_preferred
          profiles << zsh_preferred
        elsif ENV['SHELL'] =~ /\/zsh[^\/]*$/
          profiles << ( ENV['ZDOTDIR'] ? File.join(ENV['ZDOTDIR'], '.zprofile') : '.zprofile' )
        end

        profiles << '.profile'

        profiles.each do |profile|
          create_file profile unless File.exist?(profile)
          append_to_file profile, "\n# Infrastructure Development Kit\nif test -s #{profile_sh} ; then source #{profile_sh} ; fi\n"
        end
      end

      if ENV['idk_rvm_path']
        create_link File.join(ENV['idk_rvm_path'], 'hooks', 'after_use_idk'),
                    profile_sh
      end
    end

    desc :version, 'Display version', :hidden => true
    def version
      puts "IDK #{VERSION}"
    end

    def self.start(given_args=ARGV, config={})
      if idk0 = ENV.delete('IDK0')
        $0 = idk0
      end

      config[:shell] ||= Thor::Base.shell.new
      setup_env(config[:shell])

      cmdname = File.basename($0)
      if cmdname != 'idk' && Path::EMBEDDED.join('bin', cmdname).exist?
        given_args = given_args.dup.unshift('exec', cmdname)
      end

      super(given_args, config)
    end

    private

    def self.setup_env(shell=nil)
      shell ||= Thor::Base.shell.net

      ENV['GEM_HOME'] = Path.gem_home
      ENV['GEM_PATH'] = Path.gem_path

      ENV['IDK_ORIG_PATH'] = ENV['PATH']
      ENV['PATH'] = [
        "#{Path::EMBEDDED}/bin",
        "#{Path.gem_home}/bin",
        Path::ROOT.join('bin').to_s,
        *ENV['PATH'].split(':').reject do |dir|
          dir =~ /^(?:#{Regexp.escape(Path::ROOT.to_s)}|#{Regexp.escape(Path::VAR.to_s)})/
        end
      ].join(':')

      # Sanity check (redundant on `idk setup`)
      return if File.basename($0) == 'idk' && ARGV.first == 'setup'
      setup_stamp = Path::VAR.join('setup.stamp')
      if !setup_stamp.exist?
        shell.say_status 'WARNING',
                         'Unconfigured workstation',
                         :red
        shell.say_status 'ADVICE',
                         'Run "idk setup" to configure your environment',
                         :yellow
      elsif (setup_v = setup_stamp.read.strip) != VERSION.to_s.strip
        shell.say_status 'WARNING',
                         "Workstation configured for version #{setup_v}, not currently installed #{VERSION}.",
                         :red
        shell.say_status 'ADVICE',
                         'Run "idk setup" to configure your environment',
                         :yellow
      elsif (!!ENV['idk_interactive']) && (!ENV['idk_profile_loaded'])
        shell.say_status 'WARNING',
                         'Unconfigured environment',
                         :red
        shell.say_status 'ADVICE',
                         'Try to log out and log in again, or re-run "idk setup"',
                         :yellow
        shell.say_status 'ADVICE',
                         'If this does not help, add following line to your .profile:',
                         :yellow
        shell.say_status nil,
                         "source /opt/idk/profile.sh",
                         :yellow
      end
    end

    def fatal!(message)
      say_status 'FATAL', message, :red
      exit 1
    end

    def exec!(*command)
      if command.last.is_a? Hash
        options = command.pop
      else
        options = {}
      end

      command_str = command.join(' ')
      if options[:as_root]
        if Process::Sys.getuid.zero?
          verb = :exec
        else
          verb = :sudo
          if command.length == 1
            command = ["sudo -E #{command.first}"]
          else
            command.unshift '-E'
            command.unshift 'sudo'
          end
        end
      else
        verb = :exec
      end

      say_status verb, command_str, :green if options[:verbose]
      Kernel.exec(*command)
    end
  end
end
