require 'pathname'

module IDK
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

    def self.setup_stamp
      user_var.join('setup.stamp')
    end

    def self.gem_home
      @user_gem_home ||= user_var.join('rubygems', 'default').to_s
    end

    def self.gem_path
      "#{gem_home}:#{Gem.default_dir}"
    end
  end
end
