infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n")

Solution.new input

class Solution
  @pos = Array(Array(Int32)).new
  @vel = Array(Array(Int32)).new

  def initialize(@input : Array(String))
    self.run
  end

  def run
    time1 = Time.monotonic
    part1res = self.part1
    time2 = Time.monotonic
    puts "Day 10:\t#{part1res} in #{self.print_time(time2 - time1)}"
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
    @input.each do |line|
      f1, f2, r1, r2 = [line.index('<'), line.index('>'), line.rindex('<'), line.rindex('>')]
      if f1 && f2 && r1 && r2
        @pos << line[f1 + 1..f2 - 1].split(',').map { |v| v.to_i }
        @vel << line[r1 + 1..r2 - 1].split(',').map { |v| v.to_i }
      end
    end

    minx, maxx, miny, maxy = self.min_max_pos(@pos)
    leastx, leasty = [(minx - maxx).abs, (miny - maxy).abs]
    (0..UInt16::MAX).each do |time|
      minx, maxx, miny, maxy = moves(time)
      bounds = [(minx - maxx).abs, (miny - maxy).abs]
      if (bounds[0] + bounds[1]) <= leastx + leasty
        leastx = bounds[0]
        leasty = bounds[1]
      else
        time -= 1
        minx, maxx, miny, maxy = moves(time)
        bounds = [(minx - maxx).abs, (miny - maxy).abs]
        map = Array.new(bounds[1] + 1) { |_| Array.new(bounds[0] + 1) { |_| ' ' } }
        Range.new(0, @pos.size, true).each do |index|
          ymove = (@pos[index][1] - miny.abs) + (@vel[index][1] * time)
          xmove = (@pos[index][0] - minx.abs) + (@vel[index][0] * time)
          map[ymove][xmove] = '█'
        end
        map.each { |row| puts row.join }
        return time
      end
    end
  end

  def min_max_pos(arr : Array(Array(Int32)))
    miny, maxy, minx, maxx = [arr[0][1], arr[0][1], arr[0][0], arr[0][0]]
    arr.each do |pos|
      y = pos[1]
      miny = (y < miny) ? y : miny
      maxy = (y > maxy) ? y : maxy
      x = pos[0]
      minx = (x < minx) ? x : minx
      maxx = (x > maxx) ? x : maxx
    end
    return [minx, maxx, miny, maxy]
  end

  def moves(time : Int32)
    moves = Array(Array(Int32)).new
    Range.new(0, @pos.size, true).each do |index|
      xmove = @pos[index][0] + @vel[index][0] * time
      ymove = @pos[index][1] + @vel[index][1] * time
      moves << [xmove, ymove]
    end
    return self.min_max_pos(moves)
  end
end
