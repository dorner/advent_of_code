require_relative '../lib/utils'
input = Utils.input

def in_right_order?(arr1, arr2)
  return true if arr1.nil?
  return false if arr2.nil?

  if arr1.is_a?(Integer) && arr2.is_a?(Integer)
    return arr1 < arr2 if arr1 != arr2
  else
    array1 = Array(arr1)
    array2 = Array(arr2)
    (0...[array1.length, array2.length].max).each do |i|
      result = in_right_order?(array1[i], array2[i])
      return result unless result.nil?
    end
  end
  nil
end

right_order = 0
index = 0
prev_arr = nil
input.lines(chomp: true).each do |line|
  if line.blank?
    prev_arr = nil
    next
  end

  if prev_arr.nil?
    prev_arr = eval(line)
    next
  end

  index += 1
  arr = eval(line)
  right_order += index if in_right_order?(prev_arr, arr)
end

puts right_order

# part 2
all_arrays = []
input.lines(chomp: true).each do |line|
  next if line.blank?
  all_arrays.push(eval(line))
end
all_arrays.push([[2]])
all_arrays.push([[6]])
all_arrays.sort! { |arr1, arr2| in_right_order?(arr1, arr2) ? -1 : 1 }
index1 = all_arrays.index([[2]]) + 1
index2 = all_arrays.index([[6]]) + 1
puts index1 * index2
