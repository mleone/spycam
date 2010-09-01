APP_DIR = File.expand_path File.dirname(__FILE__)
GEM_DIR = File.join(APP_DIR, 'vendor', 'gems')
PUBLIC_DIR = File.join(APP_DIR, 'public')


Dir.entries(GEM_DIR).each{|dir| $LOAD_PATH << File.join GEM_DIR, dir, 'lib'}

# Vendorize all gems in vendor directory.
Dir.entries(GEM_DIR).each do |dir| 
  gem_lib = File.join GEM_DIR, dir, 'lib'
  $LOAD_PATH << gem_lib if File.exist?(gem_lib)
end

require "rack"
require "sinatra/base"

require "android"

DROID = Android.new

TEMPLATE = <<HTML
  <!DOCTYPE html>
  <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <title>Android Camera</title>
    </head>
    <body>
        <a href="/"><img src="latest.png"></a>
    </body>
  </html> 
HTML

class SpyCam < Sinatra::Base 
  set :public, File.join(APP_DIR, 'public')

  get "/" do
    snapshot_path = File.join PUBLIC_DIR, 'latest.png'
    DROID.cameraCapturePicture snapshot_path
    TEMPLATE
  end
end

SpyCam.run!
