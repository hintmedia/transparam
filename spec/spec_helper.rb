require 'bundler/setup'
Bundler.require(:default, :test)

require 'active_record'
require 'protected_attributes'

require 'transparam'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

# require app fixtures
Dir[File.expand_path "spec/fixtures/test-app/**/*.rb"].each{|f| require_relative(f)}

module Rspec
  module Helpers
    def test_app_path
      File.expand_path('fixtures/test-app', File.dirname(__FILE__))
    end
  end
end

RSpec.configure do |config|
  config.include Rspec::Helpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
