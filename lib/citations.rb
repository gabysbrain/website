require "middleman-core"
require "bibtex"
require "citeproc"

class Citations < Middleman::Extension
  option :bibtex, "", "The path to the bibtex file to use"
  option :style, "chicago-author-date", "The citation style to use"

  def initialize(app, options_hash={}, &block)
    super

    @@bibtex = BibTeX.open(options.bibtex)
    # for some reason the options function is the one from 
    # middleman-deploy in the helper methods below...
    @@cite_style = options.style
  end

  helpers do
    def cite_full(key)
      CiteProc.process(@@bibtex[key].to_citeproc, :style => @@cite_style)
    end
  end
end

::Middleman::Extensions.register(:citations, Citations)

