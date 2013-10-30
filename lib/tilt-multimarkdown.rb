require 'tilt/template'

module Tilt
  class MultiMarkdownTemplate < Template

    def self.engine_initialized?
      defined? MultiMarkdown
    end

    def initialize_engine
      require_template_library 'multimarkdown'
    end

    def prepare
      @engine = ::MultiMarkdown.new(data)
    end

    def evaluate(scope, locals, &block)
      @engine.to_html
    end

    def allows_script?
      false
    end
  end

  Tilt.register Tilt::MultiMarkdownTemplate, 'multimarkdown'
end

