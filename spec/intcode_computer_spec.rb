require 'spec_helper'
require 'intcode_computer'

describe IntcodeComputer do
  it 'can be initialized' do
    subject = IntcodeComputer.new
    expect(subject).to_not be_nil
  end

  it 'crashes on unexpected opcodes' do
    instructions = [98]
    expect {
      IntcodeComputer.operate(instructions: instructions)
    }.to raise_error IntcodeComputer::UnsupportedOpCode
  end

  it 'can handle opcode 99' do
    instructions = [99]

    expect(IntcodeComputer.operate(instructions: instructions)).to eq([99])
  end

  it "supports opcode 1" do
    instructions = [1, 0, 0, 1, 99]

    expect(IntcodeComputer.operate(instructions: instructions)).to eq [1,2,0,1,99]
  end

  it "supports opcode 2" do
    instructions = [2, 0, 0, 1,99]

    expect(IntcodeComputer.operate(instructions: instructions)).to eq [2,4,0,1,99]
  end

  it "supports opcode 3" do
    instructions = [3, 0, 99]
    input = [1, 2, 3, 4]

    expect(IntcodeComputer.operate(instructions: instructions, input: input)).to eq [1, 0, 99]
  end

  it "supports opcode 4" do
    instructions = [4, 2, 99]
    output = []

    IntcodeComputer.operate(instructions: instructions, output: output)
    expect(output).to eq [99]
  end

  it "supports immediate mode" do
    instructions = [11101, 5, 6, 3, 99]
    expected_output = [11101, 5, 6, 11, 99]

    expect(IntcodeComputer.operate(instructions: instructions)).to eq expected_output
  end

  it "supports multiple additions" do
    instructions = [1, 0, 0, 1, 1, 0, 1, 2, 99]

    expect(IntcodeComputer.operate(instructions: instructions)).to eq [1, 2, 3, 1, 1, 0, 1, 2, 99]
  end

  it "it handles unsupported opcodes in insturctions" do
    instructions = [1, 0, 0, 1, 98]

    expect{ IntcodeComputer.operate(instructions: instructions) }.to raise_error IntcodeComputer::UnsupportedOpCode
  end
end
