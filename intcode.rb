class Intcode
  def initialize(memory)
    @memory = memory.dup
    @pointer = 0
  end

  def run
    loop do
      return @memory if @memory[@pointer] == 99

      case @memory[@pointer]
      when 1
        add!
        @pointer += 4
      when 2
        multiply!
        @pointer += 4
      else
        raise ArgumentError, 'unexpected opcode'
      end
    end
  end

  private

  def add!
    operate! { |a, b| a + b }
  end

  def multiply!
    operate! { |a, b| a * b }
  end

  def operate!
    read_a_index = @memory[@pointer + 1]
    read_b_index = @memory[@pointer + 2]
    save_at_index = @memory[@pointer + 3]

    a = @memory[read_a_index]
    b = @memory[read_b_index]
    @memory[save_at_index] = yield a, b
  end
end
