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

  it 'raises if the tape has an invalid opcode' do
    tape = [78, 0, 0, 0, 99]
    expect { subject.read_tape(tape) }.to raise_error(ArgumentError, /unexpected opcode/)
  end

  it 'is calibrated correctly' do
    tape = [1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,2,19,9,23,1,23,5,27,2,6,27,31,1,31,5,35,1,35,5,39,2,39,6,43,2,43,10,47,1,47,6,51,1,51,6,55,2,55,6,59,1,10,59,63,1,5,63,67,2,10,67,71,1,6,71,75,1,5,75,79,1,10,79,83,2,83,10,87,1,87,9,91,1,91,10,95,2,6,95,99,1,5,99,103,1,103,13,107,1,107,10,111,2,9,111,115,1,115,6,119,2,13,119,123,1,123,6,127,1,5,127,131,2,6,131,135,2,6,135,139,1,139,5,143,1,143,10,147,1,147,2,151,1,151,13,0,99,2,0,14,0]
    expect(subject.read_tape(tape).first).to eq 4576384
  end
end
