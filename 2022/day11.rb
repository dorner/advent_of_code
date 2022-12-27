require_relative '../lib/utils'
input = Utils.input

class Monkey
  attr_accessor :monkey_id, :items, :operand, :operator, :if_true, :if_false, :test, :total_inspected, :factor
  def initialize(entry)
    lines = entry.lines
    @monkey_id = lines[0].match(/\d+/)[0].to_i
    @items = lines[1].gsub('Starting items: ', '').split(',').map(&:to_i)
    operator_match = lines[2].match(/new = old ([\+\*]) (.*)/)
    @operator = operator_match[1]
    @operand = operator_match[2]
    @test = lines[3].match(/\d+/)[0].to_i
    @if_true = lines[4].match(/\d+/)[0].to_i
    @if_false = lines[5].match(/\d+/)[0].to_i
    @total_inspected = 0
    @factor = nil
  end

  def turn(monkeys)
    (1..@items.size).each do
      item = @items.shift
      item = inspect_item(item)
      throw_item(item, monkeys)
    end
  end

  def inspect_item(item)
    @total_inspected += 1
    operand = @operand == 'old' ? item : @operand.to_i
    case @operator
    when '+'
      item += operand
    when '*'
      item *= operand
    end
    @factor ? item % @factor : item / 3
  end

  def throw_item(item, monkeys)
    if item % @test == 0
      monkeys[@if_true].items.push(item)
    else
      monkeys[@if_false].items.push(item)
    end
  end
end

def run_program(input, num_rounds, calculate_factor=false)
  monkeys = {}
  input.split("\n\n").each do |entry|
    next if entry.blank?
    monkey = Monkey.new(entry)
    monkeys[monkey.monkey_id] = monkey
  end

  if calculate_factor
    factor = monkeys.values.map(&:test).reduce(:*)
    monkeys.values.each { |m| m.factor = factor }
  end

  (1..num_rounds).each do |i|
    monkeys.keys.sort.each do |monkey_id|
      monkeys[monkey_id].turn(monkeys)
    end
  end

  highest_2 = monkeys.values.sort_by(&:total_inspected).reverse[0..1]
  puts highest_2[0].total_inspected * highest_2[1].total_inspected
end

run_program(input, 20, false)
run_program(input, 10_000, true)
