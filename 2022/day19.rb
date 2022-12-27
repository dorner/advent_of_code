require_relative '../lib/utils'
input = Utils.input

class Blueprint
  attr_accessor :id, :ore_robot, :clay_robot, :obsidian_robot, :geode_robot
  def initialize(id, ore_robot, clay_robot, obsidian_robot, geode_robot)
    @id = id.to_i
    @ore_robot = ore_robot.to_i
    @clay_robot = clay_robot.to_i
    @obsidian_robot = obsidian_robot.map(&:to_i)
    @geode_robot = geode_robot.map(&:to_i)
  end
end
State = Struct.new(:ore_robots, :clay_robots, :obsidian_robots, :geode_robots, :ore, :clay, :obsidian, :geodes, :current_build) do
  def initialize
    self.ore_robots = 1
    self.clay_robots = 0
    self.obsidian_robots = 0
    self.geode_robots = 0
    self.ore = 0
    self.clay = 0
    self.obsidian = 0
    self.geodes = 0
  end

  def move(sym)
    state = self.dup
    state.current_build = sym
    state
  end

  def mine
    self.ore += self.ore_robots
    self.clay += self.clay_robots
    self.obsidian += self.obsidian_robots
    self.geodes += self.geode_robots
  end

  def finish_building
    case self.current_build
    when :ore
      self.ore_robots += 1
    when :clay
      self.clay_robots += 1
    when :obsidian
      self.obsidian_robots += 1
    when :geode
      self.geode_robots += 1
    end
    self.current_build = nil
  end

  def start_building(blueprint)
    case self.current_build
    when :ore
      self.ore -= blueprint.ore_robot
    when :clay
      self.ore -= blueprint.clay_robot
    when :obsidian
      self.ore -= blueprint.obsidian_robot[0]
      self.clay -= blueprint.obsidian_robot[1]
    when :geode
      self.ore -= blueprint.geode_robot[0]
      self.obsidian -= blueprint.geode_robot[1]
    end
  end

  def as_good_or_better?(other_state, time)
    self.ore >= other_state.ore &&
      self.clay >= other_state.clay &&
      self.obsidian >= other_state.obsidian &&
      self.geodes >= other_state.geodes &&
      self.ore_robots >= other_state.ore_robots &&
      self.clay_robots >= other_state.clay_robots &&
      self.obsidian_robots >= other_state.obsidian_robots &&
      self.geode_robots >= other_state.geode_robots
  end

  def to_s
    "#{ore_robots} #{clay_robots} #{obsidian_robots} #{geode_robots} -> #{ore} #{clay} #{obsidian} #{geodes} = #{current_build}"
  end
end

blueprints = input.lines.map do |line|
  nums = line.scan(/\d+/)
  Blueprint.new(nums[0], nums[1], nums[2], [nums[3], nums[4]], [nums[5], nums[6]])
end

def possible_moves(state, blueprint)
  moves = []
  if state.ore >= blueprint.geode_robot[0] && state.obsidian >= blueprint.geode_robot[1]
    return [state.move(:geode)]
  end
  if state.ore >= blueprint.obsidian_robot[0] && state.clay >= blueprint.obsidian_robot[1]
    return [state.move(:obsidian)]
  end
  if state.ore >= blueprint.ore_robot
    moves.push(state.move(:ore))
  end
  if state.ore >= blueprint.clay_robot
    moves.push(state.move(:clay))
  end
  max_ore = [blueprint.ore_robot, blueprint.clay_robot, blueprint.obsidian_robot[0], blueprint.geode_robot[0]].max
  max_clay = blueprint.obsidian_robot[1]
  max_obsidian = blueprint.geode_robot[1]
  if state.ore < max_ore || (state.clay < max_clay && state.clay_robots >= 1) || (state.obsidian < max_obsidian && state.obsidian_robots >= 1)
    moves.push(state.move(:nothing))
  end
  moves
end

def calculate_max_geodes(blueprint, state, time=1)
  #  puts "#{time} #{state}"

  state.start_building(blueprint)
  state.mine
  state.finish_building

  return if @seen_moves[time]&.any? { |move| move.as_good_or_better?(state, time)}

  @seen_moves[time].nil?
  @seen_moves[time].delete_if { |move| state.as_good_or_better?(move, time) }
  @seen_moves[time].push(state)

  return if time >= 24

  possible_moves = possible_moves(state, blueprint)
  #  puts "possible #{possible_moves.map(&:to_s).join(',')}"
  possible_moves.each do |move|
    calculate_max_geodes(blueprint, move, time + 1)
  end
end

totals = []
blueprints.each do |blueprint|
  @seen_moves = (0..25).map { |i| [i, []]}.to_h
  state = State.new
  calculate_max_geodes(blueprint, state)
  max_geodes = @seen_moves[24].max_by(&:geodes).geodes
  puts "#{blueprint.id} #{max_geodes}"
  totals.push(blueprint.id.to_i * max_geodes)
end

puts totals.sum

