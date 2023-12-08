require_relative '../lib/utils'
input = Utils.lines
sample_input = Utils.lines(true)

Node = Struct.new(:label, :left, :right)
Path = Struct.new(:current_node, :seen_nodes, :cycle_time, :init_time, :current_step)
CycledPath = Struct.new(:seen_steps, :max_step)

def parse_input(input)
  directions = input.first.chars
  hash = {}
  input[2..].each do |line|
    key, left, right = line.scan(/(...) = \((...), (...)/).first
    hash[key] = Node.new(key, left, right)
  end
  [directions, hash]
end

def part1(input)
  directions, hash = parse_input(input)
  current = hash['AAA']
  steps = 0
  directions.cycle do |dir|
    steps += 1
    current = dir == 'R' ? hash[current.right] : hash[current.left]
    break if current.label == 'ZZZ'
  end
  puts steps
end

# this is way overthinking things and doesn't actually work
def part2(input)
  directions, hash = parse_input(input)
  start_nodes = hash.select { |k, _| k.ends_with?('A') }.values
  paths = start_nodes.map { |s| Path.new(s, [s], 0, 0, nil)}
  directions.cycle do |dir|
    paths.each do |path|
      next if path.cycle_time.positive?

      path.current_node = dir == 'R' ? hash[path.current_node.right] : hash[path.current_node.left]
      if path.current_node.label.end_with?('Z') && path.seen_nodes.include?(path.current_node)
        path.init_time = path.seen_nodes.index(path.current_node)
        path.cycle_time = path.seen_nodes.length - path.init_time
      else
        path.seen_nodes.push(path.current_node)
      end
    end
    break if paths.all? { |p| p.cycle_time.positive? || p.current_node.label.ends_with?('Z') }
  end

  max_path = paths.max_by(&:cycle_time)
  current_step = max_path.init_time
  while true
    puts current_step
    current_step += max_path.cycle_time
    return current_step if paths.all? { |p| ((current_step - p.init_time) % p.cycle_time) == 0 }
  end
end

puts part1(input)
puts part2(input)
