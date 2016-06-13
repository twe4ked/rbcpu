RSpec.describe 'fib.asm' do
  it do
    instructions = File.readlines('examples/fib.asm').map(&:strip)
    cpu = CPU.run(instructions)
    expect(cpu.memory).to eq [] +
      [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144] +
      [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil] +
      [11, 144, 89, 0, 144]
    expect(cpu.a).to eq 0
  end
end
