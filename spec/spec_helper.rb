require 'bundler/setup'
Bundler.require(:default, :test)

require 'active_record'
require 'protected_attributes'

require 'simplecov'
SimpleCov.start do
  add_filter 'lib/transparam/command.rb'
end

require 'transparam'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

# require app fixtures
Dir[File.expand_path "spec/fixtures/test-app/**/*.rb"].each{|f| require_relative(f)}

RSpec.shared_context "global context" do
  let(:test_app_path) { File.expand_path('fixtures/test-app', File.dirname(__FILE__)) }
  let(:sample_facts_path) { "#{test_app_path}/tmp/transparam-app-data.json" }

  let(:sample_facts) do
    [{ 'klass_name' => 'Foo::Bar::User', 'permitted_params' => ['email', { 'phone_numbers_attributes' => { 'extra_attrs' => ['_destroy'], 'klass_name' => 'PhoneNumber' } }] }]
  end

  let(:sample_param_module) do
    <<~CODE
      module Concerns
        module StrongParameters
          module Foo
            module Bar
              module User
                def user_params
                  params.require(:user).moderate(controller_name, action_name, *Concerns::StrongParameters::Foo::Bar::User.permitted_attrs)
                end

                def self.permitted_attrs
                  [
                    :email,
                    { :phone_numbers_attributes => [:_destroy, *Concerns::StrongParameters::PhoneNumber.permitted_attrs] }
                  ]
                end
              end
            end
          end
        end
      end
    CODE
  end
end

RSpec.configure do |config|
  config.include_context "global context"

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:example, with_sample_facts: true) do
    allow_any_instance_of(Transparam::FactCollector).to receive(:`)
    File.write(sample_facts_path, sample_facts.to_json)
  end

  config.after(:example) do
    # Ensure sample_facts_path is cleaned up between examples
    File.delete(sample_facts_path) if File.exists?(sample_facts_path)

    # Ensure controllers dir is cleaned up between examples
    controllers_dir = "#{test_app_path}/app/controllers"
    FileUtils.remove_dir(controllers_dir) if File.exists?(controllers_dir)
  end
end
