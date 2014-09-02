require 'lib/social_helpers'
require 'lib/date_helpers'
require 'lib/tex2pdf'
require 'nokogiri'
require 'middleman-citation'

helpers SocialHelpers
helpers DateHelpers
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

configure :development do
  activate :citation do |options|
    options.bibtex = "/Users/tom/Dropbox/Research/all.bib"
    options.style = "ieee"
  end
end

activate :directory_indexes

# use debugging javascripts
set :debug_assets, true

ignore "/cv.pdf"

activate :deploy do |deploy|
  # build before deployment
  deploy.build_before = true

  # publish to github pages
  deploy.method = :git
  deploy.remote = 'gh-pages'
  deploy.branch = 'master'
end

activate :livereload

activate :google_drive, load_sheets: {
  sa_reading_group: '1O_9o7rOx5nJEyqzruzuZFXr3xcYmlVOMG40VF9SRcDo'
}

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
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join(root, @bower_config["directory"])
end

### 
# Compass
###

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :partials_dir, 'partials'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  
  # Minify Javascript on build
  activate :minify_javascript

  activate :citation do |options|
    options.bibtex = "all.bib"
    options.style = "ieee"
  end
  
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

  activate :cvmaker
end

