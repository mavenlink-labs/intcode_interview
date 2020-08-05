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

  xit 'can provide the final diagnostic code for relative logic' do
    memory = [1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1101,0,3,1000,109,988,209,12,9,1000,209,6,209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1102,1,32,1016,1102,326,1,1029,1102,1,26,1009,1102,1,753,1024,1102,1,1,1021,1102,35,1,1000,1102,1,0,1020,1101,25,0,1012,1102,36,1,1011,1101,0,33,1013,1102,1,667,1022,1102,1,38,1014,1102,1,24,1017,1101,0,31,1004,1102,443,1,1026,1101,37,0,1015,1101,27,0,1007,1101,0,748,1025,1102,1,23,1008,1102,1,34,1002,1101,28,0,1006,1102,1,22,1003,1101,0,29,1005,1101,0,39,1018,1101,21,0,1019,1102,30,1,1001,1102,660,1,1023,1102,1,331,1028,1101,0,440,1027,1101,0,20,1010,109,18,1206,2,195,4,187,1105,1,199,1001,64,1,64,1002,64,2,64,109,-12,1208,0,28,63,1005,63,217,4,205,1105,1,221,1001,64,1,64,1002,64,2,64,109,3,2101,0,-5,63,1008,63,31,63,1005,63,247,4,227,1001,64,1,64,1106,0,247,1002,64,2,64,109,-7,2101,0,6,63,1008,63,26,63,1005,63,267,1105,1,273,4,253,1001,64,1,64,1002,64,2,64,109,10,21108,40,40,4,1005,1016,295,4,279,1001,64,1,64,1106,0,295,1002,64,2,64,109,-9,2107,23,0,63,1005,63,315,1001,64,1,64,1105,1,317,4,301,1002,64,2,64,109,30,2106,0,-5,4,323,1105,1,335,1001,64,1,64,1002,64,2,64,109,-19,1202,-9,1,63,1008,63,26,63,1005,63,355,1106,0,361,4,341,1001,64,1,64,1002,64,2,64,109,-5,21107,41,42,6,1005,1015,379,4,367,1105,1,383,1001,64,1,64,1002,64,2,64,109,-6,21108,42,43,8,1005,1011,403,1001,64,1,64,1105,1,405,4,389,1002,64,2,64,109,11,21102,43,1,1,1008,1015,42,63,1005,63,425,1106,0,431,4,411,1001,64,1,64,1002,64,2,64,109,13,2106,0,0,1105,1,449,4,437,1001,64,1,64,1002,64,2,64,109,1,1205,-7,463,4,455,1106,0,467,1001,64,1,64,1002,64,2,64,109,-14,1206,7,479,1105,1,485,4,473,1001,64,1,64,1002,64,2,64,109,-6,1202,0,1,63,1008,63,23,63,1005,63,507,4,491,1106,0,511,1001,64,1,64,1002,64,2,64,109,13,1205,-1,523,1106,0,529,4,517,1001,64,1,64,1002,64,2,64,109,-23,2107,22,10,63,1005,63,551,4,535,1001,64,1,64,1106,0,551,1002,64,2,64,109,14,21101,44,0,6,1008,1018,44,63,1005,63,577,4,557,1001,64,1,64,1106,0,577,1002,64,2,64,109,-12,2108,32,0,63,1005,63,597,1001,64,1,64,1105,1,599,4,583,1002,64,2,64,109,7,1201,-4,0,63,1008,63,20,63,1005,63,619,1106,0,625,4,605,1001,64,1,64,1002,64,2,64,109,-11,1201,6,0,63,1008,63,34,63,1005,63,647,4,631,1106,0,651,1001,64,1,64,1002,64,2,64,109,20,2105,1,7,1001,64,1,64,1106,0,669,4,657,1002,64,2,64,109,-4,21101,45,0,6,1008,1018,46,63,1005,63,689,1106,0,695,4,675,1001,64,1,64,1002,64,2,64,109,-16,2108,22,7,63,1005,63,717,4,701,1001,64,1,64,1105,1,717,1002,64,2,64,109,10,1207,0,27,63,1005,63,733,1105,1,739,4,723,1001,64,1,64,1002,64,2,64,109,8,2105,1,10,4,745,1105,1,757,1001,64,1,64,1002,64,2,64,109,1,21102,46,1,-2,1008,1013,46,63,1005,63,779,4,763,1106,0,783,1001,64,1,64,1002,64,2,64,109,-2,1208,-7,29,63,1005,63,799,1105,1,805,4,789,1001,64,1,64,1002,64,2,64,109,-19,2102,1,10,63,1008,63,32,63,1005,63,829,1001,64,1,64,1106,0,831,4,811,1002,64,2,64,109,14,1207,-2,29,63,1005,63,849,4,837,1105,1,853,1001,64,1,64,1002,64,2,64,109,8,21107,47,46,-6,1005,1010,873,1001,64,1,64,1106,0,875,4,859,1002,64,2,64,109,-17,2102,1,6,63,1008,63,29,63,1005,63,901,4,881,1001,64,1,64,1106,0,901,4,64,99,21102,1,27,1,21102,1,915,0,1106,0,922,21201,1,27817,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21101,0,942,0,1105,1,922,21202,1,1,-1,21201,-2,-3,1,21102,1,957,0,1105,1,922,22201,1,-1,-2,1106,0,968,22102,1,-2,-2,109,-3,2105,1,0]
    subject = Intcode.new(memory, input: [1])
    end_memory = subject.run

    expect(end_memory.select(&:nil?)).to be_empty

    expect(subject.output).to eq [0]
  end
end
