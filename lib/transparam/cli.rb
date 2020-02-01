# frozen_string_literal: true

require 'thor'

module Transparam
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'transparam version'
    def version
      require_relative 'version'
      puts "v#{Transparam::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'generate', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def generate(*)
      if options[:help]
        invoke :help, ['generate']
      else
        require_relative 'commands/generate'
        Transparam::Commands::Generate.new(options).execute
      end
    end
  end
end
