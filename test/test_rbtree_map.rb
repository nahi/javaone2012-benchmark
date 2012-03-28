# -*- encoding: utf-8 -*-
require File.expand_path('./helper', File.dirname(__FILE__))
$DEBUG = true
require 'rbtree_map'

class RBTreeMap
  class RBTree
    def size
      @left.size + 1 + @right.size
    end

    class EmptyTree < RBTree
      def size
        0
      end
    end
  end

  def dump_tree
    @root.dump_tree
  end

  def dump_sexp
    @root.dump_sexp || ''
  end

  def size
    @root.size
  end
end

class TestRBTreeMap < Test::Unit::TestCase
  def test_tree_rotate_RR
    h = RBTreeMap.new
    assert_equal '', h.dump_sexp
    h.put('a', 1)
    assert_equal 'a', h.dump_sexp
    h.put('b', 2)
    assert_equal '(b a)', h.dump_sexp
    h.put('c', 3)
    assert_equal '(b a c)', h.dump_sexp
    h.put('d', 4)
    assert_equal '(b a (d c))', h.dump_sexp
    h.put('e', 5)
    assert_equal '(d (b a c) e)', h.dump_sexp
  end

  def test_tree_rotate_LL
    h = RBTreeMap.new
    h.put('e', 1)
    h.put('d', 2)
    assert_equal '(e d)', h.dump_sexp
    h.put('c', 3)
    assert_equal '(d c e)', h.dump_sexp
    h.put('b', 4)
    assert_equal '(d (c b) e)', h.dump_sexp
    h.put('a', 5)
    assert_equal '(d (b a c) e)', h.dump_sexp
  end

  def test_tree_rotate_RL
    h = RBTreeMap.new
    h.put('b', 1)
    h.put('a', 2)
    h.put('g', 3)
    h.put('d', 4)
    h.put('h', 5)
    assert_equal '(g (b a d) h)', h.dump_sexp
    h.put('c', 6)
    assert_equal '(g (b a (d c)) h)', h.dump_sexp
    h.put('e', 6)
    assert_equal '(d (b a c) (g e h))',  h.dump_sexp
    h.put('f', 6)
    assert_equal '(d (b a c) (g (f e) h))', h.dump_sexp
  end

  def test_tree_rotate_LR
    h = RBTreeMap.new
    h.put('g', 1)
    h.put('b', 2)
    h.put('h', 3)
    h.put('i', 4)
    h.put('a', 5)
    h.put('d', 6)
    h.put('0', 7)
    h.put('c', 8)
    h.put('e', 9)
    assert_equal '(d (b (a 0) c) (g e (i h)))', h.dump_sexp
    h.put('f', 10)
    assert_equal '(d (b (a 0) c) (g (f e) (i h)))', h.dump_sexp
  end

  def test_aref_nil
    h = RBTreeMap.new
    h.put('abc', 1)
    assert_equal nil, h.get('def')
  end

  def test_empty
    h = RBTreeMap.new
    h.put('abc', 0)
    assert_equal nil, h.get('')
    h.put('', 1)
    assert_equal 1, h.get('')
  end

  def test_aref_single
    h = RBTreeMap.new
    h.put('abc', 1)
    assert_equal 1, h.get('abc')
  end

  def test_aref_double
    h = RBTreeMap.new
    h.put('abc', 1)
    h.put('def', 2)
    assert_equal 1, h.get('abc')
    assert_equal 2, h.get('def')
  end

  def test_aset_override
    h = RBTreeMap.new
    h.put('abc', 1)
    h.put('abc', 2)
    assert_equal 2, h.get('abc')
  end

  def test_split
    h = RBTreeMap.new
    h.put('abcd', 1)
    assert_equal 1, h.get('abcd')
    h.put('abce', 2)
    assert_equal 1, h.get('abcd')
    assert_equal 2, h.get('abce')
    h.put('abd', 3)
    assert_equal 1, h.get('abcd')
    assert_equal 2, h.get('abce')
    assert_equal 3, h.get('abd')
    h.put('ac', 4)
    assert_equal 1, h.get('abcd')
    assert_equal 2, h.get('abce')
    assert_equal 3, h.get('abd')
    assert_equal 4, h.get('ac')
  end

  def test_split_and_assign
    h = RBTreeMap.new
    h.put('ab', 1)
    h.put('a', 2)
    assert_equal 1, h.get('ab')
    assert_equal 2, h.get('a')
  end

  def test_push
    h = RBTreeMap.new
    assert_equal 0, h.size
    h.put('a', 1)
    assert_equal 1, h.get('a')
    h.put('ab', 2)
    assert_equal 1, h.get('a')
    assert_equal 2, h.get('ab')
    h.put('abc', 3)
    assert_equal 1, h.get('a')
    assert_equal 2, h.get('ab')
    assert_equal 3, h.get('abc')
    h.put('abd', 4)
    assert_equal 1, h.get('a')
    assert_equal 2, h.get('ab')
    assert_equal 3, h.get('abc')
    assert_equal 4, h.get('abd')
    h.put('ac', 5)
    assert_equal 1, h.get('a')
    assert_equal 2, h.get('ab')
    assert_equal 3, h.get('abc')
    assert_equal 4, h.get('abd')
    assert_equal 5, h.get('ac')
    h.put('b', 6)
    assert_equal 1, h.get('a')
    assert_equal 2, h.get('ab')
    assert_equal 3, h.get('abc')
    assert_equal 4, h.get('abd')
    assert_equal 5, h.get('ac')
    assert_equal 6, h.get('b')
    assert_equal 6, h.size
  end

  if RUBY_VERSION >= '1.9.0'
    # In contrast to RadixTree, RBTreeMap just uses String#<=> as-is
    def test_encoding
      h = RBTreeMap.new
      s = { 'ああ' => 1, 'あい' => 2, 'いい' => 3, 'いう' => 4, 'あ' => 5, 'あいう' => 6 }
      s.each do |k, v|
        h.put(k, v)
      end
      assert_equal 6, h.size
      s.each do |k, v|
        assert_equal v, h.get(k)
      end
      str = 'ああ'
      str.force_encoding('US-ASCII')
      # it's nil for RadixTree because RadixTree uses char-to-char comparison
      assert_equal 1, h.get(str)
    end
  end
end
