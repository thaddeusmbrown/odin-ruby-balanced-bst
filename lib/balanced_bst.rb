# frozen_string_literal: true

# Description/nodes of binary search tree Tree class
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def insert(value)
    if value == data
      'Error: value already in binary search tree'
    elsif value < data && left.nil?
      self.left = Node.new(value)
      nil
    elsif value > data && right.nil?
      self.right = Node.new(value)
      nil
    elsif value < data
      left.insert(value)
    else
      right.insert(value)
    end
  end

  def self.delete(node, value)
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
      temp = if node.left.nil?
               node.right
             else
               node.left
             end
      node = nil
      return temp
    end

    # if value not found
    if value < node.data
      node.left = delete(node.left, value)
    else
      node.right = delete(node.right, value)
    end

    node
  end

  def self.min_value_node(node)
    min_value_node(node.left) until node.left.nil?
    node.data
  end

  def find(value, node = self)
    return node if node.data == value

    if value < node.data && !node.left.nil?
      find(value, node.left)
    elsif value > node.data && !node.right.nil?
      find(value, node.right)
    else
      'Error: value not in tree'
    end
  end

  def level_order(node = self, array = [], queue = [])
    if block_given?
      return array if node.nil?

      array.push(node.data)
      queue.push(node.left, node.right)
      yield(node.left, array, queue)
      yield(node.right, array, queue)
    else
      level_order(node, array, queue) do |_yield_node, yield_array, yield_queue|
        next_node = yield_queue.shift
        level_order(next_node, yield_array, yield_queue)
      end
      array
    end
  end

  def inorder(node = self, array = [])
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

  def preorder(node = self, array = [])
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

  def postorder(node = self, array = [])
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

  def height(node, height = 0)
    # base case: both children of a node are nil
    if node.left.nil? && node.right.nil?
      height
    else
      left_height = height(node.left, height) unless node.left.nil?
      right_height = height(node.right, height) unless node.right.nil?
      return left_height + 1 if right_height.nil?
      return right_height + 1 if left_height.nil?

      (left_height > right_height ? left_height + 1 : right_height + 1)
    end
  end

  def depth(node, compare_node = self, depth = 0)
    return depth if node == compare_node

    depth += 1
    left_depth = depth(node, compare_node.left, depth) unless compare_node.left.nil?
    right_depth = depth(node, compare_node.right, depth) unless compare_node.right.nil?
    (left_depth.nil? ? right_depth : left_depth)
  end

  # recursively check the height of root node and all sub-nodes, returning false if any differ in height by > 1
  def balanced?
    left_height = left.nil? ? 0 : height(left)
    right_height = right.nil? ? 0 : height(right)
    return false if (left_height - right_height).abs > 1

    left&.balanced?
    right&.balanced?
    true
  end
end

# Description/Binary Search Tree constructed recursively from an array with Node class
class Tree < Node
  attr_accessor :root

  def initialize(array)
    super
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
    node
  end

  def rebalance
    return self if root.balanced?

    sorted_array = inorder(root)
    Tree.new(sorted_array)
  end

  def balanced?
    @root.balanced?
  end

  def find(value)
    @root.find(value)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}" 
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# driver script
array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
tree.pretty_print
p "Balanced?: #{tree.balanced?}"
p "Level-order: #{tree.root.level_order}"
p "Pre-order: #{tree.root.preorder}"
p "Post-order: #{tree.root.postorder}"
p "In-order: #{tree.root.inorder}"
tree.root.insert(103)
tree.root.insert(102)
tree.root.insert(104)
tree.pretty_print
p "Balanced?: #{tree.balanced?}"
tree = tree.rebalance
tree.pretty_print
p "Balanced?: #{tree.balanced?}"
p "Level-order: #{tree.root.level_order}"
p "Pre-order: #{tree.root.preorder}"
p "Post-order: #{tree.root.postorder}"
p "In-order: #{tree.root.inorder}"
