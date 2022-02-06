require 'pry-byebug'

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  def initialize(array)
    array = array.sort.uniq
    @root = build_tree(array, 0, array.length - 1)
  end

  def build_tree(array, start, last)
    # base case
    # binding.pry
    return nil if start > last

    mid = (start + last) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array, start, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    return node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    # binding.pry
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

# array = (Array.new(15) { rand(0..100) })
array = Array.new(15) { rand(0..100) }
tree = Tree.new(array)
tree.pretty_print
