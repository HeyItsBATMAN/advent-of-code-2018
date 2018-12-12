require "big"

infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n")

Solution.new input

class Solution
  @state : String

  def initialize(@input : Array(String))
    @state = @input[0]
    # Remove initial state and empty
    @input.shift
    @input.shift
    # Extend state to left and right
    @state = @state.gsub("initial state: ") { "" }
    @state += ""

    self.run
  end

  def run
    time1 = Time.monotonic
    part1res = self.part1
    time2 = Time.monotonic
    puts "Part 1:\t#{part1res} in #{self.print_time(time2 - time1)}"
    time1 = Time.monotonic
    part2res = self.part2
    time2 = Time.monotonic
    puts "Part 2:\t#{part2res} in #{self.print_time(time2 - time1)}"
  end

  def print_time(time : Time::Span)
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

  def calc_sum_of_plants(range : BigInt | Int32)
    state = @state.dup
    rules = Hash(String, String).new
    @input.each { |rule| rules[rule.split(' ')[0]] = rule.split(' ')[0][0..1] + rule.split(' ')[2] + rule.split(' ')[0][3..4] }
    start = 0
    laststate = ""
    Range.new(1, range).each do |i|
      # Remove or add leading dots
      first = state.index('#').not_nil!
      (4 - first).abs.times {
        start += ((4 - first) >= 0) ? 1 : -1
        state = ((4 - first) >= 0) ? "." + state : state.lchop
      }

      # Add trailing dots
      (5 - ((state.size) - state.rindex('#').not_nil!)).times { state += "." }

      # Make empty state
      newstate = state.gsub('#', '.')

      # Apply rule
      (state.size - 4).times { |ind| newstate = newstate.sub(ind + 2, rules.values[rules.key_index(state[ind..ind + 4]).not_nil!][2]) }

      if newstate[1..newstate.size - 1] == state[0..state.size - 2] || i == range
        # Check for repeating pattern
        puts start
        offset = newstate.index('#').not_nil!
        sum = 0
        while offset
          sum += offset - start
          offset = newstate.index('#', offset + 1)
        end
        if i != range
          pots = newstate.count('#').not_nil!
          sum += (range - i) * pots
        end
        return sum
      else
        # Overwrite last state for comparison
        laststate = state
        state = newstate
      end
    end
  end

  def part1
    return calc_sum_of_plants(20)
  end

  def part2
    return calc_sum_of_plants(BigInt.new("50000000000"))
  end
end
