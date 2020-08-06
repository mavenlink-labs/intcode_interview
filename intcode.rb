require_relative 'memory'
require_relative 'instruction'

class Intcode
  attr_reader :output

  JUMP_OPCODES = [5, 6].freeze

  def initialize(memory, input: [])
    @memory = Memory.new(memory)
    @input = input.dup
    @output = []
  end

  def run
    loop do
      return @memory.raw if @memory[@memory.pointer] == 99

      opcode, param_1_mode, param_2_mode, param_3_mode = translate_instruction
      instruction = case opcode
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

      instruction.execute

      @memory.advance_pointer unless JUMP_OPCODES.include? opcode
    end
  end

  private

  def translate_instruction
    instruction_digits = @memory.at_pointer.to_s.rjust(5, '0')

    opcode = instruction_digits[3..4].to_i
    param_1_mode = instruction_digits[2].to_i
    param_2_mode = instruction_digits[1].to_i
    param_3_mode = instruction_digits[0].to_i

    [opcode, param_1_mode, param_2_mode, param_3_mode]
  end
end
