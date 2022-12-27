require_relative '../lib/utils'
input = Utils.input

class Context
  attr_accessor :x, :cycle, :cycle_ops, :total
  def initialize
    @x = 1
    @cycle = 1
    @total = 0
  end

  def process_line(line)
    process_cycle
    if line.start_with?('addx')
      @cycle += 1
      process_cycle
      num = line.split(' ').last.to_i
      @x += num
    end
    @cycle += 1
  end

  def process_cycle
    if [20, 60, 100, 140, 180, 220].include?(@cycle)
      @total += (@cycle * @x)
    end
    print [@x - 1, @x, @x + 1].include?((@cycle - 1) % 40) ? '#' : '.'
    puts '' if @cycle % 40 == 0
  end

end

context = Context.new

input.lines.each do |line|
  context.process_line(line)
end

puts context.total
