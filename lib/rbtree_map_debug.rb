# methods for debugging
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
