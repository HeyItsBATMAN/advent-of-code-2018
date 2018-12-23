infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n").reject! { |line| line == "" }

Solution.new input

class Solution
  property ero, target

  def initialize(@input : Array(String))
    @target = Array(Int32).new
    @ero = Array(Array(Int32)).new
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
    depth = @input[0].split(": ")[1].not_nil!.to_i
    target = @input[1].split(": ")[1].not_nil!.split(",").map { |v| v.to_i }
    geo = Array.new(2000) { |_| Array.new(100) { |_| 0 } }
    ero = Array.new(2000) { |_| Array.new(100) { |_| 0 } }

    geo.size.times { |y| geo[y][0] = y * 48271 }
    geo[0].size.times { |x| geo[0][x] = x * 16807 }
    geo[0][0] = 0
    geo[target[1]][target[0]] = 0

    risklevel = 0

    geo.size.times { |y| geo[y].size.times { |x|
      if (x == 0 && y == 0) || (x == target[0] && y == target[1]) || (y == 0 && x != 0) || (x == 0 && y != 0) || x - 1 < 0 || y - 1 < 0
        geo[y][x] = ((geo[y][x] + depth) % 20183)
      else
        geo[y][x] = ((geo[y][x - 1] * geo[y - 1][x]) + depth) % 20183
      end

      cero = geo[y][x] % 3

      ero[y][x] = (cero == 0) ? 0 : (cero == 1) ? 1 : 2
      risklevel += (y <= target[1] && x <= target[0]) ? cero : 0
    } }
    @ero = ero.dup
    @target = target.dup
    return risklevel
  end

  def check_tool(s : Int32, t : Int32)
    return true if s == 0 && (t == 0 || t == 1)
    return true if s == 1 && (t == 1 || t == 2)
    return true if s == 2 && (t == 0 || t == 2)
    return false
  end

  def part2
    ysize = @ero.size
    xsize = @ero[0].size
    seen = Set(Array(Int32)).new
    q = Array(Hash(String, Int32)).new
    dy = [1, 0, -1, 0]
    dx = [0, 1, 0, -1]

    # 0 torch | 1 climbing | 2 neither
    q << {"y" => 0, "x" => 0, "d" => 0, "t" => 0}

    while q.size > 0
      c = q.min_by { |cc| cc["d"] }
      q.reject! { |cc| cc == c }

      # return on goal
      return c["d"] if c["y"] == @target[1] && c["x"] == @target[0] && c["t"] == 0

      # skip on seen
      next if seen.includes? [c["x"], c["y"], c["t"]]
      seen << [c["x"], c["y"], c["t"]]

      # switch tool
      (0..2).each { |t| q << {"y" => c["y"], "x" => c["x"], "d" => c["d"] + 7, "t" => t} if check_tool(@ero[c["y"]][c["x"]], t) }

      # check neighbours
      (0..3).each do |i|
        yy = c["y"] + dy[i]
        xx = c["x"] + dx[i]
        next if yy < 0 || yy >= ysize || xx < 0 || xx >= xsize
        q << {"y" => yy, "x" => xx, "d" => c["d"] + 1, "t" => c["t"]} if check_tool(@ero[yy][xx], c["t"])
      end
    end
  end
end
