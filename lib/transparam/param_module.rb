module Transparam
  class ParamModule
    attr_reader :fact, :project_path, :permitted_attrs_method_name

    def initialize(fact:, project_path:)
      @fact = fact
      @project_path = project_path
      @permitted_attrs_method_name = :permitted_attrs
    end

    def source_code
      Rufo.format(Unparser.unparse(source_code_ast), trailing_commas: false)
    end

    def module_path
      project_path.join('app/controllers/concerns/strong_parameters/').join(model_file)
    end

    private

    def source_code_ast
      m = module_name.split("::").reverse.inject(nil) do |children, el|
        node = s(:module, s(:const, nil, el.to_sym))
        if !children.nil?
          node.append(children)
        else
          node.append(
            s(:begin,
              params_method_ast,
              permitted_attrs_method_ast
            )
          )
        end
      end
    end

    def params_method_ast
      s(:def,
        "#{underscore(klass_name.split('::').last)}_params".to_sym,
          s(:args),
          s(:send,
            s(:send,
              s(:send, nil, :params),
              :require,
              s(:sym, resource_name)
            ),
            :moderate,
            s(:send, nil, :controller_name),
            s(:send, nil, :action_name),
            s(:splat, s(:send, nil, "#{module_name}.#{permitted_attrs_method_name}"))
          )
        )
    end

    def permitted_attrs_method_ast
      s(:def,
        "self.#{permitted_attrs_method_name}",
          s(:args),
          s(:send, nil, "[\n#{permitted_attrs_str}\n]")
        )
    end

    def permitted_attrs_str
      permitted_params.map do |param, str|
        case param.class.name
        when 'String'
          ":#{param}"
        when 'Hash'
          values = param.values.first['extra_attrs'].map { |attr| ":#{attr}" }.tap do |arry|
            arry << "*#{module_name(param.values.first['klass_name'])}.#{permitted_attrs_method_name}"
          end
          "{ :#{param.keys.first} => [#{values.join(', ')}] }"
        end
      end.join(",\n")
    end

    def klass_name
      fact['klass_name']
    end

    def permitted_params
      fact['permitted_params']
    end

    def model_file
      klass_name.split("::").map {|c| underscore(c) }.join('/') + '.rb'
    end

    def model_path
      project_path.join('app/models/').join(model_file)
    end

    def module_name(name = klass_name)
      "Concerns::StrongParameters::#{name}"
    end

    def resource_name
      underscore(klass_name.split('::').last).to_sym
    end

    def s(type, *children)
      Parser::AST::Node.new(type, children)
    end

    def underscore(string)
      string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
