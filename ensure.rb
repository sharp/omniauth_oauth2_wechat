def test
  @a = "a" + nil
ensure
  puts "ok"
end

test
