class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 3, 99]
  INSTRUCTION_WIDTH = 4

  def self.operate(instructions, input = [])
    pointer = 0

    while (opcode = instructions[pointer]) != 99
      raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(opcode)

      instruction = InstructionFactory.build(pointer: pointer, instructions: instructions)

      instruction.execute

      if opcode == 3
        instruction.change_witdh
        result = input.pop
      end

      pointer += instruction.width
    end

    instructions
  end
end

module InstructionFactory
  def self.build(pointer:, instructions:)
    opcode = instructions[pointer]
    case opcode
    when 1
      Addition.new(pointer: pointer, instructions: instructions)
    when 2
      Multiplication.new(pointer: pointer, instructions: instructions)
    else
      Instruction.new(pointer: pointer, instructions: instructions)
    end
  end
end

class Instruction
  attr_reader :l_pointer, :r_pointer, :l_val, :r_val

  def initialize(pointer:, instructions:)
    @pointer = pointer
    @l_pointer = instructions[1 + pointer]
    @r_pointer = instructions[2 + pointer]
    @l_val = instructions[@l_pointer]
    @r_val = instructions[@r_pointer]
    @write_pointer = instructions[pointer + 3]
    @instructions = instructions
  end

  def write(val)
    instructions[write_pointer] = val
  end

  def change_witdh
    @write_pointer = instructions[@pointer + 1]
  end

  def execute
    raise NotImplementedError, "You must implement execute in your subclass"
  end

  def width
    raise NotImplementedError, "You must implement width in your subclass"
  end

  private

  attr_reader :instructions, :write_pointer
end

class Addition < Instruction
  def execute
    write(l_val + r_val)
  end

  def width
    4
  end
end

class Multiplication < Instruction
  def execute
    write(l_val * r_val)
  end

  def width
    4
  end
end
