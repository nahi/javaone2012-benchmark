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

    def set_root
      @color = :BLACK
    end

    def red?
      @color == :RED
    end

    def black?
      @color == :BLACK
    end

    # returns new_root
    def insert(key, value)
      ret = self
      case key <=> @key
      when -1
        @left = @left.insert(key, value)
        ret = rebalance_for_left_insert
      when 0
        @value = value
      when 1
        @right = @right.insert(key, value)
        ret = rebalance_for_right_insert
      end
      ret.pullup_red
    end

    # returns value
    def retrieve(key)
      ptr = self
      while ptr != EMPTY
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
      [@left.height, @right.height].max + (black? ? 1 : 0)
    end

    class EmptyTree < RBTree
      def initialize
        @value = nil
        @color = :BLACK
      end

      # returns new_root
      def insert(key, value)
        RBTree.new(key, value)
      end

      # returns value
      def retrieve(key)
        nil
      end

      def height
        0
      end
    end
    private_constant :EmptyTree
    EMPTY = EmptyTree.new.freeze

  protected

    def need_rebalance?
      red? and (@right.red? or @left.red?)
    end

    def color_flip(other)
      @color, other.color = other.color, @color
    end

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
      root.color_flip(root.left)
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
      root.color_flip(root.right)
      root
    end

    # Pull up red nodes
    # (b (A C)) where A and C are RED --> (B (a c))
    #
    #   b          B
    #  / \   ->   / \
    # A   C      a   c
    #
    def pullup_red
      if black? and @left.red? and @right.red?
        @left.color = @right.color = :BLACK
        self.color = :RED
      end
      self
    end

  private

    # trying to rebalance when the left sub-tree is 1 level higher than the right
    def rebalance_for_left_insert
      if black? and @left.need_rebalance?
        # move 1 black from the left to the right by single/double rotation
        if @left.right.red?
          @left = @left.rotate_left
        end
        rotate_right
      else
        self
      end
    end

    # trying to rebalance when the right sub-tree is 1 level higher than the left
    def rebalance_for_right_insert
      if black? and @right.need_rebalance?
        if @right.left.red?
          @right = @right.rotate_right
        end
        rotate_left
      else
        self
      end
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
    @root.set_root
    value
  end

  def height
    @root.height
  end
end

if $DEBUG
class RBTreeMap
  class RBTree
    def dump_tree(io, indent = '')
      @right.dump_tree(io, indent + '  ')
      io << indent << sprintf("#<%s:0x%010x %s %s> => %s", self.class.name, __id__, @color, @key.inspect, @value.inspect) << $/
      @left.dump_tree(io, indent + '  ')
    end

    def dump_sexp
      left = @left.dump_sexp
      right = @right.dump_sexp
      if left or right
        '(' + [@key, left || '-', right].compact.join(' ') + ')'
      else
        @key
      end
    end

    class EmptyTree < RBTree
      def dump_tree(io, indent = '')
        # intentionally blank
      end

      def dump_sexp
        # intentionally blank
      end
    end
  end

  def dump_tree(io = '')
    @root.dump_tree(io)
    io << $/
    io
  end

  def dump_sexp
    @root.dump_sexp || ''
  end
end
end
