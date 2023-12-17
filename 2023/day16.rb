require_relative '../lib/utils'
require_relative '../lib/point'
input = Utils.lines
sample_input = Utils.lines(true)

Grid = Struct.new(:grid, :beam_nodes, :end_points, :changed) do
  def dup
    Grid.new(grid: self.grid.deep_dup,
             beam_nodes: self.beam_nodes.deep_dup,
             end_points: Set.new,
             changed: false)
  end

  def from_scratch(beam_node)
    Grid.new(grid: self.grid.map { |line| line.map(&:from_scratch)},
             beam_nodes: Set.new([beam_node]),
             end_points: Set.new([beam_node]),
             changed: false)
  end

end

class Node < Point
  attr_accessor :beams

  def from_scratch
    d = self.class.new(self.x, self.y, self.grid_char)
    d.beams = []
    d
  end

  def initialize(x, y, c)
    super
    self.beams = []
  end
end

def new_directions(dir, label)
  case label
  when '\\'
    [Direction.new(dir.y, dir.x)]
  when '/'
    [Direction.new(-dir.y, -dir.x)]
  when '|'
    if [Direction::NORTH, Direction::SOUTH].include?(dir)
      [dir]
    else
      [Direction::NORTH, Direction::SOUTH]
    end
  when '-'
    if [Direction::WEST, Direction::EAST].include?(dir)
      [dir]
    else
      [Direction::WEST, Direction::EAST]
    end
  else
    [dir]
  end
end

def perform_step(grid)
  new_grid = grid.deep_dup
  new_grid.changed = false
  grid.end_points.each do |node|
    next_beams = node.beams.map { |beam| new_directions(beam, node.grid_char) }.flatten.uniq
    next_beams.each do |dir|
      next_point = node.add_vector(dir)
      next if next_point.x < 0 || next_point.x >= grid.grid[0].length || next_point.y < 0 || next_point.y >= grid.grid.length

      next_pos = new_grid.grid[next_point.y][next_point.x]
      next if next_pos.beams.include?(dir)

      new_grid.changed = true
      new_grid.beam_nodes.add(next_pos)
      new_grid.end_points.add(next_pos)
      next_pos.beams.push(dir)
    end
  end
  new_grid
end

def count_beams(grid, start_node, start_dir)
  puts "Counting from #{start_node}: #{start_dir}"
  dup_node = start_node.deep_dup
  grid = Grid.new(grid).from_scratch(dup_node)
  dup_node.beams = [start_dir]
  while true
    grid = perform_step(grid)
    break unless grid.changed
  end
  grid.beam_nodes.count
end

def part1(input)
  grid_nodes = input.map.with_index { |line, y| line.chars.map.with_index { |c, x| Node.new(x, y, c)}}
  count_beams(grid_nodes, grid_nodes[0][0], Direction::EAST)
end

def part2(input)
  grid_nodes = input.map.with_index { |line, y| line.chars.map.with_index { |c, x| Node.new(x, y, c)}}
  max = 0
  grid_nodes[0].each do |node|
    max = [count_beams(grid_nodes, node, Direction::SOUTH), max].max
  end
  grid_nodes[grid_nodes.length-1].each do |node|
    max = [count_beams(grid_nodes, node, Direction::NORTH), max].max
  end
  (0...grid_nodes[0].length).each do |y|
    max = [count_beams(grid_nodes, grid_nodes[y][0], Direction::EAST), max].max
  end
  (0...grid_nodes[0].length).each do |y|
    max = [count_beams(grid_nodes, grid_nodes[y][grid_nodes.length-1], Direction::WEST), max].max
  end
  max
end

puts part1(sample_input)
puts part2(input)
