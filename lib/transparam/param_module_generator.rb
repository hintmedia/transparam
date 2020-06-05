module Transparam
  class ParamModuleGenerator
    attr_reader :facts, :project_path

    def initialize(facts, project_path)
      @facts = facts
      @project_path = project_path
    end

    def call
      facts.map do |fact|
        param_module = ParamModule.new(fact: fact, project_path: project_path)
        FileUtils.mkdir_p(File.dirname(param_module.module_path))
        File.write(param_module.module_path, param_module.source_code)
        param_module.module_name
      end
    end

    def self.call(facts:, project_path:)
      self.new(facts, project_path).call()
    end
  end
end
