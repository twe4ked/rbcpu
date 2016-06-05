class CPU
  attr_reader :instructions, :memory, :a

  def self.run(*args)
    new.tap { |cpu| cpu.run(*args) }
  end

  def initialize(memory: [])
    @a = 0
    @memory = memory
  end

  def run(instructions, jump: 1)
    instructions[(jump - 1)..-1].each do |instruction|
      instruction.gsub! /;.*/, ''

      opcode, operand = instruction.split(' ')

      next if [opcode, operand].compact.count != 2

      memory_address = !(operand =~ /^#/)
      operand = operand.gsub(/#/, '').strip.to_i

      number = if memory_address
        memory[operand]
      else
        operand
      end

      case opcode
      when 'LDA'
        @a = number
      when 'MUL'
        @a = @a * number
      when 'SUB'
        @a = @a - number
      when 'ADD'
        @a = @a + number
      when 'JNZ'
        if @a == 0
          # NOP
        else
          run instructions, jump: number
          break
        end
      when 'JZ'
        if @a == 0
          run instructions, jump: number
          break
        else
          # NOP
        end
      when 'STO'
        memory[number] = @a
      else
        raise "unknown instruction #{instruction.inspect}"
      end
    end
  end
end
