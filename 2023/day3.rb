require_relative '../lib/utils'
require_relative '../lib/grid'
input = Utils.input()

SYMBOLS = %w(* = + - & @ / % $ #)

class NumberPin < Point
end

class SymbolPin < Point
end

class Day3Grid < Grid

  def gear_ratio(point)
    return 0 if point.grid_char != '*'

    seen_numbers = Set.new
    full_numbers = []

    self.surrounding_pins(point, NumberPin).each do |pin|
      next if seen_numbers.include?(pin)

      fn = self.full_number(pin)
      seen_numbers.merge(fn)
      full_numbers.push(fn)
    end
    return 0 if full_numbers.size != 2

    values = full_numbers.map { |n| num_value(n) }
    values[0] * values[1]
  end

  def gears
    self.pins[SymbolPin].values.map(&:first).select { |p| p.grid_char == '*' }
  end

  def full_number(point)
    point_set = Set.new
    point_set.add(point)
    current_point = point
    while current_point
      current_point = self.pin_in_direction(current_point, Point::LEFT, NumberPin)
      point_set.add(current_point) if current_point
    end
    current_point = point
    while current_point
      current_point = self.pin_in_direction(current_point, Point::RIGHT, NumberPin)
      point_set.add(current_point) if current_point
    end
    point_set
  end

  def num_value(points)
    points.sort_by(&:x).reverse.map.with_index { |p, i| p.grid_char.to_i * (10**i) }.sum
  end

end

PIN_MAP = (0..9).to_h { |k| [k.to_s, NumberPin] }
SYMBOLS.each { |sym| PIN_MAP[sym] = SymbolPin }

def part1(input)
  grid = Day3Grid.new(input.lines, PIN_MAP)
  num_set = Set.new
  grid.each_pin(type: SymbolPin) do |pin|
    num_set.merge(grid.surrounding_pins(pin, NumberPin))
  end
  seen_numbers = Set.new
  full_numbers = []
  num_set.each do |num|
    next if seen_numbers.include?(num)
    full_number = grid.full_number(num)
    seen_numbers.merge(full_number)
    full_numbers.push(grid.num_value(full_number))
  end

  puts full_numbers.sum
end

def part2(input)
  grid = Day3Grid.new(input.lines, PIN_MAP)
  puts grid.gears.map { |g| grid.gear_ratio(g)}.sum
end

part1(input)
part2(input)
