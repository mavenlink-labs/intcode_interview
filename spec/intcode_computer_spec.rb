require 'spec_helper'
require 'intcode_computer'

describe IntcodeComputer do
  it 'can be initialized' do
    subject = IntcodeComputer.new
    expect(subject).to_not be_nil
  end

  it 'crashes on unexpected opcodes' do
    instructions = [101]
    expect {
      IntcodeComputer.operate(instructions)
    }.to raise_error IntcodeComputer::UnsupportedOpCode
  end

  it 'can handle opcode 99' do
    instructions = [99]

    expect(IntcodeComputer.operate(instructions)).to eq([99])
  end
end
