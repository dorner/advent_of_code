require_relative '../lib/utils'
require_relative '../lib/point'
require_relative 'grid'
input = Utils.lines
sample_input = Utils.lines(true)

Step = Struct.new(:coord, :from)

def reverse_dir(dir)
  case dir
  when Direction::NORTH; Direction::SOUTH
  when Direction::SOUTH; Direction::NORTH
  when Direction::WEST; Direction::EAST
  when Direction::EAST; Direction::WEST
  end
end

def next_dir(from_dir, point)
  check_dir = reverse_dir(from_dir)
  case point.grid_char
  when '|'
    check_dir == Direction::NORTH ? Direction::SOUTH : Direction::NORTH
  when '-'
    check_dir == Direction::WEST ? Direction::EAST : Direction::WEST
  when 'L'
    check_dir == Direction::NORTH ? Direction::EAST : Direction::NORTH
  when 'J'
    check_dir == Direction::NORTH ? Direction::WEST : Direction::NORTH
  when '7'
    check_dir == Direction::SOUTH ? Direction::WEST : Direction::SOUTH
  when 'F'
    check_dir == Direction::SOUTH ? Direction::EAST : Direction::SOUTH
  end
end

def reachable?(from_dir, point)
  check_dir = reverse_dir(from_dir)
  case point.grid_char
  when '|'
    [Direction::NORTH, Direction::SOUTH].include?(check_dir)
  when '-'
    [Direction::WEST, Direction::EAST].include?(check_dir)
  when 'L'
    [Direction::NORTH, Direction::EAST].include?(check_dir)
  when 'J'
    [Direction::NORTH, Direction::WEST].include?(check_dir)
  when '7'
    [Direction::SOUTH, Direction::WEST].include?(check_dir)
  when 'F'
    [Direction::SOUTH, Direction::EAST].include?(check_dir)
  else
    false
  end
end

def first_steps(grid, start)
  steps = [
    Direction::NORTH,
    Direction::WEST,
    Direction::SOUTH,
    Direction::EAST
  ].map do |dir|
    step_point = grid.in_dir(start, dir)
    next nil if step_point.nil?

    next nil unless reachable?(dir, step_point)

    Step.new(step_point, dir)
  end
  steps.compact
end

def part1(input)
  grid = Grid.new(input, 'S')
  start = grid.start
  steps = first_steps(grid, start)
  max_steps = 0
  while true
    max_steps += 1
    steps.each_with_index do |curr_step, i|
      dir = next_dir(curr_step.from, curr_step.coord)
      puts "#{i} #{curr_step.coord} #{dir}"
      steps[i] = Step.new(grid.in_dir(steps[i].coord, dir), dir)
      return max_steps + 1 if steps.map(&:coord).uniq.length < steps.length
    end
  end
  max_steps
end

def part2(input)

end

puts part1(input)

