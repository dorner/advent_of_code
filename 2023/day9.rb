require_relative '../lib/utils'
sample_input = Utils.lines(true)
input = Utils.lines

History = Struct.new(:timelines) do
  def calculate_diff
    last_timeline = timelines.last
    new_timeline = last_timeline[1..].map.with_index do |val, i|
      val - last_timeline[i] # since we start from 1, i is actually i-1
    end
    self.timelines.push(new_timeline)
  end

  def calculate_all_diffs
    calculate_diff while timelines.last.uniq != [0]
  end

  def add_new_step
    step = 0
    timelines.reverse_each do |timeline|
      step += timeline.last
      timeline.push(step)
    end
  end

  def add_previous_step
    step = 0
    timelines.reverse_each do |timeline|
      step = timeline.first - step
      timeline.unshift(step)
    end
  end

end

def part1(input)
  histories = input.map do |line|
    History.new([line.split(' ').map(&:to_i)])
  end
  histories.each(&:calculate_all_diffs)
  histories.each(&:add_new_step)
  histories.map { |h| h.timelines.first.last }.sum
end

def part2(input)
  histories = input.map do |line|
    History.new([line.split(' ').map(&:to_i)])
  end
  histories.each(&:calculate_all_diffs)
  histories.each(&:add_previous_step)
  histories.map { |h| h.timelines.first.first }.sum
end

puts part1(input)
puts part2(input)
