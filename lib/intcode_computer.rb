class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 99]
  INSTRUCTION_WIDTH = 4

  def self.operate(instructions)
    raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(instructions.first)
    pointer = 0
    opcode = instructions.first

    while opcode != 99
      opcode = instructions[pointer]

      if opcode == 1
        pointer_1 = instructions[1 + pointer]
        pointer_2 = instructions[2 + pointer]
        index_pointer = instructions[3 + pointer]
        result = instructions[pointer_1] + instructions[pointer_2]
        instructions[index_pointer] = result
      end

      if opcode == 2
        pointer_1 = instructions[1 + pointer]
        pointer_2 = instructions[2 + pointer]
        index_pointer = instructions[3 + pointer]
        result = instructions[pointer_1] * instructions[pointer_2]
        instructions[index_pointer] = result
      end

      pointer += INSTRUCTION_WIDTH
    end

    instructions
  end
end
