# encoding: utf-8
require_relative "../lib/rbtree_map"

class BenchmarkApp
  TIMES = 5

  def run(file)
    TIMES.times do
      execute(file)
    end
    start = Time.now
    execute(file)
    puts (Time.now - start) * 1000
  end

  def execute(file)
    map = RBTreeMap.newInstance
    File.open(file).each_line do |line|
      key, value, _ = line.split(',', 3)
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

file = ARGV.shift or raise
BenchmarkApp.new.run(file)
