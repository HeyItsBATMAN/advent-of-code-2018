infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n")
exinput = "x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504".split("\n")

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
    # time1 = Time.monotonic
    # part2res = self.part2
    # time2 = Time.monotonic
    # puts "Part 2:\t#{part2res} in #{self.print_time(time2 - time1)}"
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
    # parse input to clay hashes {x => x, y => y}
    clay = Array(Hash(String, Int32)).new
    @input.each { |line|
      split = line.split(", ")
      lsplit = split[0].split("=")
      rsplit = split[1].split("=")
      range = rsplit[1].split("..").map { |c| c.to_i }
      (range[0]..range[1]).each do |i|
        clay << {lsplit[0] => lsplit[1].to_i, rsplit[0] => i}
      end
    }
    # bounds
    claysorted = clay.dup.sort { |a, b| a["x"] <=> b["x"] }
    minx = claysorted[0]["x"] - 1
    maxx = claysorted[claysorted.size - 1]["x"] + 2
    claysorted = clay.dup.sort { |a, b| b["y"] <=> a["y"] }
    miny = 0
    maxy = claysorted[0]["y"] + 1
    offset = minx
    clay.each { |c| c["x"] -= offset }
    # map
    map = Array.new(maxy) { |_| Array.new(maxx - offset) { |_| ' ' } }
    clay.each { |c| map[c["y"]][c["x"]] = '█' }
    # water
    water = [{"x" => 500 - offset, "y" => 0}].to_set
    map[water.dup.to_a[0]["y"]][water.dup.to_a[0]["x"]] = '|'
    not_flown = 0
    flowing = false

    loop do
      flowing = false
      lowestflowing = water.dup.to_a.reject! { |a| map[a["y"]][a["x"]] != '|' }.sort { |a, b| b["y"] <=> a["y"] }[0]["y"]
      water.each { |w|
        x = w["x"]
        y = w["y"]
        next if y >= map.size - 1 || y < 0
        next if x >= map[y].size - 1 || x < 0
        c = map[y][x]
        d = map[y + 1][x]
        l = map[y][x - 1]
        r = map[y][x + 1]

        if c == '|'
          # check if still flowing
          if (l == '~' && r == '~') || (l == '~' && r == '█') || (r == '~' && l == '█') || (r == '█' && l == '█') || (r == '~' && l == '|') || (r == '~' && l == '|')
            map[y][x] = '~'
            flowing = true
          end
          # spread to sides
          if d == '█'
            if (l == '~' && r == '~') || (l == '|' && r == '█') || (l == '█' && r == '|') || (l == '█' && r == '█') || (l == '|' && r == '|')
              map[y][x] = '~'
              flowing = true
            end
            if l == ' '
              map[y][x - 1] = '|'
              water << {"y" => y, "x" => x - 1}
              flowing = true
            end
            if r == ' '
              map[y][x + 1] = '|'
              water << {"y" => y, "x" => x + 1}
              flowing = true
            end
          end
          # flow down
          if d == ' '
            map[y + 1][x] = '|'
            water << {"y" => y + 1, "x" => x}
            flowing = true
          end
          # only flow if at bottom of flow
          if d == '~' && y == lowestflowing
            if l == ' '
              map[y][x - 1] = '~'
              water << {"y" => y, "x" => x - 1}
              flowing = true
            end
            if r == ' '
              map[y][x + 1] = '~'
              water << {"y" => y, "x" => x + 1}
              flowing = true
            end
          end
        elsif c == '~'
          if d == '█' || d == '~'
            if l == ' '
              map[y][x - 1] = '~'
              water << {"y" => y, "x" => x - 1}
              flowing = true
            elsif r == ' '
              map[y][x + 1] = '~'
              water << {"y" => y, "x" => x + 1}
              flowing = true
            end
          else
            map[y][x] = '|'
            map[y + 1][x] = '|'
            water << {"y" => y + 1, "x" => x}
            cy = y - 2
            while cy > 0 && map[cy][x] == '|'
              water = water.to_a.reject! { |ws| ws["y"] == cy && ws["x"] == x }.to_set
              map[cy][x]
              cy -= 1
            end
          end
        end
      }
      if !flowing
        not_flown += 1
      else
        not_flown = 0
      end
      break if not_flown > 1
    end

    counter = -1
    map.each { |row|
      row.each { |spot|
        if spot == '|' || spot == '~'
          counter += 1
        end
      }
    }

    map.size.times { |m|
      if map[m].join.includes?('|') || map[m].join.includes?('~')
        puts "#{m}\t#{map[m].join}"
      else
        break
      end
    }

    return counter
  end

  def part2
    return @input.size
  end
end
