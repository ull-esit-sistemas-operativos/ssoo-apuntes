require 'rake'

module Utils

    def copy_files(files, destination_directory, base_directory)
        files.each do |pathname|
            destination = pathname.sub(%r(^#{base_directory}), destination_directory)

            if File.exist? destination
                next if [File.ctime(pathname), File.mtime(pathname)].max <= \
                    [File.ctime(destination), File.mtime(destination)].max
            end
            
            Rake::FileUtilsExt.mkdir_p File.dirname(destination)
            Rake::FileUtilsExt.cp pathname, destination
        end
    end
    module_function :copy_files

    def is_gem_available?(gemname, &block)
        if Gem::Specification::find_all_by_name(gemname).any?
            block.call() if block
            return true
        end
        return false
    end
    module_function :is_gem_available?

    def is_command_available(command, &block)
        extensions = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
            extensions.each do |extension|
                executable = File.join(path, "#{command}#{extension}")
                if File.executable?(executable) && ! File.directory?(executable)
                    block.call() if block
                    return true
                end
            end
        end
        false
    end
    module_function :is_command_available

    class EnvVar
        TRUTHY_VALUES = %w(t true yes y 1).freeze
        FALSEY_VALUES = %w(f false n no 0).freeze
      
        attr_reader :value
      
        def initialize(name)
          @value = ENV[name].to_s.downcase
        end
      
        def to_boolean
            return false if value.to_s.empty? || FALSEY_VALUES.include?(value.to_s)
            return true if TRUTHY_VALUES.include?(value.to_s)

          raise "Invalid value '#{value}' for boolean casting"
        end
    end

end