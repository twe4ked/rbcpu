class CPU
  attr_reader :memory, :a

  def self.run(*args)
    new.tap { |cpu| cpu.run(*args) }
  end

  def initialize(memory: [])
    @memory = memory
  end

  def run(instructions, jump: 1)
    instructions[(jump - 1)..-1].each do |instruction|
      opcode, operand = instruction.gsub(/;.*/, '').split(' ')

      next if opcode.nil?
      raise "no operand supplied for #{instruction.inspect}" if operand.nil?

      number = number_for(operand)
      result = operation(opcode, number)

      if result
        run instructions, jump: result
        break
      end
    end
  end

  private

  def number_for(operand)
    memory_address = !(operand =~ /^#/)
    operand = operand.gsub(/#/, '').strip.to_i

    number = if memory_address
      memory[operand]
    else
      operand
    end
  end

  def operation(opcode, number)
    case opcode
    when 'LDA'
      @a = number
    when 'MUL'
      @a = a * number
    when 'SUB'
      @a = a - number
    when 'ADD'
      @a = a + number
    when 'JNZ'
      if a == 0
        # NOP
      else
        return number
      end
    when 'STO'
      memory[number] = a
    else
      raise "unknown opcode #{opcode.inspect}"
    end

    nil
  end
end
