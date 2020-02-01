require 'transparam/commands/generate'

RSpec.describe Transparam::Commands::Generate do
  it "executes `generate` command successfully" do
    output = StringIO.new
    options = {}
    command = Transparam::Commands::Generate.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
