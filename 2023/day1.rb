require_relative '../lib/utils'
input = Utils.input

def part1(input)
  two_digit_nums = input.lines.map do |l|
    nums = l.scan(/\d/)
    nums[0].to_i * 10 + nums[-1].to_i
  end
  two_digit_nums.sum
end

NUMBER_MAP = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
}

def number_to_int(num)
  to_i_num = num.to_i
  return to_i_num if to_i_num.positive?

  NUMBER_MAP[num]
end

def part2(input)
  two_digit_nums = input.lines.map do |l|
    next 0 if l.blank?
    front_regex = /(\d|#{NUMBER_MAP.keys.join("|")})/
    first_num = l[front_regex]
    reverse_regex = /(\d|#{NUMBER_MAP.keys.map(&:reverse).join("|")})/
    last_num = l.reverse[reverse_regex].reverse
    number_to_int(first_num) * 10 + number_to_int(last_num)
  end
  two_digit_nums.sum
end

puts part1(input)
puts part2(input)
