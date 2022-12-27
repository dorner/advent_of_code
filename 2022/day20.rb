require_relative '../lib/utils'
input = Utils.input
Num = Struct.new(:value, :original)

def mix(original_nums, nums)
  original_nums.each do |num|
    original = nums.index { |n| n.original == num.original }
    current = (original + num.value) % (nums.length - 1)
    nums.insert(current > original ? current + 1 : current, num)
    nums.delete_at(original > current ? original + 1 : original)
  end
  nums
end

def do_part(input, times=1, key=1)
  nums = input.lines(chomp: true).map.with_index { |n, i| Num.new(n.to_i * key, i)}
  original_nums = nums.dup
  times.times.each do
    nums = mix(original_nums, nums)
  end
  zero = nums.index { |n| n.value == 0 }
  first = nums[(zero + 1000) % nums.length]
  second = nums[(zero + 2000) % nums.length]
  third = nums[(zero + 3000) % nums.length]

  puts first.value + second.value + third.value
end

do_part(input, 1, 1)
do_part(input, 10, 811589153)

