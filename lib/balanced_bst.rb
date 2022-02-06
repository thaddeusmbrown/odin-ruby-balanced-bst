require 'pry-byebug'

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def insert(value)
    # binding.pry
    if value == self.data
      return 'Error: value already in binary search tree'
    elsif value < self.data && self.left.nil?
      self.left = Node.new(value)
      return
    elsif value > self.data && self.right.nil?
      self.right = Node.new(value)
      return
    elsif value < self.data
      self.left.insert(value)
    else
      self.right.insert(value)
    end
  end

  def self.delete(node, value)
    # binding.pry
    # case where deleted node is leaf
    if node.data == value && node.left.nil? && node.right.nil?
      temp = node.right
      node = nil
      return temp
    end

    # case where deleted node has more than one child
    if node.data == value && !node.left.nil? && !node.right.nil?
      temp = min_value_node(node.right)
      delete(node, temp)
      node.data = temp
      return node
    end

    # case where deleted node has one child
    if node.data == value
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      else
        temp = node.left
        node = nil
        return temp
      end
    end

    # if value not found
    if value < node.data
      node.left = delete(node.left, value)
    else
      node.right = delete(node.right, value)
    end

    return node
  end

  def self.min_value_node(node)
    while !node.left.nil?
      current = self.min_value_node(node.left)
    end
    return node.data
  end

  def self.find(node, value)
    # binding.pry
    return node if node.data == value

    if value < node.data
      return find(node.left, value)
    else
      return find(node.right, value)
    end

    return 'Error: value not in tree'
  end

  def self.level_order(node, array = [], queue = [])
    if block_given?
      return array if node.nil?
      array.push(node.data)
      queue.push(node.left, node.right)
      yield(node.left, array, queue)
      yield(node.right, array, queue)
    else
      level_order(node, array, queue) do |yield_node, yield_array, yield_queue|
        next_node = yield_queue.shift
        level_order(next_node, yield_array, yield_queue)
      end
      return array
    end
  end

  def self.inorder(node, array = [])
    if block_given?
      return array if node.nil?

      yield(node.left, array)
      array.push(node.data)
      yield(node.right, array)
    else
      inorder(node, array) do |yield_node, yield_array|
        inorder(yield_node, yield_array)
      end
    end
  end

  def self.preorder(node, array = [])
    if block_given?
      return array if node.nil?

      array.push(node.data)
      yield(node.left, array)
      yield(node.right, array)
    else
      preorder(node, array) do |yield_node, yield_array|
        preorder(yield_node, yield_array)
      end
    end
  end

  def self.postorder(node, array = [])
    if block_given?
      return array if node.nil?

      yield(node.left, array)
      yield(node.right, array)
      array.push(node.data)
    else
      postorder(node, array) do |yield_node, yield_array|
        postorder(yield_node, yield_array)
      end
    end
  end

  def self.height(node, left_height = 0, right_height = 0)
    return (left_height > right_height ? left_height : right_height) if node.left.nil? && node.right.nil?

    height(node.left, left_height + 1, right_height) unless node.left.nil?
    height(node.right, left_height, right_height + 1) unless node.right.nil?
  end

  def depth(node, compare_node = self, depth = 0)
    #binding.pry
    return depth if node == compare_node

    depth += 1
    left_depth = depth(node, compare_node.left, depth) unless compare_node.left.nil?
    right_depth = depth(node, compare_node.right, depth) unless compare_node.right.nil?
    return (left_depth.nil? ? right_depth : left_depth)
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    array = array.sort.uniq
    @root = build_tree(array, 0, array.length - 1)
  end

  def build_tree(array, start, last)
    # base case
    return nil if start > last

    mid = (start + last) / 2
    node = Node.new(array[mid])
    node.left = build_tree(array, start, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    return node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# array = Array.new(15) { rand(0..100) }
array = (1..9).to_a
tree = Tree.new(array)
tree.pretty_print
depth = tree.root.depth(tree.root.right.right.left)
p depth
