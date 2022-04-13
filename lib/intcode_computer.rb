class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 3, 4, 99]
  INSTRUCTION_WIDTH = 4

  def self.operate(instructions:, input: [], output: [])
    input = input.reverse

    ticker = InstructionTicker.new(instructions, input, output)
    while ticker.has_next?
      raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(ticker.current_opcode)

      instruction = ticker.next_instruction

      instruction.execute

      ticker.tick!(instruction.width)
    end

    instructions
  end

  def self.extract_mode(value)
    digits = (value/100).digits
    [0,0,0].map.with_index do |value, index|
      digits[index] || value
    end
  end
end

class InstructionTicker
  attr_reader :instructions, :pointer, :input, :output
  def initialize(instructions, input, output)
    @instructions = instructions
    @pointer = 0
    @output = output
    @input = input
  end

  def has_next?
    current_opcode != 99
  end

  def current_opcode
    instructions[pointer] % 100
  end

  def tick!(width)
    self.pointer += width
  end

  def next_instruction
    InstructionFactory.build(pointer: pointer, instructions: instructions, input: input, output: output)
  end

  private
  attr_writer :pointer
end

module InstructionFactory
  def self.build(pointer:, instructions:, input:[], output: [])
    opcode = instructions[pointer] % 100
    case opcode
    when 1
      Addition.new(pointer: pointer, instructions: instructions)
    when 2
      Multiplication.new(pointer: pointer, instructions: instructions)
    when 3
      Read.new(pointer: pointer, instructions: instructions, input: input)
    when 4
      Write.new(pointer: pointer, instructions: instructions, output: output)
    else
      Instruction.new(pointer: pointer, instructions: instructions)
    end
  end
end

class Instruction
  attr_reader :input, :output

  def initialize(pointer:, instructions:, input: [], output: [])
    @pointer = pointer
    @instructions = instructions
    @input = input
    @output = output
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

class Write < Instruction
  def execute
    output.push(l_val)
  end

  def width
    2
  end
end
