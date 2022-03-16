class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 3, 99]
  INSTRUCTION_WIDTH = 4

  def self.operate(instructions, input = [])
    pointer = 0

    while (opcode = instructions[pointer]) != 99
      raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(opcode)

      instruction = Instruction.new(pointer: pointer, instructions: instructions)

      if opcode == 1
        result = instruction.l_val + instruction.r_val
      end

      if opcode == 2
        result = instruction.l_val * instruction.r_val
      end

      if opcode == 3
        instruction.change_witdh
        result = input.pop
      end

      instruction.write(result)

      pointer += INSTRUCTION_WIDTH
    end

    instructions
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

  private

  attr_reader :instructions, :write_pointer
end
