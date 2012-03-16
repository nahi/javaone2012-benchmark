# -*- encoding: utf-8 -*-
require File.expand_path('./helper', File.dirname(__FILE__))
require 'rbtree_map'

class TestRBTreeMap < Test::Unit::TestCase
  def test_random
    h = RBTreeMap.newInstance
    size = 1000
    size.times do |idx|
      key = rand(size).to_s
      h.put(key, key)
      assert_equal key, h.get(key)
    end
    assert h.height > 0
  end
end
