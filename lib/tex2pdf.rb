
module Tex2Pdf
  class << self
    def registered(app)
      app.after_build do |builder|
        `pdflatex -halt-on-error -output-directory build build/cv.tex`
        if $?.exitstatus != 0
          raise "could not create cv.pdf (check log)"
        end
        FileUtils.rm("build/cv.tex")
        FileUtils.rm("build/cv.aux")
        FileUtils.rm("build/cv.log")
        FileUtils.rm("build/cv.out")
      end
      alias :included :registered
    end
  end
end

::Middleman::Extensions.register(:cvmaker, Tex2Pdf)

