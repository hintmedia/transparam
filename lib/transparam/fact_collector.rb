module Transparam
  class FactCollector
    attr_reader :project_path

    def initialize(project_path:)
      @project_path = project_path
    end

    def call
      write_helper
      perform_fact_collection
      collect_facts
    ensure
      cleanup
    end

    def self.call(*args)
      self.new(*args).call
    end

    private

    def cleanup
      [output_file_path, collector_path].each do |path|
        File.delete(path) if File.exist?(path)
      end
    end

    def collect_facts
      JSON.parse(File.read(output_file_path)).tap do |result|
        puts result if debug?
      end
    end

    def perform_fact_collection
      `RUBYOPT='-W0' bundle exec rails runner '#{collector_path}'`.tap do |result|
        puts result if debug?
      end
    end

    def write_helper
      File.write(collector_path, source)
    end

    def base_helper_path
      File.expand_path('fact_collector/helper.rb', File.dirname(__FILE__))
    end

    def collector_path
      File.expand_path('tmp/transparam-fact-collector.rb', project_path)
    end

    def output_file_path
      File.expand_path('tmp/transparam-app-data.json', project_path)
    end

    def source
      init_command = "Transparam::FactCollector::Helper.call(project_path: '#{project_path.to_s}', output_path: '#{output_file_path.to_s}')"
      File.read(base_helper_path) + "\n\n#{init_command}"
    end

    def debug?
      !ENV['DEBUG'].nil?
    end
  end
end