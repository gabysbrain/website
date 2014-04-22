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
      # need to convert latex special characters, like {\"o} to unicode
      @@bibtex[key].convert_latex
      CiteProc.process(@@bibtex[key].to_citeproc, :style => @@cite_style)
    end

    def find_pubs(search_key, author)
      bib_name = BibTeX::Name.parse(author)
      results = @@bibtex.query(search_key) do |e|
        e.respond_to?(:author) and e.author and e.author.include? bib_name
      end
      results.sort! {|x,y| y.year.to_i-x.year.to_i}
      results.map {|x| x.key}
    end
  end
end

::Middleman::Extensions.register(:citations, Citations)

