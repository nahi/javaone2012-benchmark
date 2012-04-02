class RBTreeMap
  class RBTree
    attr_reader :key, :value
    attr_accessor :color, :left, :right

    def initialize(key, value)
      @key, @value = key, value
      @left = @right = EMPTY
      # new node is added as RED
      @color = :RED
    end

    def make_as_root
      @color = :BLACK
    end

    def empty?
      false
    end

    def red?
      @color == :RED
    end

    def black?
      @color == :BLACK
    end

    # returns new_root
    def insert(key, value)
      case key <=> @key
      when -1
        @left = @left.insert(key, value)
      when 0
        @value = value
      when 1
        @right = @right.insert(key, value)
      end
      # Rebalance of Left leaning red-black trees
      # http://www.cs.princeton.edu/~rs/talks/LLRB/LLRB.pdf
      insert_rotate_left.insert_rotate_right.insert_color_flip
    end

    # returns value
    def retrieve(key)
      ptr = self
      while !ptr.empty?
        case key <=> ptr.key
        when -1
          ptr = ptr.left
        when 0
          return ptr.value
        when 1
          ptr = ptr.right
        end
      end
      nil
    end

    def height
      @left.height + (black? ? 1 : 0)
    end

    class EmptyTree < RBTree
      def initialize
        @node_class = RBTree
        @value = nil
        @color = :BLACK
      end

      def empty?
        true
      end

      # returns new_root
      def insert(key, value)
        @node_class.new(key, value)
      end

      def height
        0
      end
    end
    private_constant :EmptyTree
    EMPTY = EmptyTree.new.freeze

  protected

    # Left leaning RBTree rebalancing methods after insert

    # Do roate_left after insert if needed
    def insert_rotate_left
      if @left.black? and @right.red?
        rotate_left
      else
        self
      end
    end

    # Do rotate_right after insert if needed
    def insert_rotate_right
      if @left.red? and @left.left.red?
        rotate_right
      else
        self
      end
    end

    # Do color_flipt after insert if needed
    def insert_color_flip
      if @left.red? and @right.red?
        color_flip
      else
        self
      end
    end

    def swap_color(other)
      @color, other.color = other.color, @color
    end

  private

    # Right single rotation
    # (b a (D c E)) where D and E are RED --> (d (B a c) E)
    #
    #   b              d
    #  / \            / \
    # a   D    ->    B   E
    #    / \        / \
    #   c   E      a   c
    #
    def rotate_left
      root = @right
      @right = root.left
      root.left = self
      root.swap_color(root.left)
      root
    end

    # Left single rotation
    # (d (B A c) e) where A and B are RED --> (b A (D c e))
    #
    #     d          b
    #    / \        / \
    #   B   e  ->  A   D
    #  / \            / \
    # A   c          c   e
    #
    def rotate_right
      root = @left
      @left = root.right
      root.right = self
      root.swap_color(root.right)
      root
    end

    # Flip colors between red children and black parent
    # (b (A C)) where A and C are RED --> (B (a c))
    #
    #   b          B
    #  / \   ->   / \
    # A   C      a   c
    #
    def color_flip
      @left.color = @right.color = :BLACK
      self.color = :RED
      self
    end
  end

  class << self
    alias newInstance new
  end

  def initialize
    @root = RBTree::EMPTY
  end

  def get(key)
    @root.retrieve(key)
  end

  def put(key, value)
    @root = @root.insert(key, value)
    @root.make_as_root
    value
  end

  def height
    @root.height
  end
end

require 'rbtree_map_debug' if $DEBUG
