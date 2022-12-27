require_relative '../lib/utils'
input = Utils.input

class Node
  attr_accessor :height, :min_steps, :left, :right, :top, :bottom, :is_end
  def initialize(height, is_end=false)
    @height = height
    @min_steps = 1_000_000
    @is_end = is_end
  end

  def attach(node, dir)
    case dir
    when :left
      @left = node
      node.right = self
    when :top
      @top = node
      node.bottom = self
    end
  end
end

start = nil
finish = nil
grid = []
input.lines(chomp: true).each_with_index do |line, i|
  line.chars.each_with_index do |c, j|
    if c == 'S'
      node = Node.new('a'.ord)
      start = node
    elsif c == 'E'
      node = Node.new('z'.ord, true)
      finish = node
    else
      node = Node.new(c.ord)
    end
    if i > 0
      node.attach(grid[i-1][j], :left)
    end
    if j > 0
      node.attach(grid[i][j-1], :top)
    end
    grid[i] ||= []
    grid[i][j] = node
  end
end

def move_to_node(from_node, to_node)
  target_steps = (from_node&.min_steps || 0) + 1
  if to_node.is_end
    to_node.min_steps = [target_steps, to_node.min_steps].min
    return
  end

  return if to_node.min_steps <= target_steps

  to_node.min_steps = target_steps

  %i(top bottom left right).each do |dir|
    next_node = to_node.send(dir)
    if next_node && next_node.height <= to_node.height + 1
      move_to_node(to_node, next_node)
    end
  end
end

# part 1
move_to_node(nil, start)

puts finish.min_steps - 1

# part 2

a_nodes = []
grid.each { |r| r.each { |n| a_nodes.push(n) if n.height.chr == 'a'}}
a_nodes.each do |a_node|
  move_to_node(nil, a_node)
end

puts finish.min_steps - 1
