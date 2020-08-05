class Intcode
  attr_reader :output, :memory

  def initialize(memory, input: [])
    @memory = memory.dup
    @pointer = 0
    @input = input.dup
    @output = []
    @relative_base = 0
  end

  def run
    loop do
      return @memory if @memory[@pointer] == 99

      meta = translate_instruction
      case meta[:opcode]
      when 1
        add_instruction meta
      when 2
        multiple_instruction meta
      when 3
        input_instruction meta
      when 4
        output_instruction meta
      when 5
        jump_if_true_instruction meta
      when 6
        jump_if_false_instruction meta
      when 7
        less_than_instruction meta
      when 8
        equals_instruction meta
      when 9
        adjust_relative_base_instruction meta
      else
        raise ArgumentError, "unexpected opcode #{meta[:opcode]}"
      end
    end
  end

  private

  def translate_instruction
    instruction_digits = @memory[@pointer].to_s.rjust(5, '0')

    {
      param_3_mode: instruction_digits[0].to_i,
      param_2_mode: instruction_digits[1].to_i,
      param_1_mode: instruction_digits[2].to_i,
      opcode: instruction_digits[3..4].to_i
    }
  end

  def add_instruction(meta)
    operate(meta) { |a, b| a + b }
  end

  def multiple_instruction(meta)
    operate(meta) { |a, b| a * b }
  end

  def equals_instruction(meta)
    operate(meta) { |a, b| a == b ? 1 : 0 }
  end

  def less_than_instruction(meta)
    operate(meta) { |a, b| a < b ? 1 : 0 }
  end

  def operate(meta)
    a = get_param(meta[:param_1_mode])
    b = get_param(meta[:param_2_mode])

    set_param(meta[:param_3_mode], yield(a, b))
    advance_pointer
  end

  def get_param(mode)
    advance_pointer

    case mode
    when 0
      index = @memory[@pointer]
      @memory[index]
    when 1
      @memory[@pointer]
    when 2
      parameter = @memory[@pointer]
      @memory[@relative_base + parameter]
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end

  def set_param(mode, new_value)
    advance_pointer
    case mode
    when 0
      index = @memory[@pointer]
      @memory[index] = new_value
    when 1
      @memory[@pointer] = new_value
    when 2
      @relative_base = new_value
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end

  def input_instruction(meta)
    next_input = @input.shift
    set_param(meta[:param_1_mode], next_input)
    advance_pointer
  end

  def output_instruction(meta)
    output_value = get_param(meta[:param_1_mode])
    @output.push(output_value)
    advance_pointer
  end

  def jump_if_true_instruction(meta)
    jump_if_instruction(meta) { |v| !v.zero? }
  end

  def jump_if_false_instruction(meta)
    jump_if_instruction(meta, &:zero?)
  end

  def jump_if_instruction(meta)
    value = get_param(meta[:param_1_mode])

    if yield value
      @pointer = get_param(meta[:param_2_mode])
    else
      # advance pointer once to move past param 2
      advance_pointer
      # advance it again to move to the next instruction
      advance_pointer
    end
  end

  def adjust_relative_base_instruction(meta)
    adjust_by = get_param(meta[:param_1_mode])
    @relative_base += adjust_by
    advance_pointer
  end

  def advance_pointer
    @pointer += 1
  end
end
