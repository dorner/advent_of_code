input = [49, 263], [97, 1532], [94, 1378], [94, 1851]
sample_input = [7, 9], [15, 40], [30, 200]

part2input = [49979494, 263153213781851]
part2_sample = [71530, 940200]

def can_win?(seconds_held, time, distance)
  remaining_time = time - seconds_held
  seconds_held * remaining_time > distance
end

def part1(input)
  all_ways = []
  input.each do |time, distance|
    ways = 0
    (1..time).each do |i|
      ways += 1 if can_win?(i, time, distance)
    end
    all_ways.push(ways)
  end
  all_ways.inject(:*)
end

def bsearch(range, time, distance)
  can_win_first = can_win?(range.first, time, distance)
  can_win_last = can_win?(range.last, time, distance)
  return range if can_win_first && can_win_last
  return nil if !can_win_first && !can_win_last

  midpoint = (range.last - range.first) / 2
  left = bsearch(range.first..midpoint, time, distance)
  right = bsearch(midpoint+1..range.last, time, distance)
  left || right
end

def part2(input)
  time, distance = input
  # we know that the midpoint can definitely win
  # we also know that the pattern is a bell curve
  # so we only need to check the first half
  range = (0..time/2)
  min_num = range.bsearch { |i| can_win?(i, time, distance) }
  half_range = (time / 2) - min_num
  half_range * 2 + 1
end

puts part1(input)
puts part2(part2input)
