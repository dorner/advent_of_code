require_relative '../lib/utils'
input = Utils.input

class Rock
  attr_accessor :positions, :bottom_left, :current_top_left, :height
  def initialize(pos)
    self.positions = pos
    self.bottom_left = [0, positions.map { |p| p[1]}.max]
    @raw_left_positions = positions.group_by { |p| p[0]}.values.map(&:first)
    @raw_right_positions = positions.group_by { |p| p[0]}.values.map(&:last)
    @raw_bottom_positions = positions.group_by { |p| p[1]}.values.map(&:last)
    self.current_top_left = [0, 0]
    self.height = positions.group_by { |p| p[0]}.values.count
  end

  def real_pos(pos)
    [pos[0] + self.current_top_left[0], pos[1] + self.current_top_left[1]]
  end

  def real_positions
    self.positions.map { |pos| real_pos(pos) }
  end

  def left_positions
    @raw_left_positions.map { |p| real_pos(p) }
  end

  def right_positions
    @raw_right_positions.map { |p| real_pos(p) }
  end

  def bottom_positions
    @raw_bottom_positions.map { |p| real_pos(p) }
  end

  def move_left(grid)
    return if self.left_positions.any? { |pos| pos[1] == 0 || grid.dig(pos[0], pos[1]-1) == true}
    self.current_top_left[1] -= 1
  end

  def move_right(grid)
    return if self.right_positions.any? { |pos| pos[1] == 6 || grid.dig(pos[0], pos[1]+1) == true}
    self.current_top_left[1] += 1
  end

  def move_down(grid)
    return false if self.bottom_positions.any? { |pos| pos[0] == 0 || grid.dig(pos[0]+1, pos[1]) == true}
    self.current_top_left[0] += 1
    true
  end

  def drop_into_grid(grid)
    self.real_positions.each do |pos|
      grid[pos[0]] ||= {}
      grid[pos[0]][pos[1]] = true
    end
  end

end

rocks = [
  Rock.new([[0, 0], [0, 1], [0, 2], [0, 3]]),
  Rock.new([[0, 1], [1, 0], [1, 1], [1, 2], [2, 1]]),
  Rock.new([[0, 2], [1, 2], [2, 0], [2, 1], [2, 2]]),
  Rock.new([[0, 0], [1, 0], [2, 0], [3, 0]]),
  Rock.new([[0, 0], [0, 1], [1, 0], [1, 1]])
]

grid = {}

def drop_rock(grid, index, rocks)
  rock = rocks[index]
  start_pos = [grid.any? ? -grid.length - 3 : -3, 2]
  rock.current_top_left = [start_pos[0] - rock.height + 1, 2]
  rock
end

def do_move(grid, rock, direction)
  if direction == '<'
    rock.move_left(grid)
  else
    rock.move_right(grid)
  end
  rock.move_down(grid)
end

def debug_grid(grid, rock)
  min_key = grid.keys.min || 0
  (min_key - 8 ..0).each do |key|
    (0...7).each do |i|
      if grid.dig(key, i)
        print '#'
      elsif rock.real_positions.any? { |p| p[0] == key && p[1] == i}
        print '@'
      else
        print '.'
      end
    end
    puts
  end
  puts "\n\n"
end

rock_index = 0
step_index = 0
num_rocks = 0
MAX_ROCKS = 1000000000001
rock = drop_rock(grid, rock_index, rocks)
input_steps = input.chomp.chars
while true do
  char = input_steps[step_index]
  step_index = (step_index + 1) % input_steps.length
  unless do_move(grid, rock, char)
    num_rocks += 1
    break if num_rocks == MAX_ROCKS
    rock.drop_into_grid(grid)
    rock_index = (rock_index + 1) % 5
    rock = drop_rock(grid, rock_index, rocks)
  end
end

puts grid.keys.min - 1

