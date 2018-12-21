infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end

Solution.new input

class Solution
  def initialize(@input : String)
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
    recipes = [3, 7]
    elves = [0, 1]
    startsize = recipes.size
    improve_by = @input.to_i - startsize
    while recipes.size < startsize + improve_by + 10
      score = recipes[elves[0]] + recipes[elves[1]]
      score.to_s.chars.each { |c| recipes << c.to_i }
      elves[0] = (elves[0] + recipes[elves[0]] + 1) % recipes.size
      elves[1] = (elves[1] + recipes[elves[1]] + 1) % recipes.size
    end
    range = startsize + improve_by
    return recipes.join[range..range + 9]
  end

  def part2
    recipes = [3, 7]
    elves = [0, 1]
    stop_at = @input.chars.map { |c| c.to_i }
    loop do
      score = recipes[elves[0]] + recipes[elves[1]]
      score.to_s.chars.each { |c| recipes << c.to_i }
      elves[0] = (elves[0] + recipes[elves[0]] + 1) % recipes.size
      elves[1] = (elves[1] + recipes[elves[1]] + 1) % recipes.size

      if recipes.size >= stop_at.size
        break if recipes[recipes.size - stop_at.size..recipes.size] == stop_at
      end
    end
    return recipes.join.index(stop_at.join)
  end
end
