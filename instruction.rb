class Instruction
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
  def initialize(memory, left_param_mode, right_param_mode, answer_param_mode)
    super(memory)
    @left_param_mode = left_param_mode
    @right_param_mode = right_param_mode
    @answer_param_mode = answer_param_mode
  end

  def operate
    a = get_param(@left_param_mode)
    b = get_param(@right_param_mode)

    set_memory_for_param(@answer_param_mode, yield(a, b))
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

class LessThanInstruction < OperationInstruction
  def execute
    operate { |a, b| a < b ? 1 : 0 }
  end
end

class EqualsInstruction < OperationInstruction
  def execute
    operate { |a, b| a == b ? 1 : 0 }
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

class AdjustRelativeBaseInstruction < Instruction
  def initialize(memory, param_mode)
    super(memory)
    @param_mode = param_mode
  end

  def execute
    adjust_by = get_param(@param_mode)
    @memory.relative_base += adjust_by
  end
end

class JumpInstruction < Instruction
  def initialize(memory, value_mode, param_mode)
    super(memory)
    @value_mode = value_mode
    @param_mode = param_mode
  end

  def jump_if
    value = get_param(@value_mode)

    if yield value
      @memory.pointer = get_param(@param_mode)
    else
      # advance pointer once to move past param 2
      # advance it again to move to the next instruction
      @memory.advance_pointer(2)
    end
  end
end

class JumpIfTrueInstruction < JumpInstruction
  def execute
    jump_if { |v| !v.zero? }
  end
end

class JumpIfFalseInstruction < JumpInstruction
  def execute
    jump_if(&:zero?)
  end
end
