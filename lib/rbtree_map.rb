require 'rbtree_hash'

class RBTreeMap
  class << self
    alias newInstance new
  end

  def initialize
    @root = RBTreeHash::RBTree::EMPTY
  end

  def get(key)
    value = @root.retrieve(key.to_s)
    (value == RBTreeHash::RBTree::UNDEFINED) ? nil : value
  end

  def put(key, value)
    @root = @root.insert(key, value)
    @root.set_root
  end

  def height
    @root.check_height
  end
end
