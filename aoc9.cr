infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new("../aoc9.txt").gets_to_end

Solution.new input

class Solution
  @players : Int32
  @highest : Int32

  def initialize(@input : String)
    @players = @input.split(' ')[0].to_i
    @highest = @input.split(' ')[6].to_i
    self.run
  end

  def run
    time1 = Time.monotonic
    part1res = self.part1
    time2 = Time.monotonic
    puts "Part 1:\t#{part1res} in #{self.printTime(time2 - time1)}"
    time1 = Time.monotonic
    part2res = self.part2
    time2 = Time.monotonic
    puts "Part 2:\t#{part2res} in #{self.printTime(time2 - time1)}"
  end

  def printTime(time : Time::Span)
    if time.seconds > 1
      return "#{time.seconds}s"
    elsif time.milliseconds > 1
      return "#{time.milliseconds}ms"
    elsif time.microseconds > 1
      return "#{time.microseconds}µs"
    else
      return "#{time.nanoseconds}ns"
    end
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
end
