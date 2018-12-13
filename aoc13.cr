infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n")

Solution.new input

class Solution
  def initialize(@input : Array(String))
    self.run
  end

  def run
    time1 = Time.monotonic
    solution = self.solution
    time2 = Time.monotonic
    puts "Result:\t#{solution} in #{self.print_time(time2 - time1)}"
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

  enum Direction
    Up
    Right
    Down
    Left
  end

  class Cart
    property step, x, y, below, dir, moved, crashed

    def initialize(x : Int32, y : Int32, below : Char, current : Direction)
      @step = 0
      @moved = false
      @crashed = false
      @y = y
      @x = x
      @below = below
      @dir = current
    end
  end

  def solution
    carts = [] of Cart
    coords = Array.new(@input.size) { |_| Array.new(@input[0].size) { |_| ' ' } }

    # Parse input into map and carts
    Range.new(0, @input.size, true).each do |y|
      Range.new(0, @input[0].size, true).each do |x|
        spot = @input[y][x]
        case spot
        when '<'
          carts << Cart.new(x, y, '-', Direction::Left)
        when '>'
          carts << Cart.new(x, y, '-', Direction::Right)
        when '^'
          carts << Cart.new(x, y, '|', Direction::Up)
        when 'v'
          carts << Cart.new(x, y, '|', Direction::Down)
        end
        coords[y][x] = @input[y][x]
      end
    end

    intersection = {"x" => 0, "y" => 0, "crash" => false, "first" => true}

    while carts.dup.reject! { |oc| oc.crashed }.size > 1
      # Order top-left to bottom-right
      carts.each { |cart| cart.moved = false }
      rows = carts.map { |cart| cart.y }.sort.to_set
      rows.each do |row|
        carts.dup.reject! { |cart| cart.y != row }.each do |cart|
          if !cart.moved && !cart.crashed
            if cart.below == '+'
              # turn on intersect
              case cart.step % 3
              when 0 # turn left
                case cart.dir
                when Direction::Up    then cart.dir = Direction::Left
                when Direction::Right then cart.dir = Direction::Up
                when Direction::Down  then cart.dir = Direction::Right
                when Direction::Left  then cart.dir = Direction::Down
                end
              when 1 # go straight
              when 2 # turn right
                case cart.dir
                when Direction::Up    then cart.dir = Direction::Right
                when Direction::Right then cart.dir = Direction::Down
                when Direction::Down  then cart.dir = Direction::Left
                when Direction::Left  then cart.dir = Direction::Up
                end
              end
              cart.step += 1
            end
            # replace coords with previous
            coords[cart.y][cart.x] = cart.below
            # move cart
            case cart.dir
            when Direction::Up    then cart.y -= 1
            when Direction::Right then cart.x += 1
            when Direction::Down  then cart.y += 1
            when Direction::Left  then cart.x -= 1
            end
            # swap out chars
            cart.below = coords[cart.y][cart.x]
            case cart.dir
            when Direction::Up    then coords[cart.y][cart.x] = '^'
            when Direction::Right then coords[cart.y][cart.x] = '>'
            when Direction::Down  then coords[cart.y][cart.x] = 'v'
            when Direction::Left  then coords[cart.y][cart.x] = '<'
            end
            case cart.below
            when '/' # turn on curve
              case cart.dir
              when Direction::Up    then cart.dir = Direction::Right
              when Direction::Right then cart.dir = Direction::Up
              when Direction::Down  then cart.dir = Direction::Left
              when Direction::Left  then cart.dir = Direction::Down
              end
            when '\\' # turn on curve
              case cart.dir
              when Direction::Up    then cart.dir = Direction::Left
              when Direction::Right then cart.dir = Direction::Down
              when Direction::Down  then cart.dir = Direction::Right
              when Direction::Left  then cart.dir = Direction::Up
              end
            when '<', '>', '^', 'v' # handle crash
              # Part 1 solution
              if intersection["first"]
                intersection["x"] = cart.x
                intersection["y"] = cart.y
                intersection["crash"] = true
                intersection["first"] = false
              end

              # mark crash
              carts.dup.reject! { |oc| oc.x != cart.x && oc.y != cart.y }.each { |crashcart| crashcart.crashed = true }
              cart.crashed = true

              # swap chart
              coords[cart.y][cart.x] = @input[cart.y][cart.x]

              # remove crashes
              carts.reject! { |oc| oc.crashed }
            end

            cart.moved = true
          end
        end
      end
    end

    # Part 2
    lastcart = carts.dup.reject! { |oc| oc.crashed }.not_nil![0]
    result = {"First intersection" => [intersection["x"], intersection["y"]], "Last remaining" => [lastcart.x, lastcart.y]}
    return result
  end

  def part2
    return 0
  end
end
