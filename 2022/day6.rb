require_relative '../lib/utils'
input = Utils.input

def marker(input, length)
  chars = input.chars
  (0..chars.size).each do |i|
    marker_array = (0...length).map { |j| chars[i+j]}
    marker = marker_array.uniq.length == length
    if marker
      return i + length
    end
  end
end

puts marker(input, 4)
puts marker(input, 14)
