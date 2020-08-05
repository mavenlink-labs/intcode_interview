require_relative 'memory'

class Intcode
  attr_reader :output

  def initialize(memory, input: [])
    @memory = Memory.new(memory)
    @pointer = 0
    @input = input.dup
    @output = []
    @relative_base = 0
    @instruction_params = []
  end

  def run
    loop do
      return @memory.raw if @memory[@pointer] == 99

      opcode = translate_instruction
      case opcode
      when 1
        add_instruction
      when 2
        multiple_instruction
      when 3
        input_instruction
      when 4
        output_instruction
      when 5
        jump_if_true_instruction
      when 6
        jump_if_false_instruction
      when 7
        less_than_instruction
      when 8
        equals_instruction
      when 9
        adjust_relative_base_instruction
      else
        raise ArgumentError, "unexpected opcode #{opcode}"
      end

      advance_pointer unless JUMP_OPCODES.include? opcode
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

    @instruction_params = [param_1_mode, param_2_mode, param_3_mode]
    opcode
  end

  def add_instruction
    operate { |a, b| a + b }
  end

  def multiple_instruction
    operate { |a, b| a * b }
  end

  def equals_instruction
    operate { |a, b| a == b ? 1 : 0 }
  end

  def less_than_instruction
    operate { |a, b| a < b ? 1 : 0 }
  end

  def operate
    left, right, answer = @instruction_params
    a = get_param(left)
    b = get_param(right)

    set_memory_for_param(answer, yield(a, b))
  end

  def get_param(mode)
    advance_pointer

    case mode
    when 0
      param = @memory[read_pointer]
    when 1
      param = read_pointer
    when 2
      param = @memory[@relative_base + read_pointer]
    else
      raise ArgumentError, 'unknown parameter mode'
    end

    param
  end

  def set_memory_for_param(mode, new_value)
    advance_pointer
    case mode
    when 0
      index = read_pointer
      @memory[index] = new_value
    when 1
      @memory[@pointer] = new_value
    when 2
      @memory[@relative_base + read_pointer] = new_value
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end

  def input_instruction
    raise StandardError, 'no inputs available!!' if @input.empty?

    next_input = @input.shift
    set_memory_for_param(@instruction_params.first, next_input)
  end

  def output_instruction
    output_value = get_param(@instruction_params.first)
    @output.push(output_value)
  end

  def jump_if_true_instruction
    jump_if_instruction { |v| !v.zero? }
  end

  def jump_if_false_instruction
    jump_if_instruction(&:zero?)
  end

  def jump_if_instruction
    value_mode, param_mode = @instruction_params
    value = get_param(value_mode)

    if yield value
      @pointer = get_param(param_mode)
    else
      # advance pointer once to move past param 2
      advance_pointer
      # advance it again to move to the next instruction
      advance_pointer
    end
  end

  def adjust_relative_base_instruction
    adjust_by = get_param(@instruction_params.first)
    @relative_base += adjust_by
  end

  def advance_pointer
    @pointer += 1
  end

  def read_pointer
    @memory[@pointer]
  end
end
