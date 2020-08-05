class Memory
  attr_reader :raw
  def initialize(initial_memory = [])
    @raw = initial_memory.dup
  end

  def [](index)
    reallocate(index) if index >= raw.length

    raw[index]
  end

  def []=(index, value)
    reallocate(index) if index >= raw.length

    raw[index] = value
  end

  private

  def reallocate(next_requested_index)
    new_length = next_requested_index + 1

    raw.fill(0, raw.length..new_length)
  end
end
