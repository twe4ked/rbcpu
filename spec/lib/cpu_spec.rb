require_relative '../../lib/cpu'

RSpec.describe CPU do
  describe '.run' do
    let(:cpu) { CPU.new }

    describe 'LDA' do
      it 'loads 42 into a A register' do
        cpu.run(['LDA #42 ; comment'])
        expect(cpu.a).to eq 42
      end

      it 'loads into a register from a memory address' do
        cpu = CPU.new memory: [nil, nil, 42, nil]
        cpu.run(['LDA 2'])
        expect(cpu.a).to eq 42
      end
    end

    describe 'MUL' do
      it 'multiplies the number in the A register with the operand' do
        cpu.run([
          'LDA #42',
          'MUL #2',
        ])
        expect(cpu.a).to eq 84
      end
    end

    describe 'SUB' do
      it 'subtracts the number in operand from the A register' do
        cpu.run([
          'LDA #42',
          'SUB #10',
        ])
        expect(cpu.a).to eq 32
      end
    end

    describe 'ADD' do
      it 'adds the number in operand with the A register' do
        cpu.run([
          'LDA #42',
          'ADD #2',
        ])
        expect(cpu.a).to eq 44
      end
    end

    describe 'JNZ' do
      it 'jumps to the operand line if the A register is non-zero' do
        cpu.run <<-EOF.lines.map(&:strip)
          ; comment     line 1
          LDA #42     ; line 2
          JNZ #5      ; line 3
          LDA #1      ; line 4 (skipped)
          LDA #2      ; line 5
        EOF
        expect(cpu.a).to eq 2
      end
    end

    describe 'STO' do
      it 'stores the number in the A register into the operand memory address' do
        cpu.run([
          'LDA #42',
          'STO #4',
        ])
        expect(cpu.memory).to eq [nil, nil, nil, nil, 42]
      end
    end
  end
end
