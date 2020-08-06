class Memory
  attr_reader :raw
  attr_accessor :pointer, :relative_base

  def initialize(initial_memory = [])
    @raw = initial_memory.dup
    @pointer = 0
    @relative_base = 0
  end

  def advance_pointer(by = 1)
    @pointer += by
  end

  def at_pointer
    self[@pointer]
  end

  def at_pointer=(value)
    self.at_pointer = value
  end

  def value_from_pointer
    self[at_pointer]
  end

  def value_from_pointer=(value)
    self[at_pointer] = value
  end

  def value_from_relative_base
    self[relative_base + at_pointer]
  end

  def value_from_relative_base=(value)
    self[relative_base + at_pointer] = value
  end

  private

  def [](index)
    reallocate(index) if index >= raw.length

    raw[index]
  end

  def []=(index, value)
    reallocate(index) if index >= raw.length

    raw[index] = value
  end

  def reallocate(next_requested_index)
    new_length = next_requested_index + 1

    raw.fill(0, raw.length..new_length)
  end
end
