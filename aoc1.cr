infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split('\n').map { |v| v.to_i }

Solution.new input

class Solution
  def initialize(@input : Array(Int32))
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

  def part1
    return @input.reduce { |acc, v| acc + v }
  end

  def part2
    set = ([] of Int32).to_set
    return repeat_until_double(set, 0)
  end

  def repeat_until_double(set : Set(Int32), start : Int32)
    @input.each do |v|
      start += v
      if set.size == set.add(start).size
        return start
      end
    end
    return repeat_until_double(set, start)
  end
end
