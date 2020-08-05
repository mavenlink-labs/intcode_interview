require 'rspec'
require_relative 'intcode'

describe Intcode do
  it 'can be initialized' do
    subject = Intcode.new
    expect(subject).to_not be_nil
  end
end
