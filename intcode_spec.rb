require_relative 'spec_helper'
require_relative 'intcode'

describe Intcode do
  subject { Intcode.new }
  it 'returns immediately if the first code is 99' do
    tape = [99]
    expect(subject.read_tape(tape)).to eq tape
  end

  it 'can add numbers' do
    tape = [1, 0, 0, 0, 99]
    expect(subject.read_tape(tape)).to eq [2, 0, 0, 0, 99]
  end

  it 'can multiply numbers' do
    tape = [2, 3, 0, 3, 99]
    expect(subject.read_tape(tape)).to eq [2, 3, 0, 6, 99]
  end

  it 'can use 99 in math' do
    tape = [2, 4, 4, 5, 99, 0]
    expect(subject.read_tape(tape)).to eq [2, 4, 4, 5, 99, 9801]
  end

  it 'can do it all, my man' do
    tape = [1, 1, 1, 4, 99, 5, 6, 0, 99]
    expect(subject.read_tape(tape)).to eq [30, 1, 1, 4, 2, 5, 6, 0, 99]

  end
end
