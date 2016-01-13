
module LinkHelpers
  def edit_link
    #puts sitemap.current_resource
    # TODO: get page file from the sitemap or something
    curpath = current_page.source_file.scan(/\/source\/.*/)[0]
    link_to('Edit this page', "https://github.com/gabysbrain/website/#{curpath}",
            :class => 'edit-page-link')
  end
end

