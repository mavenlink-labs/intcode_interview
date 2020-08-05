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
        raise 'bingus'
      end
    end

  end

  def add!(tape, current_position)
    read_a_index = tape[current_position + 1]
    read_b_index = tape[current_position + 2]
    save_at_index = tape[current_position + 3]

    tape[save_at_index] = tape[read_a_index] + tape[read_b_index]
  end

  def multiply!(tape, current_position)
    read_a_index = tape[current_position + 1]
    read_b_index = tape[current_position + 2]
    save_at_index = tape[current_position + 3]

    tape[save_at_index] = tape[read_a_index] * tape[read_b_index]
  end
end
