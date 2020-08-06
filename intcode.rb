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
      return @memory.raw if @memory[@memory.pointer] == 99

      opcode, param_1_mode, param_2_mode, param_3_mode = translate_instruction
      case opcode
      when 1
        AddInstruction
          .new(@memory, param_1_mode, param_2_mode, param_3_mode)
          .execute
      when 2
        MultiplyInstruction
          .new(@memory, param_1_mode, param_2_mode, param_3_mode)
          .execute
      when 3
        input_instruction param_1_mode
      when 4
        output_instruction param_1_mode
      when 5
        jump_if_true_instruction param_1_mode, param_2_mode
      when 6
        jump_if_false_instruction param_1_mode, param_2_mode
      when 7
        less_than_instruction param_1_mode, param_2_mode, param_3_mode
      when 8
        equals_instruction param_1_mode, param_2_mode, param_3_mode
      when 9
        adjust_relative_base_instruction param_1_mode
      else
        raise ArgumentError, "unexpected opcode #{opcode}"
      end

      @memory.advance_pointer unless JUMP_OPCODES.include? opcode
    end
  end

  JUMP_OPCODES = [5, 6].freeze

  private

  def translate_instruction
    instruction_digits = read_pointer.to_s.rjust(5, '0')

    opcode = instruction_digits[3..4].to_i
    param_1_mode = instruction_digits[2].to_i
    param_2_mode = instruction_digits[1].to_i
    param_3_mode = instruction_digits[0].to_i

    [opcode, param_1_mode, param_2_mode, param_3_mode]
  end

  def equals_instruction(left, right, answer)
    operate(left, right, answer) { |a, b| a == b ? 1 : 0 }
  end

  def less_than_instruction(left, right, answer)
    operate(left, right, answer) { |a, b| a < b ? 1 : 0 }
  end

  def operate(left, right, answer)
    a = get_param(left)
    b = get_param(right)

    set_memory_for_param(answer, yield(a, b))
  end

  def get_param(mode)
    @memory.advance_pointer

    case mode
    when 0
      param = @memory[read_pointer]
    when 1
      param = read_pointer
    when 2
      param = @memory[@memory.relative_base + read_pointer]
    else
      raise ArgumentError, 'unknown parameter mode'
    end

    param
  end

  def set_memory_for_param(mode, new_value)
    @memory.advance_pointer
    case mode
    when 0
      index = read_pointer
      @memory[index] = new_value
    when 1
      @memory[@memory.pointer] = new_value
    when 2
      @memory[@memory.relative_base + read_pointer] = new_value
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end

  def input_instruction(param_mode)
    raise StandardError, 'no inputs available!!' if @input.empty?

    next_input = @input.shift
    set_memory_for_param(param_mode, next_input)
  end

  def output_instruction(param_mode)
    output_value = get_param(param_mode)
    @output.push(output_value)
  end

  def jump_if_true_instruction(value_mode, param_mode)
    jump_if_instruction(value_mode, param_mode) { |v| !v.zero? }
  end

  def jump_if_false_instruction(value_mode, param_mode)
    jump_if_instruction(value_mode, param_mode, &:zero?)
  end

  def jump_if_instruction(value_mode, param_mode)
    value = get_param(value_mode)

    if yield value
      @memory.pointer = get_param(param_mode)
    else
      # advance pointer once to move past param 2
      # advance it again to move to the next instruction
      @memory.advance_pointer(2)
    end
  end

  def adjust_relative_base_instruction(param_mode)
    adjust_by = get_param(param_mode)
    @memory.relative_base += adjust_by
  end

  def read_pointer
    @memory[@memory.pointer]
  end
end
