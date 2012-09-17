require 'rubygems'
require 'curb'
c = Curl::Easy.new("http://localhost:10000/medias")
c.multipart_form_post = true
#c.headers["Transfer-Encoding"] = "chunked"
c.http_post(Curl::PostField.file('thing[file]', 'video.png'))
sleep(1)
