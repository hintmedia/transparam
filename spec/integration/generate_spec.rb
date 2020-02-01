RSpec.describe "`transparam generate` command", type: :cli do
  it "executes `transparam help generate` command successfully" do
    output = `transparam help generate`
    expected_output = <<-OUT
Usage:
  transparam generate

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
