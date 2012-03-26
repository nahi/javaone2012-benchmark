require_relative "../lib/rbtree_map"

file = ARGV.shift or raise

def benchmark(&block)
  begin
    start = Time.now
    yield
    finished = Time.now
  ensure
    puts "経過時間 #{(finished - start) * 1000} [msec]"
  end
end

print "動作確認..."
map = RBTreeMap.newInstance
File.open(file).each_line do |line|
  key, value, height = line.chomp.split(',', 3)
  map.put(key, value)
end
File.open(file).each_line do |line|
  key, value, _ = line.split(',', 3)
  if map.get(key) != value
    raise "値の不一致 #{map.get(key)} != #{value} at line #{line}"
  end
end
puts "OK"

puts "ベンチマーク..."
5.times do |idx|
  print "ベンチマーク #{idx + 1} 回目: "
  benchmark do
    map = RBTreeMap.newInstance
    File.open(file).each_line do |line|
      key, value, height = line.chomp.split(',', 3)
      map.put(key, value)
    end
    File.open(file).each_line do |line|
      key, value, _ = line.split(',', 3)
      if map.get(key) != value
        puts "wrong value! #{map.get(key)} != #{value}"
      end
    end
  end
end
