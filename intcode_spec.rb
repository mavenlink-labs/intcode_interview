require_relative 'spec_helper'
require_relative 'intcode'

describe Intcode do
  it 'returns immediately if the first code is 99' do
    memory = [99]
    subject = Intcode.new(memory)
    expect(subject.run).to eq memory
  end

  it 'can add numbers' do
    memory = [1, 0, 0, 0, 99]
    subject = Intcode.new(memory)
    expect(subject.run).to eq [2, 0, 0, 0, 99]
  end

  it 'can multiply numbers' do
    memory = [2, 3, 0, 3, 99]
    subject = Intcode.new(memory)
    expect(subject.run).to eq [2, 3, 0, 6, 99]
  end

  it 'can use 99 in math' do
    memory = [2, 4, 4, 5, 99, 0]
    subject = Intcode.new(memory)
    expect(subject.run).to eq [2, 4, 4, 5, 99, 9801]
  end

  it 'can do it all, my man' do
    memory = [1, 1, 1, 4, 99, 5, 6, 0, 99]
    subject = Intcode.new(memory)
    expect(subject.run).to eq [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end

  it 'raises if the memory has an invalid opcode' do
    memory = [78, 0, 0, 0, 99]
    subject = Intcode.new(memory)
    expect { subject.run }.to raise_error(ArgumentError, /unexpected opcode/)
  end

  it 'is calibrated correctly' do
    memory = [1, 12, 2, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 6, 1, 19, 2, 19, 9, 23, 1, 23, 5, 27, 2, 6, 27, 31, 1, 31, 5, 35, 1, 35, 5, 39, 2, 39, 6, 43, 2, 43, 10, 47, 1, 47, 6, 51, 1, 51, 6, 55, 2, 55, 6, 59, 1, 10, 59, 63, 1, 5, 63, 67, 2, 10, 67, 71, 1, 6, 71, 75, 1, 5, 75, 79, 1, 10, 79, 83, 2, 83, 10, 87, 1, 87, 9, 91, 1, 91, 10, 95, 2, 6, 95, 99, 1, 5, 99, 103, 1, 103, 13, 107, 1, 107, 10, 111, 2, 9, 111, 115, 1, 115, 6, 119, 2, 13, 119, 123, 1, 123, 6, 127, 1, 5, 127, 131, 2, 6, 131, 135, 2, 6, 135, 139, 1, 139, 5, 143, 1, 143, 10, 147, 1, 147, 2, 151, 1, 151, 13, 0, 99, 2, 0, 14, 0]
    subject = Intcode.new(memory)
    expect(subject.run.first).to eq 4576384
  end

  it 'supports input and output' do
    memory = [3, 0, 4, 0, 99]
    subject = Intcode.new(memory, input: [25])
    subject.run
    expect(subject.output).to eq [25]
  end

  it 'supports parameter mode immediate' do
    memory = [1002, 4, 3, 4, 33]
    subject = Intcode.new(memory)
    expect(subject.run).to eq [1002, 4, 3, 4, 99]
  end

  it 'supports negative numbers' do
    memory = [1101, 100, -1, 4, 0]
    subject = Intcode.new(memory)
    expect(subject.run).to eq [1101, 100, -1, 4, 99]
  end

  context 'running the diagnostics program' do
    let(:memory) { [3, 225, 1, 225, 6, 6, 1100, 1, 238, 225, 104, 0, 1102, 83, 20, 225, 1102, 55, 83, 224, 1001, 224, -4565, 224, 4, 224, 102, 8, 223, 223, 101, 5, 224, 224, 1, 223, 224, 223, 1101, 52, 15, 225, 1102, 42, 92, 225, 1101, 24, 65, 225, 101, 33, 44, 224, 101, -125, 224, 224, 4, 224, 102, 8, 223, 223, 1001, 224, 7, 224, 1, 223, 224, 223, 1001, 39, 75, 224, 101, -127, 224, 224, 4, 224, 1002, 223, 8, 223, 1001, 224, 3, 224, 1, 223, 224, 223, 2, 14, 48, 224, 101, -1300, 224, 224, 4, 224, 1002, 223, 8, 223, 1001, 224, 2, 224, 1, 223, 224, 223, 1002, 139, 79, 224, 101, -1896, 224, 224, 4, 224, 102, 8, 223, 223, 1001, 224, 2, 224, 1, 223, 224, 223, 1102, 24, 92, 225, 1101, 20, 53, 224, 101, -73, 224, 224, 4, 224, 102, 8, 223, 223, 101, 5, 224, 224, 1, 223, 224, 223, 1101, 70, 33, 225, 1101, 56, 33, 225, 1, 196, 170, 224, 1001, 224, -38, 224, 4, 224, 102, 8, 223, 223, 101, 4, 224, 224, 1, 224, 223, 223, 1101, 50, 5, 225, 102, 91, 166, 224, 1001, 224, -3003, 224, 4, 224, 102, 8, 223, 223, 101, 2, 224, 224, 1, 224, 223, 223, 4, 223, 99, 0, 0, 0, 677, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1105, 0, 99_999, 1105, 227, 247, 1105, 1, 99_999, 1005, 227, 99_999, 1005, 0, 256, 1105, 1, 99_999, 1106, 227, 99_999, 1106, 0, 265, 1105, 1, 99_999, 1006, 0, 99_999, 1006, 227, 274, 1105, 1, 99_999, 1105, 1, 280, 1105, 1, 99_999, 1, 225, 225, 225, 1101, 294, 0, 0, 105, 1, 0, 1105, 1, 99_999, 1106, 0, 300, 1105, 1, 99_999, 1, 225, 225, 225, 1101, 314, 0, 0, 106, 0, 0, 1105, 1, 99_999, 1107, 677, 677, 224, 1002, 223, 2, 223, 1006, 224, 329, 1001, 223, 1, 223, 1107, 226, 677, 224, 102, 2, 223, 223, 1005, 224, 344, 101, 1, 223, 223, 108, 677, 677, 224, 1002, 223, 2, 223, 1006, 224, 359, 101, 1, 223, 223, 107, 677, 677, 224, 1002, 223, 2, 223, 1006, 224, 374, 1001, 223, 1, 223, 1007, 677, 677, 224, 102, 2, 223, 223, 1006, 224, 389, 101, 1, 223, 223, 108, 677, 226, 224, 102, 2, 223, 223, 1006, 224, 404, 101, 1, 223, 223, 1108, 226, 677, 224, 102, 2, 223, 223, 1005, 224, 419, 1001, 223, 1, 223, 7, 677, 226, 224, 102, 2, 223, 223, 1005, 224, 434, 101, 1, 223, 223, 1008, 677, 677, 224, 102, 2, 223, 223, 1006, 224, 449, 1001, 223, 1, 223, 1007, 677, 226, 224, 1002, 223, 2, 223, 1006, 224, 464, 101, 1, 223, 223, 1108, 677, 677, 224, 1002, 223, 2, 223, 1005, 224, 479, 1001, 223, 1, 223, 107, 226, 226, 224, 1002, 223, 2, 223, 1005, 224, 494, 101, 1, 223, 223, 8, 226, 677, 224, 102, 2, 223, 223, 1006, 224, 509, 101, 1, 223, 223, 8, 677, 677, 224, 102, 2, 223, 223, 1006, 224, 524, 101, 1, 223, 223, 1007, 226, 226, 224, 1002, 223, 2, 223, 1006, 224, 539, 1001, 223, 1, 223, 107, 677, 226, 224, 102, 2, 223, 223, 1006, 224, 554, 101, 1, 223, 223, 1107, 677, 226, 224, 1002, 223, 2, 223, 1006, 224, 569, 1001, 223, 1, 223, 1008, 226, 677, 224, 102, 2, 223, 223, 1006, 224, 584, 1001, 223, 1, 223, 1008, 226, 226, 224, 1002, 223, 2, 223, 1005, 224, 599, 1001, 223, 1, 223, 7, 677, 677, 224, 1002, 223, 2, 223, 1005, 224, 614, 1001, 223, 1, 223, 1108, 677, 226, 224, 1002, 223, 2, 223, 1005, 224, 629, 101, 1, 223, 223, 7, 226, 677, 224, 1002, 223, 2, 223, 1005, 224, 644, 1001, 223, 1, 223, 8, 677, 226, 224, 102, 2, 223, 223, 1005, 224, 659, 101, 1, 223, 223, 108, 226, 226, 224, 102, 2, 223, 223, 1005, 224, 674, 101, 1, 223, 223, 4, 223, 99, 226] }

    it 'with input 1, all outputs are zero except final code' do
      subject = Intcode.new(memory, input: [1])
      subject.run
      output = subject.output
      expect(output.slice!(-1)).to eq 12428642
      expect(output.all?(&:zero?)).to eq true
    end

    it 'with input 5, it only outputs a single code' do
      subject = Intcode.new(memory, input: [5])
      subject.run
      expect(subject.output).to eq [918655]
    end
  end

  context 'Using position mode, if input is equal to 8 output 1 (if it is) or 0 (if it is not)' do
    let(:memory) { [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8] }
    it 'is true with input 8' do
      subject = Intcode.new(memory, input: [8])
      subject.run
      expect(subject.output).to eq [1]
    end

    it 'is false with other input' do
      subject = Intcode.new(memory, input: [10])
      subject.run
      expect(subject.output).to eq [0]
    end
  end

  context 'Using position mode, if input is less than 8 output 1 (if it is) or 0 (if it is not)' do
    let(:memory) { [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8] }
    it 'is true with less than 8' do
      subject = Intcode.new(memory, input: [3])
      subject.run
      expect(subject.output).to eq [1]
    end

    it 'is false with other input' do
      subject = Intcode.new(memory, input: [10])
      subject.run
      expect(subject.output).to eq [0]
    end
  end

  context 'Using immediate mode, if input is equal to 8 output 1 (if it is) or 0 (if it is not)' do
    let(:memory) { [3, 3, 1108, -1, 8, 3, 4, 3, 99] }
    it 'is true with input 8' do
      subject = Intcode.new(memory, input: [8])
      subject.run
      expect(subject.output).to eq [1]
    end

    it 'is false with other input' do
      subject = Intcode.new(memory, input: [10])
      subject.run
      expect(subject.output).to eq [0]
    end
  end

  context 'Using immediate mode, if input is less than 8 output 1 (if it is) or 0 (if it is not)' do
    let(:memory) { [3, 3, 1107, -1, 8, 3, 4, 3, 99] }
    it 'is true with less than 8' do
      subject = Intcode.new(memory, input: [3])
      subject.run
      expect(subject.output).to eq [1]
    end

    it 'is false with other input' do
      subject = Intcode.new(memory, input: [10])
      subject.run
      expect(subject.output).to eq [0]
    end
  end

  context 'jump test using position mode' do
    let(:memory) { [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9] }

    it 'outputs 0 if the input was 0' do
      subject = Intcode.new(memory, input: [0])
      subject.run
      expect(subject.output).to eq [0]
    end

    it 'outputs 1 if the input was non-zero' do
      subject = Intcode.new(memory, input: [25])
      subject.run
      expect(subject.output).to eq [1]
    end
  end

  context 'jump test using immediate mode' do
    let(:memory) { [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1] }

    it 'outputs 0 if the input was 0' do
      subject = Intcode.new(memory, input: [0])
      subject.run
      expect(subject.output).to eq [0]
    end

    it 'outputs 1 if the input was non-zero' do
      subject = Intcode.new(memory, input: [25])
      subject.run
      expect(subject.output).to eq [1]
    end
  end

  context 'complex jump and comparison example' do
    let(:memory) { [3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99] }

    it 'outputs 999 if input below 8' do
      subject = Intcode.new(memory, input: [1])
      subject.run
      expect(subject.output).to eq [999]
    end

    it 'outputs 1000 if input equal to 8' do
      subject = Intcode.new(memory, input: [8])
      subject.run
      expect(subject.output).to eq [1000]
    end

    it 'outputs 1001 if input greater than 8' do
      subject = Intcode.new(memory, input: [99])
      subject.run
      expect(subject.output).to eq [1001]
    end
  end

  it 'can output its own memory' do
    memory = [101, -5, 5, 5, 4, 5, 101, 6, 5, 5, 1007, 5, 23, 15, 1105, 1, 0, 99]
    subject = Intcode.new(memory)
    subject.run
    expect(subject.output).to eq memory
  end

  it 'can handle large numbers' do
    memory = [104, 1125899906842624, 99]
    subject = Intcode.new(memory)
    subject.run
    expect(subject.output).to eq [1125899906842624]
  end

  it 'can handle complex multiplication' do
    memory = [1102,34915192,34915192,7,4,7,99,0]
    subject = Intcode.new(memory)
    subject.run
    expect(subject.output).to eq [1219070632396864]
  end
end
