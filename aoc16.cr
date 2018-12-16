infile = "../aoc#{PROGRAM_NAME.split("aoc")[1].split('.')[0]}.txt"
input = File.new(infile).gets_to_end

Solution.new input

class Solution
  property register, instructions, program, opcodes

  def initialize(@input : String)
    @register = Array(Int32).new(4) { |_| 0 }
    @instructions = Array(Array(Array(Int32))).new
    @program = Array(Array(Int32)).new
    @opcodes = Hash(Int32, String).new
    # find end of instructions and start of program
    split_point = @input.index("\n", @input.rindex("After:").not_nil! + 1).not_nil!
    op_in = @input[0..split_point].split("Before: ").map { |op| op.split("\n") }
    pr_in = @input[split_point..@input.size].split("\n")
    # cleanup parsing
    op_in.each { |op| op.reject! { |ins| ins == "" } }
    op_in.reject! { |op| op.size == 0 }
    # parse to int
    op_in.each { |op|
      before = op[0].gsub('[', "").gsub(']', "").split(',').map { |v| v.to_i }
      opcode = op[1].split(" ").map { |v| v.to_i }
      after = op[2].gsub("After:  ", "").gsub(']', "").gsub('[', "").split(',').map { |v| v.to_i }
      @instructions << [before, opcode, after]
    }
    @program = pr_in.reject! { |op| op == "" }.map { |v| v.split(" ").map { |i| i.to_i } }

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

  # addition
  def addr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] + register[inst[2]]
    return register
  end

  def addi(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] + inst[2]
    return register
  end

  # multiplication
  def mulr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] * register[inst[2]]
    return register
  end

  def muli(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] * inst[2]
    return register
  end

  # bitwise and
  def banr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] & register[inst[2]]
    return register
  end

  def bani(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] & inst[2]
    return register
  end

  # bitwise or
  def borr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] | register[inst[2]]
    return register
  end

  def bori(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]] | inst[2]
    return register
  end

  # assignment
  def setr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = register[inst[1]]
    return register
  end

  def seti(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = inst[1]
    return register
  end

  # greater than testing
  def gtir(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = (inst[1] > register[inst[2]]) ? 1 : 0
    return register
  end

  def gtri(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = (register[inst[1]] > inst[2]) ? 1 : 0
    return register
  end

  def gtrr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = (register[inst[1]] > register[inst[2]]) ? 1 : 0
    return register
  end

  # equality testing
  def eqir(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = (inst[1] == register[inst[2]]) ? 1 : 0
    return register
  end

  def eqri(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = (register[inst[1]] == inst[2]) ? 1 : 0
    return register
  end

  def eqrr(inst : Array(Int32), register = [] of Int32)
    register[inst[3]] = (register[inst[1]] == register[inst[2]]) ? 1 : 0
    return register
  end

  def part1
    results = 0
    first = true
    while opcodes.size < 16
      @instructions.each { |op|
        before = op[0]
        instruction = op[1]
        after = op[2]
        correct = Array(String).new
        (addr(instruction, before.dup) == after && correct << "addr")
        (addi(instruction, before.dup) == after && correct << "addi")
        (mulr(instruction, before.dup) == after && correct << "mulr")
        (muli(instruction, before.dup) == after && correct << "muli")
        (banr(instruction, before.dup) == after && correct << "banr")
        (bani(instruction, before.dup) == after && correct << "bani")
        (borr(instruction, before.dup) == after && correct << "borr")
        (bori(instruction, before.dup) == after && correct << "bori")
        (setr(instruction, before.dup) == after && correct << "setr")
        (seti(instruction, before.dup) == after && correct << "seti")
        (gtri(instruction, before.dup) == after && correct << "gtri")
        (gtir(instruction, before.dup) == after && correct << "gtir")
        (gtrr(instruction, before.dup) == after && correct << "gtrr")
        (eqri(instruction, before.dup) == after && correct << "eqri")
        (eqir(instruction, before.dup) == after && correct << "eqir")
        (eqrr(instruction, before.dup) == after && correct << "eqrr")
        # Only count part 1 results the first time
        if first
          results += (correct.size > 2) ? 1 : 0
        end
        # Remove already known opcodes from the new array of samples where opcode was correct
        @opcodes.values.each { |found|
          correct.reject! { |corr| corr == found }
        }
        # Add new opcode to global opcode Hash
        if correct.size == 1
          @opcodes[instruction[0]] = "#{correct[0]}"
        end
      }
      first = false
    end
    return results
  end

  def part2
    @program.each { |instruction|
      case @opcodes[instruction[0]]
      when "addr" then addr(instruction, @register)
      when "addi" then addi(instruction, @register)
      when "mulr" then mulr(instruction, @register)
      when "muli" then muli(instruction, @register)
      when "banr" then banr(instruction, @register)
      when "bani" then bani(instruction, @register)
      when "borr" then borr(instruction, @register)
      when "bori" then bori(instruction, @register)
      when "setr" then setr(instruction, @register)
      when "seti" then seti(instruction, @register)
      when "gtri" then gtri(instruction, @register)
      when "gtir" then gtir(instruction, @register)
      when "gtrr" then gtrr(instruction, @register)
      when "eqri" then eqri(instruction, @register)
      when "eqir" then eqir(instruction, @register)
      when "eqrr" then eqrr(instruction, @register)
      end
    }
    return @register[0]
  end
end
