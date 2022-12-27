require_relative '../lib/utils'
input = Utils.input

def operate(arguments, operator)
  case operator
  when '+'
    arguments[0] + arguments[1]
  when '*'
    arguments[0] * arguments[1]
  when '-'
    arguments[0] - arguments[1]
  when '/'
    arguments[0] / arguments[1]
  end
end

def reverse_operate(arguments, operator)
  case operator
  when '+'
    arguments[0] - arguments[1]
  when '*'
    arguments[0] / arguments[1]
  when '-'
    arguments[0] + arguments[1]
  when '/'
    arguments[0] * arguments[1]
  end
end

Monkey = Struct.new(:name, :dependents, :operator, :value) do
  def dup
    Monkey.new(self.name, self.dependents.dup, self.operator, self.value)
  end
end
resolved_monkeys = {}
unresolved_monkeys = {}
input.lines(chomp: true).each do |line|
  name, equation = line.split(':').map(&:strip)
  monkey = Monkey.new(name, equation)
  if equation !~ /\d+/
    _, dep1, operator, dep2 = equation.match(/([a-z]+) ([\-*+\/]) ([a-z]+)/).to_a
    monkey.operator = operator
    monkey.dependents = [dep1, dep2]
    unresolved_monkeys[name] = monkey
  else
    monkey.value = equation.to_i
    resolved_monkeys[name] = monkey
  end
end

# part 1

resolved = resolved_monkeys.deep_dup
unresolved = unresolved_monkeys.deep_dup

def resolve(name, resolved, unresolved, stop_value=nil)
  size = unresolved.size
  while unresolved.key?(name)
    unresolved.values.each do |monkey|
      next if name == stop_value
      monkey.dependents.each_with_index do |dep, i|
        val = resolved[dep]&.value
        monkey.dependents[i] = val if val && dep != stop_value
      end
      if monkey.dependents.all? { |d| d.is_a?(Integer) }
        monkey.value = operate(monkey.dependents, monkey.operator)
        unresolved.delete(monkey.name)
        resolved[monkey.name] = monkey
      end
    end
    break if unresolved.size == size # no further progress
    size = unresolved.size
  end
  puts resolved[name]&.value
end

resolve('root', resolved, unresolved)

# part 2
UNKNOWN = 'humn'
resolved = resolved_monkeys.deep_dup
unresolved = unresolved_monkeys.deep_dup

deps = unresolved_monkeys['root'].dependents
# check each
deps.each do |dep|
  resolve(dep, resolved, unresolved, UNKNOWN)
end
unresolved_dep = deps.find { |d| unresolved.key?(d) }
resolved_dep = deps.find { |d| resolved.key?(d) }
target = resolved[resolved_dep].value

monkey = unresolved[unresolved_dep]
while monkey && monkey.name != UNKNOWN
  unresolved_dep = monkey.dependents.find { |d| !d.is_a?(Integer) }
  resolved_dep = monkey.dependents.find { |d| d.is_a?(Integer) }
  target = reverse_operate([target, resolved_dep], monkey.operator)
  monkey = unresolved[unresolved_dep]
end

puts target
