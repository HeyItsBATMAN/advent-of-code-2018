require "stumpy_png"
include StumpyPNG

input = File.new("../aoc13.txt").gets_to_end.split("\n")

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
    property step, x, y, dir, moved, crashed, below, num

    def initialize(x : Int32, y : Int32, below : Char, current : Direction, num : Int32)
      @step = 0
      @num = num
      @below = below
      @moved = false
      @crashed = false
      @y = y
      @x = x
      @dir = current
    end

    def move
      if !@moved
        (@below == '+' && self.intersect)
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
          @carts << Cart.new(x, y, '-', Direction::Left, @carts.size)
          @coords[y][x] = '-'
        when '>'
          @carts << Cart.new(x, y, '-', Direction::Right, @carts.size)
          @coords[y][x] = '-'
        when '^'
          @carts << Cart.new(x, y, '|', Direction::Up, @carts.size)
          @coords[y][x] = '|'
        when 'v'
          @carts << Cart.new(x, y, '|', Direction::Down, @carts.size)
          @coords[y][x] = '|'
        end
      end
    end

    canvas = Canvas.new(@coords.size*5, @coords[0].size*5)

    crashes = [] of Hash(String, Int32)

    intersection = {"x" => 0, "y" => 0, "crash" => false, "first" => true}

    Range.new(0, 20000).each do |i|
      # Visualize
      # Fill map
      @coords.size.times { |y|
        @coords[y].size.times { |x|
          case @coords[y][x]
          when '+'
            canvas[(5*x) + 0, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 0] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 1] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 1, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 2, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 4, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)

            canvas[(5*x) + 0, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 3] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 4] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
          when '|'
            canvas[(5*x) + 0, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 0] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 1] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 2] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 2] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 2] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 2] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 3] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 4] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
          when '-'
            canvas[(5*x) + 0, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 3, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 3, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 1, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 2, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 4, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)

            canvas[(5*x) + 0, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 3, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 3, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
          when '/', '\\'
            canvas[(5*x) + 0, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 3, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 0] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 1] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 2, (5*y) + 1] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 1] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 4, (5*y) + 1] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 2] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 2, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 2] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 4, (5*y) + 2] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 3] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 2, (5*y) + 3] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 3, (5*y) + 3] = RGBA.from_rgb_n(255, 255, 255, 8)
            canvas[(5*x) + 4, (5*y) + 3] = RGBA.from_rgb_n(0, 0, 0, 8)

            canvas[(5*x) + 0, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 1, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 2, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 3, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
            canvas[(5*x) + 4, (5*y) + 4] = RGBA.from_rgb_n(0, 0, 0, 8)
          else
            5.times { |dy| 5.times { |dx| canvas[(5*x) + dx, (5*y) + dy] = RGBA.from_rgb_n(0, 0, 0, 8) } }
          end
        }
      }

      # Put crashes
      crashes.each { |crash|
        canvas[(5*crash["x"]) + 0, (5*crash["y"]) + 0] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 1, (5*crash["y"]) + 0] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 3, (5*crash["y"]) + 0] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 4, (5*crash["y"]) + 0] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 0, (5*crash["y"]) + 1] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 1, (5*crash["y"]) + 1] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 3, (5*crash["y"]) + 1] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 4, (5*crash["y"]) + 1] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 2, (5*crash["y"]) + 2] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 0, (5*crash["y"]) + 3] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 1, (5*crash["y"]) + 3] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 3, (5*crash["y"]) + 3] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 4, (5*crash["y"]) + 3] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 0, (5*crash["y"]) + 4] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 1, (5*crash["y"]) + 4] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 3, (5*crash["y"]) + 4] = RGBA.from_rgb_n(255, 0, 0, 8)
        canvas[(5*crash["x"]) + 4, (5*crash["y"]) + 4] = RGBA.from_rgb_n(255, 0, 0, 8)
      }

      # Put carts
      @carts.each { |cart|
        5.times { |dy| 5.times { |dx| canvas[(5*cart.x) + dx, (5*cart.y) + dy] = RGBA.from_rgb_n(cart.num * 15, 128, 128, 8) } }
      }

      if i % 1000 == 0
        puts "#{i} / 20000"
      end

      # Output
      if i < 10
        number = "0000#{i}"
      elsif i < 100 && i >= 10
        number = "000#{i}"
      elsif i < 1000 >= 100
        number = "00#{i}"
      elsif i < 10000 >= 1000
        number = "0#{i}"
      else
        number = i.to_s
      end
      StumpyPNG.write(canvas, "day13out/image-#{number}.png")

      # Order top-left to bottom-right
      @carts.each { |cart| cart.moved = false }
      @carts.map { |cart| cart.y }.sort.to_set.each { |row|
        @carts.dup.reject! { |cart| cart.y != row }.each { |cart|
          if !cart.moved && !cart.crashed
            # move
            cart.move
            cart.below = @coords[cart.y][cart.x]
            cart.turn
            @carts.each { |cart2|
              if cart.y == cart2.y && cart.x == cart2.x && cart != cart2
                cart.crashed = true
                cart2.crashed = true

                crashes << {"x" => cart.x, "y" => cart.y}

                # Part 1
                if intersection["first"]
                  intersection["x"] = cart.x
                  intersection["y"] = cart.y
                  intersection["crash"] = true
                  intersection["first"] = false
                end
                @carts.reject! { |oc| oc.crashed }
              end
            }
          end
        }
      }
    end
    # Part 2
    return {"First intersection" => [intersection["x"], intersection["y"]], "Last remaining" => [@carts[0].x, @carts[0].y]}
  end
end
