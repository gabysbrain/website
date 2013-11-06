require 'tilt/template'

module Tilt
  class MultiMarkdownTemplate < Template

    def self.engine_initialized?
      # make sure mutlimarkdown is in the path
      # from http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
      cmd = 'multimarkdown'
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable? exe
        }
      end
      return nil
    end

    def initialize_engine
    end

    def prepare
      @source = data
    end

    def evaluate(scope, locals, &block)
      require 'open3'
      stdout, stderr, status = Open3.capture3("multimarkdown -t html -s", 
                                              :stdin_data=>@source)
      stdout
    end

    def allows_script?
      false
    end
  end

  Tilt.register Tilt::MultiMarkdownTemplate, 'multimarkdown'
end

