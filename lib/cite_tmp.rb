
require 'middleman-citation'

module CiteHelpers
  def cite_inline(key)
    content_tag 'div', {:class => 'inline-citation'} do
      content_tag 'p' do
        cite_full(key)
      end
    end
  end
end

