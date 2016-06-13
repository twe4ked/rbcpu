class CPU
  attr_reader :memory, :a

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

      number = number_for(operand)
      result = operation(instructions, opcode, number)
      break if result == :break
    end
  end

  def number_for(operand)
    memory_address = !(operand =~ /^#/)
    operand = operand.gsub(/#/, '').strip.to_i

    number = if memory_address
      memory[operand]
    else
      operand
    end
  end

  def operation(instructions, opcode, number)
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
        :break
      end
    when 'STO'
      memory[number] = @a
    else
      raise "unknown opcode #{opcode.inspect}"
    end
  end
end
