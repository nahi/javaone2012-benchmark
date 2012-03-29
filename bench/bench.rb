# encoding: utf-8
require_relative "../lib/rbtree_map"

class BenchmarkApp
  TIMES = 5

  def run(file)
    TIMES.times do
      execute(file)
    end
    puts execute(file)
  end

  def execute(file)
    start = Time.now
    map = RBTreeMap.newInstance
    File.open(file) do |file|
      while line = file.gets
        key, value, _ = line.split(',')
        map.put(key, value)
      end
    end
    File.open(file) do |file|
      while line = file.gets
        key, value, _ = line.split(',')
        if map.get(key) != value
          puts "wrong value! #{map.get(key)} != #{value}"
        end
      end
    end
    (Time.now - start) * 1000
  end
end

file = ARGV.shift or raise
BenchmarkApp.new.run(file)
