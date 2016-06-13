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
      opcode, number = parse_instruction(instruction)

      next if opcode.nil?

      result = operation(opcode, number)

      if result
        run instructions, jump: result
        break
      end
    end
  end

  private

  def number_for(operand)
    _, mode, number = operand.to_s.rpartition(/#/)

    if mode == '#'
      number.to_i
    else
      memory[number.to_i]
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

  def parse_instruction(instruction)
    opcode, operand = instruction.gsub(/;.*/, '').split(' ')

    if opcode && operand.nil?
      raise "no operand supplied for #{instruction.inspect}"
    end

    number = number_for(operand)

    [opcode, number]
  end
end
