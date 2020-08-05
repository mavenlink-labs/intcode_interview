class Intcode
  def initialize(memory)
    @memory = memory.dup
  end

  def run
    position = 0
    loop do
      return @memory if @memory[position] == 99

      case @memory[position]
      when 1
        add! position
        position += 4
      when 2
        multiply! position
        position += 4
      else
        raise ArgumentError, 'unexpected opcode'
      end
    end
  end

  private

  def add!(current_position)
    operate!(current_position) { |a, b| a + b }
  end

  def multiply!(current_position)
    operate!(current_position) { |a, b| a * b }
  end

  def operate!(current_position)
    read_a_index = @memory[current_position + 1]
    read_b_index = @memory[current_position + 2]
    save_at_index = @memory[current_position + 3]

    a = @memory[read_a_index]
    b = @memory[read_b_index]
    @memory[save_at_index] = yield a, b
  end
end
