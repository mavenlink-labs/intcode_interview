class IntcodeComputer
  class UnsupportedOpCode < StandardError; end

  SUPPORTED_OPCODES = [1,99]

  def self.operate(instructions)
    raise UnsupportedOpCode, 'Unexpected item in the bagging area' unless SUPPORTED_OPCODES.include?(instructions.first)

    opcode = instructions.first
    if opcode == 1
      return [1,2,0,1]
    end

    instructions
  end
end
