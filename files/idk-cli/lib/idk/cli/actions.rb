module IDK
  module CLI
    module Actions
      include Thor::Actions

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
              command = ["sudo /opt/idk/bin/idk exec #{command.first}"]
            else
              command = [ 'sudo', '/opt/idk/bin/idk', 'exec' ] + command
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
end
