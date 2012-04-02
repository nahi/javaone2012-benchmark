# encoding: utf-8
require_relative "../lib/rbtree_map"

class BenchmarkApp
  WARMUP_TIME = 10

  def run(file)
    start = Time.now
    while Time.now - start < WARMUP_TIME
      execute(file)
    end
    execute(file)
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
          raise "wrong value! #{map.get(key)} != #{value}"
        end
      end
    end
    (Time.now - start) * 1000
  end
end

file = ARGV.shift or raise
puts BenchmarkApp.new.run(file)
