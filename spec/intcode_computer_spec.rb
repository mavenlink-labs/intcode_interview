require 'spec_helper'
require 'intcode_computer'

describe IntcodeComputer do
  it 'can be initialized' do
    subject = IntcodeComputer.new
    expect(subject).to_not be_nil
  end
end
