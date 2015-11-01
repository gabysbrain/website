
require 'middleman-citation'

module CiteHelpers
  def cite_inline(key)
    "&nbsp;" + (content_tag 'span', {:class => 'inline-citation'} do
      content_tag 'span', {:class => 'citation'} do
        cite_full(key)
      end
    end)
  end
end

