require 'bundler/setup'
require 'transparam'

require 'pry'
require 'active_record'
require 'protected_attributes'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

# require app fixtures
# Dir[File.expand_path "spec/fixtures/app/**/*.rb"].each{|f| require_relative(f)}

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
