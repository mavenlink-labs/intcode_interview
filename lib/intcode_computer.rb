class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 3, 99]
  INSTRUCTION_WIDTH = 4

  def self.operate(instructions, input = [])
    pointer = 0

    while (opcode = instructions[pointer]) != 99
      raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(opcode)

      instruction = InstructionFactory.build(pointer: pointer, instructions: instructions, input: input)

      instruction.execute

      pointer += instruction.width
    end

    instructions
  end
end

module InstructionFactory
  def self.build(pointer:, instructions:, input:[])
    opcode = instructions[pointer]
    case opcode
    when 1
      Addition.new(pointer: pointer, instructions: instructions)
    when 2
      Multiplication.new(pointer: pointer, instructions: instructions)
    when 3
      Read.new(pointer: pointer, instructions: instructions, input: input)
    else
      Instruction.new(pointer: pointer, instructions: instructions)
    end
  end
end

class Instruction
  attr_reader :input

  def initialize(pointer:, instructions:, input: [])
    @pointer = pointer
    @instructions = instructions
    @input = input
  end

  def write(val)
    instructions[write_pointer] = val
  end

  def write_pointer
    instructions[pointer + width - 1]
  end

  def l_pointer
    instructions[1 + pointer]
  end

  def l_val
    instructions[l_pointer]
  end

  def r_pointer
    instructions[2 + pointer]
  end

  def r_val
    instructions[r_pointer]
  end

  def execute
    raise NotImplementedError, "You must implement execute in your subclass"
  end

  def width
    raise NotImplementedError, "You must implement width in your subclass"
  end

  private

  attr_reader :instructions, :pointer
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

class Read < Instruction
  def execute
    write(input.pop)
  end

  def width
    2
  end
end
