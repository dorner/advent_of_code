require_relative '../lib/utils'
require_relative '../lib/grid'

lines = Utils.lines(true)

class Elf < Point
  attr_accessor :proposal
end

NORTH = Point::UP
SOUTH = Point::DOWN
WEST = Point::LEFT
EAST = Point::RIGHT

NORTHWEST = NORTH.add_vector(WEST)
NORTHEAST = NORTH.add_vector(EAST)
SOUTHWEST = SOUTH.add_vector(WEST)
SOUTHEAST = SOUTH.add_vector(EAST)

ALL_DIRECTIONS = [NORTH, SOUTH, WEST, EAST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST]

DIR_ORDER = [NORTH, SOUTH, WEST, EAST]

class Day23Grid < Grid
  attr_accessor :elves_with_proposals

  def elves
    @pins[Elf]
  end

  def move_to_proposal(elf)
    self.elves.delete(elf)
    elf.x = elf.proposal.x
    elf.y = elf.proposal.y
    self.elves.add(elf)
    elf.proposal = nil
  end

  def initialize(lines)
    super(lines, { '#' => Elf})
    self.elves_with_proposals = Set.new
  end

end

def can_move?(direction, positions)
  case direction
  when NORTH
    !positions[NORTHEAST] && !positions[NORTH] && !positions[NORTHWEST]
  when SOUTH
    !positions[SOUTHEAST] && !positions[SOUTH] && !positions[SOUTHWEST]
  when WEST
    !positions[NORTHWEST] && !positions[WEST] && !positions[SOUTHWEST]
  when EAST
    !positions[NORTHEAST] && !positions[EAST] && !positions[SOUTHEAST]
  end
end

def first_half(grid, dir_order)
  grid.elves.each do |elf|
    elf.proposal = nil
    positions = ALL_DIRECTIONS.to_h { |dir| [dir, grid.pin_in_direction?(elf, dir) ]}
    next if positions.values.none?

    dir_order.each do |dir|
      if can_move?(dir, positions)
        elf.proposal = elf.add_vector(dir)
        break
      end
    end
  end
end

def second_half(grid)
  proposals = grid.elves.group_by(&:proposal)
  grid.elves.each do |elf|
    if elf.proposal && proposals[elf.proposal].size == 1
      grid.elves_with_proposals.add(elf)
    end
  end
  any_moves = grid.elves_with_proposals.any?
  grid.elves_with_proposals.each { |elf| grid.move_to_proposal(elf) }
  grid.elves_with_proposals = Set.new
  any_moves
end

def perform_round(grid, i, dir_order)
  grid.debug
  first_half(grid, dir_order)
  return false unless second_half(grid)
  dir = dir_order.shift
  dir_order.push(dir)
  true
end

def rounds(grid, num_rounds)
  dir_order = DIR_ORDER.dup
  num_rounds.times.each do |i|
    perform_round(grid, i, dir_order)
  end
end

# part 1

grid = Day23Grid.new(lines)
rounds(grid, 10)
total = ((grid.max_y - grid.min_y + 1) * (grid.max_x - grid.min_x + 1)) - grid.elves.count
puts total

# part 2
grid = Day23Grid.new(lines)

i = 0
dir_order = DIR_ORDER.dup
loop do
  break unless perform_round(grid, i, dir_order)
  i += 1
end

puts i+1
