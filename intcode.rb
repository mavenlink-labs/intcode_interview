class Intcode
  def read_tape(input)
    tape = input.dup

    position = 0
    while true
      code = tape[position]
      return tape if code == 99

      return nil
    end

  end
end
