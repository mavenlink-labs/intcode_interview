class Intcode
  attr_reader :output

  def initialize(memory, input: [])
    @memory = memory.dup
    @pointer = 0
    @input = input.dup
    @output = []
    @relative_base = 0
  end

  def run
    loop do
      return @memory if read_memory(@pointer) == 99

      opcode, param_1_mode, param_2_mode, param_3_mode = translate_instruction
      case opcode
      when 1
        add_instruction param_1_mode, param_2_mode, param_3_mode
      when 2
        multiple_instruction param_1_mode, param_2_mode, param_3_mode
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
    end
  end

  private

  def translate_instruction
    instruction_digits = read_pointer.to_s.rjust(5, '0')

    opcode = instruction_digits[3..4].to_i
    param_1_mode = instruction_digits[2].to_i
    param_2_mode = instruction_digits[1].to_i
    param_3_mode = instruction_digits[0].to_i

    [opcode, param_1_mode, param_2_mode, param_3_mode]
  end

  def add_instruction(left, right, answer)
    operate(left, right, answer) { |a, b| a + b }
  end

  def multiple_instruction(left, right, answer)
    operate(left, right, answer) { |a, b| a * b }
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
    advance_pointer
  end

  def get_param(mode)
    advance_pointer

    case mode
    when 0
      param = read_memory(read_pointer)
    when 1
      param = read_pointer
    when 2
      param = read_memory(@relative_base + read_pointer)
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
      set_memory(index, new_value)
    when 1
      set_memory(@pointer, new_value)
    when 2
      set_memory(@relative_base + read_pointer, new_value)
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end

  def input_instruction(param_mode)
    raise StandardError, 'no inputs available!!' if @input.empty?

    next_input = @input.shift
    set_memory_for_param(param_mode, next_input)
    advance_pointer
  end

  def output_instruction(param_mode)
    output_value = get_param(param_mode)
    @output.push(output_value)
    advance_pointer
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
      @pointer = get_param(param_mode)
    else
      # advance pointer once to move past param 2
      advance_pointer
      # advance it again to move to the next instruction
      advance_pointer
    end
  end

  def adjust_relative_base_instruction(param_mode)
    adjust_by = get_param(param_mode)
    @relative_base += adjust_by
    advance_pointer
  end

  def advance_pointer
    @pointer += 1
  end

  def read_pointer
    read_memory(@pointer)
  end

  def read_memory(index)
    reallocate_memory(index) if index >= @memory.length

    value = @memory[index]
    value
  end

  def set_memory(index, value)
    reallocate_memory(index) if index >= @memory.length

    @memory[index] = value
  end

  def reallocate_memory(next_requested_index)
    new_length = next_requested_index + 1

    @memory.fill(0, @memory.length..new_length)
  end
end
