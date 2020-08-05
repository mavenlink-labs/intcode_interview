class Intcode
  attr_reader :output

  def initialize(memory, input: [])
    @memory = memory.dup
    @pointer = 0
    @input = input.dup
    @output = []
  end

  def run
    loop do
      return @memory if @memory[@pointer] == 99

      instruction = translate_instruction
      case instruction[:opcode]
      when 1
        add instruction
      when 2
        multiply instruction
      when 3
        use_input instruction
      when 4
        append_output instruction
      else
        raise ArgumentError, 'unexpected opcode'
      end
    end
  end

  private

  def translate_instruction
    instruction_digits = @memory[@pointer].to_s.rjust(5, '0')

    {
      param_1_mode: instruction_digits[0].to_i,
      param_2_mode: instruction_digits[1].to_i,
      param_3_mode: instruction_digits[2].to_i,
      opcode: instruction_digits[3..4].to_i
    }
  end

  def add(instruction)
    operate(instruction) { |a, b| a + b }
  end

  def multiply(instruction)
    operate(instruction) { |a, b| a * b }
  end

  def operate(instruction)
    a = get_param(instruction[:param_1_mode])
    b = get_param(instruction[:param_2_mode])

    set_param(instruction[:param_3_mode], yield(a, b))
    advance_pointer
  end

  def get_param(mode)
    advance_pointer
    case mode
    when 0
      index = @memory[@pointer]
      @memory[index]
    # when 1
    #   @memory[@pointer]
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
    # when 1
    #   @memory[@pointer] = new_value
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end

  def use_input(instruction)
    next_input = @input.shift
    set_param(instruction[:param_1_mode], next_input)
    advance_pointer
  end

  def append_output(instruction)
    output_value = get_param(instruction[:param_1_mode])
    @output.push(output_value)
    advance_pointer
  end

  def advance_pointer
    @pointer += 1
  end
end
