# frozen_string_literal: true

require_relative '../command'

module Transparam
  module Commands
    class Generate < Transparam::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        output.puts "OK"
      end
    end
  end
end
