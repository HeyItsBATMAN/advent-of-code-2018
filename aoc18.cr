infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n")
exinput = ".#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.".split("\n")

Solution.new input

# Solution.new exinput

class Solution
  def initialize(@input : Array(String))
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

  def step(map)
    maxy = map.size
    maxx = map[0].size
    newmap = map.dup.map { |y| y.map { |_| '.' } }
    map.size.times { |y| map[y].size.times { |x|
      spot = map[y][x]
      treecount = 0
      lumbercount = 0
      smallx = x - 1 >= 0 ? x - 1 : x
      smally = y - 1 >= 0 ? y - 1 : y
      bigx = x + 1 < maxx ? x + 1 : x
      bigy = y + 1 < maxy ? y + 1 : y
      Range.new(smally, bigy).each do |ny|
        treecount += map[ny][smallx..bigx].count { |s| s == '|' }
        lumbercount += map[ny][smallx..bigx].count { |s| s == '#' }
      end

      if spot == '.'
        newmap[y][x] = treecount >= 3 ? '|' : '.'
      elsif spot == '|'
        newmap[y][x] = lumbercount >= 3 ? '#' : '|'
      elsif spot == '#'
        lumbercount -= 1
        newmap[y][x] = (treecount >= 1 && lumbercount >= 1) ? '#' : '.'
      end
    } }
    return newmap
  end

  def get_score(map)
    treecount = 0
    lumbercount = 0
    map.each { |row|
      treecount += row.count { |s| s == '|' }
      lumbercount += row.count { |s| s == '#' }
    }
    return treecount * lumbercount
  end

  def part1
    map = Array.new(@input.size) { |_| Array.new(@input[0].size) { |_| '.' } }
    @input.size.times { |y| @input[y].chars.size.times { |x| map[y][x] = @input[y][x] } }

    minutes = 10
    Range.new(1, minutes).each do |_|
      map = step(map)
    end

    return get_score(map)
  end

  def part2
    map = Array.new(@input.size) { |_| Array.new(@input[0].size) { |_| '.' } }
    @input.size.times { |y| @input[y].chars.size.times { |x| map[y][x] = @input[y][x] } }

    minutes = 1000000000
    period = 0
    maps = Set(Array(Array(Char))).new
    Range.new(1, minutes).each do |minute|
      map = step(map)
      if maps.size == maps.add(map).size
        period = (minute - maps.index(map).not_nil!) - 1
      end
      if period != 0 && minutes % period == minute % period
        break
      end
    end

    return get_score(map)
  end
end
