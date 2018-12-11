infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.to_i

Solution.new input

class Solution
  @coords : Array(Array(Int32))

  def initialize(@input : Int32)
    @coords = Array.new(301) { |y| Array.new(301) { |x| calcPowerLevel(x, y) } }
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

  def calcPowerLevel(x, y)
    rackid = x + 11
    powerlevel = rackid * (y + 1)
    powerlevel += @input
    powerlevel *= rackid
    powerlevel = ((powerlevel / 100) % 10).floor
    powerlevel -= 5
    return powerlevel
  end

  def printGrid(startx, starty, size)
    Range.new(starty, starty + size, true).each do |y|
      row = ""
      Range.new(startx, startx + size, true).each do |x|
        row += @coords[y][x].to_s + "\t"
      end
      puts row
    end
  end

  def highestSumOfGridSize(gridsize)
    hx, hy, hv = [0, 0, 0]
    Range.new(0, @coords.size - gridsize, true).each do |y|
      Range.new(0, @coords.size - gridsize, true).each do |x|
        sum = 0
        Range.new(0, gridsize, true).each do |gy|
          Range.new(0, gridsize, true).each do |gx|
            sum += @coords[gy + y][gx + x]
          end
        end
        if sum > hv
          hx, hy, hv = [x, y, sum]
        end
      end
    end
    hx, hy = [hx + 1, hy + 1]
    return [hx, hy, hv, gridsize]
  end

  def part1
    return highestSumOfGridSize(3)
  end

  def part2
    highest = [0, 0, 0, 0]
    failed = 0
    maxfails = 3
    Range.new(1, 300).each do |size|
      newhighest = highestSumOfGridSize(size)
      if newhighest[2] > highest[2]
        failed = 0
        highest = newhighest
      else
        failed += 1
        if failed == maxfails
          return highest
        end
      end
    end
  end
end
