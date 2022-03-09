class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1, 2, 99]

  def self.operate(instructions)
    raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(instructions.first)

    opcode = instructions.first
    if opcode == 1
      pointer_1 = instructions[1]
      pointer_2 = instructions[2]
      index_pointer = instructions[3]
      result = instructions[pointer_1] + instructions[pointer_2]
      instructions[index_pointer] = result
    end

    if opcode == 2
      pointer_1 = instructions[1]
      pointer_2 = instructions[2]
      index_pointer = instructions[3]
      result = instructions[pointer_1] * instructions[pointer_2]
      instructions[index_pointer] = result
    end

    instructions
  end
end
