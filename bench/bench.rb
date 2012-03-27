# encoding: utf-8
require_relative "../lib/rbtree_map"

file = ARGV.shift or raise

def benchmark(&block)
  start = Time.now
  yield
  (Time.now - start) *1000
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

times = 5
puts "ウォームアップ... (#{times} 回)"
(times + 1).times do |idx|
  puts "ベンチマーク: " if idx == times
  elapsed = benchmark {
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
  }
  puts elapsed
end
