class Instruction
  attr_reader :memory

  def initialize(memory)
    @memory = memory
  end

  def execute; end

  def get_param(mode)
    @memory.advance_pointer

    case mode
    when 0
      param = @memory.value_from_pointer
    when 1
      param = @memory.at_pointer
    when 2
      param = @memory.value_from_relative_base
    else
      raise ArgumentError, 'unknown parameter mode'
    end

    param
  end

  def set_memory_for_param(mode, new_value)
    @memory.advance_pointer
    case mode
    when 0
      index = @memory.at_pointer
      @memory[index] = new_value
    when 1
      @memory[@memory.pointer] = new_value
    when 2
      @memory[@memory.relative_base + @memory.at_pointer] = new_value
    else
      raise ArgumentError, 'unknown parameter mode'
    end
  end
end

class OperationInstruction < Instruction
  attr_reader :left, :right, :answer

  def initialize(memory, left, right, answer)
    super(memory)
    @left = left
    @right = right
    @answer = answer
  end

  def operate
    a = get_param(left)
    b = get_param(right)

    set_memory_for_param(answer, yield(a, b))
  end
end

class AddInstruction < OperationInstruction
  def execute
    operate { |a, b| a + b }
  end
end

class MultiplyInstruction < OperationInstruction
  def execute
    operate { |a, b| a * b }
  end
end

class InputInstruction < Instruction
  def initialize(memory, input, param_mode)
    super(memory)
    @input = input
    @param_mode = param_mode
  end

  def execute
    raise StandardError, 'no inputs available!!' if @input.empty?

    next_input = @input.shift
    set_memory_for_param(@param_mode, next_input)
  end
end

class OutputInstruction < Instruction
  def initialize(memory, output, param_mode)
    super(memory)
    @output = output
    @param_mode = param_mode
  end

  def execute
    output_value = get_param(@param_mode)
    @output.push(output_value)
  end
end

class JumpInstruction < Instruction
end

class JumpIfTrueInstruction < JumpInstruction
end
