require_relative 'memory'
require_relative 'instruction'

class Intcode
  attr_reader :output

  def initialize(memory, input: [])
    @memory = Memory.new(memory)
    @input = input.dup
    @output = []
  end

  def run
    loop do
      return @memory.raw if @memory.at_pointer == 99

      read_instruction.execute
    end
  end

  private

  def read_instruction
    opcode, param_1_mode, param_2_mode, param_3_mode = parse_instruction

    case opcode
    when 1
      AddInstruction.new(@memory, param_1_mode, param_2_mode, param_3_mode)
    when 2
      MultiplyInstruction.new(@memory, param_1_mode, param_2_mode, param_3_mode)
    when 3
      InputInstruction.new(@memory, @input, param_1_mode)
    when 4
      OutputInstruction.new(@memory, @output, param_1_mode)
    when 5
      JumpIfTrueInstruction.new(@memory, param_1_mode, param_2_mode)
    when 6
      JumpIfFalseInstruction.new(@memory, param_1_mode, param_2_mode)
    when 7
      LessThanInstruction.new(@memory, param_1_mode, param_2_mode, param_3_mode)
    when 8
      EqualsInstruction.new(@memory, param_1_mode, param_2_mode, param_3_mode)
    when 9
      AdjustRelativeBaseInstruction .new(@memory, param_1_mode)
    else
      raise ArgumentError, "unexpected opcode #{opcode}"
    end
  end

  def parse_instruction
    instruction_digits = @memory.at_pointer.to_s.rjust(5, '0')

    opcode = instruction_digits[3..4].to_i
    param_1_mode = instruction_digits[2].to_i
    param_2_mode = instruction_digits[1].to_i
    param_3_mode = instruction_digits[0].to_i

    [opcode, param_1_mode, param_2_mode, param_3_mode]
  end
end
