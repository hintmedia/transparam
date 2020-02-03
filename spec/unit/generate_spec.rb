require 'transparam/commands/generate'

RSpec.describe Transparam::Commands::Generate do
  let(:facts) do
    [{ 'klass_name' => 'Foo::Bar::User', 'permitted_params' => ['email', { 'phone_numbers_attributes' => { 'extra_attrs' => ['_destroy'], 'klass_name' => 'PhoneNumber' } }] }]
  end

  before do
    allow(Transparam::FactCollector).to receive(:call).and_return(facts)
  end

  it "executes `generate` command successfully" do
    output = StringIO.new
    options = { project_path: test_app_path }
    command = Transparam::Commands::Generate.new(options)

    command.execute(output: output)

    # expect(output.string).to eq("OK\n")
  end
end
