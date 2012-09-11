require 'net/http/post/multipart'

url = URI.parse('http://localhost:8080/medias')
File.open("./video.png") do |image|
  req = Net::HTTP::Post::Multipart.new url.path,
  "file" => UploadIO.new(image, "image/x-png", "video.png")
  res = Net::HTTP.start(url.host, url.port) do |http|
    puts http.request(req)
  end
end
