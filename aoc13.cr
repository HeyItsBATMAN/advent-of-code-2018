infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end.split("\n")

Solution.new input

class Solution
  @carts : Array(Cart)
  @coords : Array(Array(Char))

  def initialize(@input : Array(String))
    @carts = Array(Cart).new
    @coords = @input.dup.map { |line| line.chars }
    self.run
  end

  def run
    time1 = Time.monotonic
    solution = self.solution
    time2 = Time.monotonic
    puts "Result:"
    puts "First intersection:\t#{solution["First intersection"]}"
    puts "Last remaining:\t\t#{solution["Last remaining"]}"
    puts "in #{self.print_time(time2 - time1)}"
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
    property step, x, y, dir, moved, crashed, below

    def initialize(x : Int32, y : Int32, below : Char, current : Direction)
      @step = 0
      @below = below
      @moved = false
      @crashed = false
      @y = y
      @x = x
      @dir = current
    end

    def move
      if !@moved
        if @below == '+'
          self.intersect
        end
        # move cart
        case @dir
        when Direction::Up    then @y -= 1
        when Direction::Right then @x += 1
        when Direction::Down  then @y += 1
        when Direction::Left  then @x -= 1
        end
      end
      @moved = true
    end

    def turn
      case @below
      when '/' # turn on curve
        case @dir
        when Direction::Up    then @dir = Direction::Right
        when Direction::Right then @dir = Direction::Up
        when Direction::Down  then @dir = Direction::Left
        when Direction::Left  then @dir = Direction::Down
        end
      when '\\' # turn on curve
        case @dir
        when Direction::Up    then @dir = Direction::Left
        when Direction::Right then @dir = Direction::Down
        when Direction::Down  then @dir = Direction::Right
        when Direction::Left  then @dir = Direction::Up
        end
      end
    end

    def intersect
      # turn on intersect
      case @step % 3
      when 0 # turn left
        case @dir
        when Direction::Up    then @dir = Direction::Left
        when Direction::Right then @dir = Direction::Up
        when Direction::Down  then @dir = Direction::Right
        when Direction::Left  then @dir = Direction::Down
        end
      when 1 # go straight
      when 2 # turn right
        case @dir
        when Direction::Up    then @dir = Direction::Right
        when Direction::Right then @dir = Direction::Down
        when Direction::Down  then @dir = Direction::Left
        when Direction::Left  then @dir = Direction::Up
        end
      end
      @step += 1
    end
  end

  def solution
    # Parse input into map and carts

    Range.new(0, @coords.size, true).each do |y|
      Range.new(0, @coords[y].size, true).each do |x|
        case @coords[y][x]
        when '<'
          @carts << Cart.new(x, y, '-', Direction::Left)
          @coords[y][x] = '-'
        when '>'
          @carts << Cart.new(x, y, '-', Direction::Right)
          @coords[y][x] = '-'
        when '^'
          @carts << Cart.new(x, y, '|', Direction::Up)
          @coords[y][x] = '|'
        when 'v'
          @carts << Cart.new(x, y, '|', Direction::Down)
          @coords[y][x] = '|'
        end
      end
    end

    intersection = {"x" => 0, "y" => 0, "crash" => false, "first" => true}

    while @carts.size > 1
      # Order top-left to bottom-right
      @carts.each { |cart| cart.moved = false }
      rows = @carts.map { |cart| cart.y }.sort.to_set
      rows.each do |row|
        @carts.dup.reject! { |cart| cart.y != row }.each { |cart|
          if !cart.moved && !cart.crashed
            # move
            cart.move
            cart.below = @coords[cart.y][cart.x]
            cart.turn
            @carts.each do |cart2|
              if cart != cart2
                if cart.y == cart2.y && cart.x == cart2.x
                  cart.crashed = true
                  cart2.crashed = true
                  # Part 1
                  if intersection["first"]
                    intersection["x"] = cart.x
                    intersection["y"] = cart.y
                    intersection["crash"] = true
                    intersection["first"] = false
                  end
                  @carts.reject! { |oc| oc.crashed }
                end
              end
            end
          end
        }
      end
    end

    # Part 2
    return {"First intersection" => [intersection["x"], intersection["y"]], "Last remaining" => [@carts[0].x, @carts[0].y]}
  end
end
