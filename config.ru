require 'bundler/setup'
require 'rack/rewrite'
require 'sinatra/base'

# The project root directory
$root = ::File.dirname(__FILE__)

use Rack::Rewrite do
  # redirect old (and misspelled) wordpress link
  #r302 %r{/downloads/(.*)}, 'http://www.cs.sfu.ca/~ttorsney/personal/downloads/$1'
  r302 %r{/papers/(.*)}, 'http://www.cs.sfu.ca/~ttorsney/personal/papers/$1'
  r301 %r{2012/05/19/reproducible-research/$}, '/reproducable-research/'
  #r301 %r{[0-9]{4}/[0-9]{2}/[0-9]{2}(/.+)}, '$1'
end

class SinatraStaticServer < Sinatra::Base  

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  def send_sinatra_file(path, &missing_file_block)
    file_path = File.join(File.dirname(__FILE__), 'public',  path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i  
    File.exist?(file_path) ? send_file(file_path) : missing_file_block.call
  end

end

run SinatraStaticServer
