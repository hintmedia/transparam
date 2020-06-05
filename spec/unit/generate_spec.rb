require 'transparam/commands/generate'

RSpec.describe Transparam::Commands::Generate do
  it "executes `generate` command successfully", with_sample_facts: true do
    output = StringIO.new
    options = { project_path: test_app_path }
    command = Transparam::Commands::Generate.new(options)

    expect { command.execute(output: output) }.to change {
      File.exists?("#{test_app_path}/app/controllers/concerns/strong_parameters/foo/bar/user.rb")
    }.to(true)

    expect(output.string).to eq(<<~OUTPUT.strip)
      Generated:

      Concerns::StrongParameters::Foo::Bar::User
    OUTPUT
  end
end
