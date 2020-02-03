module Transparam
  class FactCollector
    module Helper
      def self.call(project_path:, output_path:)
        Rails.application.eager_load! if const_defined?('Rails')
        project_path = Pathname.new(project_path)

        result = ActiveRecord::Base.descendants.map do |klass|
          model_file = klass.name.split('::').map(&:underscore).join('/') + '.rb'
          model_path = project_path.join('app/models/').join(model_file)

          next unless File.file?(model_path)
          next unless klass.accessible_attributes.any?

          { 'klass_name' => klass.name, 'permitted_params' => permitted_params(klass) }
        end.compact

        # puts result.inspect
        File.write(output_path, result.to_json)
      end

      def self.permitted_params(klass)
        base_attrs(klass).tap do |arry|
          accessible_nested_attrs(klass).each do |attr|
            relation_name = attr.gsub('_attributes', '')
            reflection = klass.reflections[relation_name]
            if reflection.klass.accessible_attributes.blank?
              puts "WARNING: #{klass.name} accepts nested attributes for #{reflection.klass.name} but #{reflection.klass.name} has no accessible_attributes."
              next
            end

            nested_options = klass.nested_attributes_options[relation_name.to_sym]
            extra_attrs = [].tap do |a|
              a.push('id') unless nested_options[:update_only]
              a.push('_destroy') if nested_options[:allow_destroy]
            end

            arry << { attr.to_sym => { 'extra_attrs' => extra_attrs, 'klass_name' => reflection.klass.name } }
          end
        end
      end

      def self.base_attrs(klass)
        klass.accessible_attributes.as_json.reject { |a| a.match(/\_attributes$/) }.map(&:to_sym)
      end

      def self.accessible_nested_attrs(k)
        k.accessible_attributes.select do |attr|
          attr.match(/\_attributes$/) &&
            k.nested_attributes_options.key?(attr.gsub('_attributes', '').to_sym)
        end
      end
    end
  end
end
