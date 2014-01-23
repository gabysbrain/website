require 'lib/tilt-multimarkdown'
require 'lib/social_helpers'
require 'lib/citations'
require 'nokogiri'

helpers SocialHelpers
#helpers Test

###
# Blog settings
###

Time.zone = "Vienna"

activate :blog do |blog|
  blog.prefix = "blog"
  blog.permalink = ":year/:month/:day/:title.html"
  blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  blog.layout = "post"
  # blog.summary_separator = /(<!-- more -->)/
  # blog.summary_length = 250
  blog.summary_generator = Proc.new do |resource, rendered, length, ellipses|
    summary_sep = /(<!-- more -->)/
    # first check if there's a read more link
    # otherwise trim by length
    if rendered.match(summary_sep)
      rendered = rendered.split(summary_sep).first
    else
      rendered = resource.default_summary_generator(rendered, length, ellipses)
    end
    # finally make sure we cut off before the first sub-section
    rendered = rendered.split(/<h2.*>/).first
    rendered
  end
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  blog.default_extension = ".multimarkdown.erb"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/:num"
end

activate :citations do |options|
  options.bibtex = "/Users/tom/Dropbox/Research/All.bib"
  options.style = "ieee"
end

activate :directory_indexes

activate :deploy do |deploy|
  # build before deployment
  deploy.build_before = true

  # publish to github pages
  deploy.method = :git
  deploy.remote = 'gh-pages'
  deploy.branch = 'master'
end

#set :build_dir, 'tmp'

page "/feed.xml", :layout => false

# section layouts
page "/blog/*",    :layout => "post"
page "/project/*", :layout => "project"

###
# Sprockets
###

# Foundation 5 js path
ready do 
  sprockets.append_path File.join(root, 'bower_components')
end

### 
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
#compass_config do |config|
# config.output_style = :compact
#end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  
  # Minify Javascript on build
  activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress images after build
  activate :imageoptim do |options|
    options.threads = true

    # disable pngout
    options.pngout_options = false
  end
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end
