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

      case @memory[@pointer]
      when 1
        add
      when 2
        multiply
      when 3
        use_input
      when 4
        append_output
      else
        raise ArgumentError, 'unexpected opcode'
      end
    end
  end

  private

  def add
    operate { |a, b| a + b }
  end

  def multiply
    operate { |a, b| a * b }
  end

  def operate
    read_a_index = @memory[@pointer + 1]
    read_b_index = @memory[@pointer + 2]
    save_at_index = @memory[@pointer + 3]

    a = @memory[read_a_index]
    b = @memory[read_b_index]
    @memory[save_at_index] = yield a, b
    @pointer += 4
  end

  def use_input
    next_input = @input.shift
    input_position = @memory[@pointer + 1]

    @memory[input_position] = next_input
    @pointer += 2
  end

  def append_output
    output_position = @memory[@pointer + 1]
    output_value = @memory[output_position]
    @output.push(output_value)
    @pointer += 2
  end
end
