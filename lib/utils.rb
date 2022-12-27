require 'set'
require 'active_support/all'

module Utils

  def self.input(sample=false)
    current_dir = File.dirname($PROGRAM_NAME)
    day = File.basename($PROGRAM_NAME, '.rb')
    file = "#{current_dir}/data/#{day}.txt"
    file = "#{current_dir}/data/#{day}-sample.txt" if sample
    File.read(file).chomp
  end

  def self.lines(sample=false)
    self.input(sample).lines(chomp: true)
  end

  # copy/paste into IRB
  def self.generate(dir)
    file_top = <<-TOP
require_relative '../lib/utils'
input = Utils.lines
    TOP
    Dir.mkdir("#{dir}")
    Dir.mkdir("#{dir}/data")
    (1..25).each do |i|
      File.open("#{dir}/day#{i}.rb", 'w') {|f| f.write(file_top) }
      File.open("#{dir}/data/day#{i}.txt", 'w') { }
      File.open("#{dir}/data/day#{i}-sample.txt", 'w') { }
    end
  end
end
