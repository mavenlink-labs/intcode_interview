require_relative 'spec_helper'
require_relative 'intcode'

describe Intcode do
  it 'returns immediately if the first code is 99' do
    tape = [99]
    subject = Intcode.new
    expect(subject.read_tape(tape)).to eq tape
  end

  it 'can add numbers' do
    tape = [1, 0, 0, 0, 99]
    subject = Intcode.new
    expect(subject.read_tape(tape)).to eq [2, 0, 0, 0, 99]
  end

  it 'can multiply numbers' do
    tape = [2, 3, 0, 3, 99]
    subject = Intcode.new
    expect(subject.read_tape(tape)).to eq [2, 3, 0, 6, 99]
  end
end
