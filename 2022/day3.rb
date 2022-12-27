require_relative '../lib/utils'
input = Utils.input
knapsacks = input.lines

CAP_ORD = 'A'.ord
LOW_ORD = 'a'.ord

def priority(char)
  char_ord = char.ord
  if char_ord >= LOW_ORD
    char_ord - LOW_ORD + 1
  else
    char_ord - CAP_ORD + 27
  end
end

total = 0
knapsacks.each do |knapsack|
  chars = knapsack.chars
  split_index = knapsack.length/2
  first_part = chars[0...split_index].to_set
  second_part = chars[split_index..-1]
  dupe_char = second_part.find { |c| first_part.include?(c) }
  total += priority(dupe_char)
end

puts total

# part 2
total = 0
knapsacks.in_groups_of(3).each do |group|
  sets = group.map do |knapsack|
    knapsack.chars.to_set
  end
  badge = sets[0].intersection(sets[1]).intersection(sets[2]).first
  total += priority(badge)
end
puts total
