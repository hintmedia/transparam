# frozen_string_literal: true

require_relative '../command'
require 'pathname'

module Transparam
  module Commands
    class Generate < Transparam::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        project_path = Pathname.new(@options[:project_path] || Dir.pwd)
        facts = FactCollector.call(project_path: project_path)
        module_names = ParamModuleGenerator.call(facts: facts, project_path: project_path)
        output << "Generated:\n\n#{module_names.join("\n")}"
      end
    end
  end
end
