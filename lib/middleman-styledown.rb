# Require core library
require 'middleman-core'

class StyleguideResource < ::Middleman::Sitemap::Resource
  def intitialize(store, path)
    puts "here 2"
    super
    puts "here 3"
  end

  def render(opts={}, locs={}, &block)
    puts "here 1"
    Styledown.parse([
      './styledown_config.md',
      'source/stylesheets/**.scss'
    ])
  end

  def template?
    false
  end

  def source_file
    nil
  end

  def binary?
    false
  end

  def raw_data
    {}
  end
end

# Extension namespace
class MiddlemanStyledown < ::Middleman::Extension
  #option :my_option, 'default', 'An example option'
  # TODO: need to allow user to config what files to use

  def initialize(app, options_hash={}, &block)
    # Call super to build options from the options_hash
    super

    require 'styledown'

    # set up your extension
    # TODO: need to automatically create the config file
  end

  def after_configuration
    # Do something
  end

  # Create a new page for the sitemap
  # TODO: let user set this page
  def manipulate_resource_list(resources)
    # cheat to get the store
    store = resources[0].store
    r = StyleguideResource.new(store, 'style_guide.html')
    resources.push(r)
  end

end

# Register extensions which can be activated
# Make sure we have the version of Middleman we expect
# Name param may be omited, it will default to underscored
# version of class name

MiddlemanStyledown.register(:styledown)
