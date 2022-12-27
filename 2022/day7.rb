require_relative '../lib/utils'
input = Utils.input

class Directory
  attr_accessor :files, :parent
  def initialize(parent:nil)
    self.files = {}
    self.parent = parent
  end

  def calculate_total_size(all_totals=[], min)
    total = 0
    self.files.values.each do |file|
      if file.is_a?(Directory)
        total += file.calculate_total_size(all_totals, min)
      else
        total += file
      end
    end
    all_totals.push(total) if total <= min
    total
  end
end

tree = Directory.new
curr_node = tree
input.lines.each do |line|
  tokens = line.split(' ')
  next if tokens[0] == '$' && tokens[1] == 'ls'

  if tokens[0] == '$' && tokens[1] == 'cd'
    if tokens[2] == '..'
      curr_node = curr_node.parent
    elsif tokens[2] == '/'
      curr_node = tree
    else
      curr_node = curr_node.files[tokens[2]]
    end
    next
  end

  size, filename = tokens
  if size == 'dir'
    curr_node.files[filename] = Directory.new(parent: curr_node)
  else
    curr_node.files[filename] = size.to_i
  end

end

# part 1
all_totals = []
tree.calculate_total_size(all_totals, 100_000)
puts all_totals.sum

# part 2
TOTAL_SPACE = 70_000_000
DESIRED_FREE_SPACE = 30_000_000
all_totals = []
tree.calculate_total_size(all_totals, TOTAL_SPACE)

root_dir_size = all_totals.max
current_free_space = TOTAL_SPACE - root_dir_size
needed_free_space = DESIRED_FREE_SPACE - current_free_space
options = all_totals.select { |d| d >= needed_free_space }
puts options.min
