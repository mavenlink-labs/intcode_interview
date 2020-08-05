class Intcode
  def read_tape(input)
    tape = input.dup

    position = 0
    loop do
      return tape if tape[position] == 99

      case tape[position]
      when 1
        add! tape, position
        position += 4
      when 2
        multiply! tape, position
        position += 4
      else
        raise ArgumentError, 'unexpected opcode'
      end
    end
  end

  private

  def add!(tape, current_position)
    operate!(tape, current_position) { |a, b| a + b }
  end

  def multiply!(tape, current_position)
    operate!(tape, current_position) { |a, b| a * b }
  end

  def operate!(tape, current_position)
    read_a_index = tape[current_position + 1]
    read_b_index = tape[current_position + 2]
    save_at_index = tape[current_position + 3]

    a = tape[read_a_index]
    b = tape[read_b_index]
    tape[save_at_index] = yield a, b
  end
end
