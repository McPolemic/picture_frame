#!/usr/bin/env ruby
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 4000

FORMATS = %w(jpg jpeg gif png)
PICTURES_PATH = ENV.fetch("PICTURES_PATH")
REFRESH_IN_MS = ENV.fetch("REFRESH_IN_MS", 3_000)

def all_pictures(path)
  suffixes = FORMATS + FORMATS.map(&:upcase)

  suffixes.flat_map do |suffix|
    search_string = File.join(path, "**/*.#{suffix}")
    Dir.glob(search_string)
  end.reject{ |path| File.size(path) < 1_000 }
     .reject{ |path| path.downcase.include? "thumbnail" }
end

PICTURES = all_pictures(PICTURES_PATH)

get '/' do
  erb :index
end

get '/random' do
  picture_path = PICTURES.sample
  logger.info "Serving #{picture_path}"

  send_file(picture_path)
end

get '/public/*' do
  picture_path = File.join(PICTURES_PATH, params[:splat].first)
  send_file(picture_path)
end

__END__

@@ index
<html>
  <head>
    <title>Picture Frame</title>
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <style>
img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

body {
  background-color: black;
}
    </style>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
            integrity="sha256-k2WSCIexGzOj3Euiig+TlR8gA0EmPjuc79OEeY5L45g="
            crossorigin="anonymous"></script>
    <script>
$(document).ready(function() {
  setInterval(function() {
    $('img').prop("src", "/random?dummy=" + Date.now());
  }, <%= REFRESH_IN_MS %>);
});
    </script>
  </head>
  <body>
  <img src="/random">
  </body>
</html>

