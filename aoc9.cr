input = File.new("../aoc9.txt").gets_to_end

class Solution
  @players : Int32
  @highest : Int32

  def initialize(@input : String)
    @players = @input.split(' ')[0].to_i
    @highest = @input.split(' ')[6].to_i
  end

  def part1
    current = Deque(Int32).new(@highest).push 0
    scores = Array(UInt32).new(@players, 0)
    Range.new(1, @highest + 1).each do |marble|
      self.checkMarble(marble, current, scores)
    end
    return scores.sort { |a, b| b <=> a }[0]
  end

  def part2
    current = Deque(Int32).new(@highest).push 0
    scores = Array(UInt32).new(@players, 0)
    Range.new(1, 100 * @highest + 1).each do |marble|
      self.checkMarble(marble, current, scores)
    end
    return scores.sort { |a, b| b <=> a }[0]
  end

  def checkMarble(marble : Int32, current : Deque, scores : Array)
    if marble % 23 == 0
      current.rotate!(-7)
      scores[marble % @players] += marble + current.pop
      current.rotate!(1)
    else
      current.rotate!(1)
      current.push marble
    end
  end

  def self.test
    puts "Hello"
  end
end

solution = Solution.new input

time = Time.monotonic
puts "Part 1:\t#{solution.part1} in #{(Time.monotonic - time).milliseconds}ms"
time = Time.monotonic
puts "Part 2:\t#{solution.part2} in #{(Time.monotonic - time).milliseconds}ms"
