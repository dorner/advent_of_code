require_relative '../lib/utils'
require 'active_support/core_ext/array'
input = Utils.lines

InputMap = Struct.new(:destination_start, :source_start, :range_length)
MapCategory = Struct.new(:source, :destination, :input_maps) do
  def initialize(*args)
    super
    self.input_maps = []
  end
end

def mapped_value(val, map_cat)
  map_cat.input_maps.each do |map|
    next if val < map.source_start || val >= (map.source_start + map.range_length)

    return map.destination_start + val - map.source_start
  end
  val
end

def mapped_ranges(val_ranges, map_cat)
  mapped_val_ranges = []
  ranges_to_check = val_ranges.dup
  while ranges_to_check.any?
    range = ranges_to_check.pop
    found_range = false
    map_cat.input_maps.each do |map|
      map_range = map.source_start..(map.source_start + map.range_length - 1)

      # MAP (10..30) -> (40..50)
      # DIFF 30
      diff = map.destination_start - map.source_start

      # case 1 - a range is entirely within the map range
      # RANGE (15..25)
      # RETURN (45..55)
      if map_range.cover?(range)
        mapped_val_ranges.push((range.first + diff)..(range.last + diff))
        found_range = true

      # case 2 - a map range is entirely within the range
      # RANGE (5..40)
      # RETURN (40..50), remaining (5..9), (31..40)
      elsif range.cover?(map_range)
        ranges_to_check.push((range.first..(map_range.first - 1))) if range.first < map_range.first
        ranges_to_check.push((map_range.last..(range.last - 1))) if map_range.last < range.last
        mapped_val_ranges.push((map_range.first + diff)..(map_range.last + diff))
        found_range = true

      # case 3 - a range overlaps the first part of the map range
      # RANGE (5..15)
      # RETURN (40..45), remaining (5..9)
      elsif range.last <= map_range.last && range.last >= map_range.first
        mapped_val_ranges.push((map_range.first + diff)..(range.last + diff))
        ranges_to_check.push(range.first..(map_range.first - 1)) if range.first < map_range.first
        found_range = true

      # case 4 - a range overlaps the last part of the map range
      # RANGE (25..35)
      # RETURN (45..50), remaining (31..35)
      elsif range.first <= map_range.last && range.first >= map_range.last
        mapped_val_ranges.push((range.first + diff)..(map_range.last + diff))
        ranges_to_check.push((map_range.last + 1)..(range.last)) if map_range.last < range.last
        found_range = true
      end
    end

    unless found_range
      mapped_val_ranges.push(range)
    end
  end

  mapped_val_ranges
end

def parse_input(input)
  needed_seeds = []
  map_cats = {}
  current_map_cat = nil
  input.each do |line|
    next if line == ''
    if line =~ /-/
      _, source, destination = line.match(/(.*)-to-(.*) /).to_a
      current_map_cat = MapCategory.new(source, destination)
      map_cats[source] = current_map_cat
    elsif line =~ /:/
      needed_seeds = line.scan(/(\d+)/).map(&:first).map(&:to_i)
    else
      _, source_start, destination_start, range_length = line.match(/(\d+) (\d+) (\d+)/).to_a
      map = InputMap.new(source_start.to_i, destination_start.to_i, range_length.to_i)
      current_map_cat.input_maps.push(map)
    end
  end
  [needed_seeds, map_cats]
end

def part1(input)
  needed_seeds, map_cats = parse_input(input)
  locations = needed_seeds.map do |seed|
    source = 'seed'
    while source != 'location'
      cat = map_cats[source]
      seed = mapped_value(seed, cat)
      source = cat.destination
    end
    seed
  end
  locations.min
end

def part2(input)
  needed_seeds, map_cats = parse_input(input)
  seed_ranges = needed_seeds.in_groups_of(2).map { |first, length| first..(first + length - 1) }
  location_ranges = seed_ranges.map do |seed_range|
    source = 'seed'
    found_ranges = [seed_range]
    while source != 'location'
      cat = map_cats[source]
      found_ranges = mapped_ranges(found_ranges, cat)
      source = cat.destination
    end
    found_ranges
  end
  location_ranges.flatten.min_by(&:first).first

end

puts part1(input)
puts part2(input)
