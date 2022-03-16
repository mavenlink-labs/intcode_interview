class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 99]
  INSTRUCTION_WIDTH = 4

  def self.operate(instructions)
    pointer = 0

    while (opcode = instructions[pointer]) != 99
      raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(opcode)

      pointer_1 = instructions[1 + pointer]
      pointer_2 = instructions[2 + pointer]
      index_pointer = instructions[3 + pointer]

      if opcode == 1
        result = instructions[pointer_1] + instructions[pointer_2]
      end

      if opcode == 2
        result = instructions[pointer_1] * instructions[pointer_2]
      end

      instructions[index_pointer] = result

      pointer += INSTRUCTION_WIDTH
    end

    instructions
  end
end
