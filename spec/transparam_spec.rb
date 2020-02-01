require 'spec_helper'

RSpec.describe Transparam do
  # it "has a version number" do
  #   expect(Transparam::VERSION).not_to be nil
  # end

  class Processor < AST::Processor
    def initialize
      @nested_attribute_options = []
    end

    def process_all(*)
      super
      OpenStruct.new(
        attr_accessible: @attr_accessible,
        nested_attribute_options: @nested_attribute_options
      )
    end

    def handler_missing(node)
      node.children.each { |c| process(c) if c.class == Parser::AST::Node }
    end

    def on_send(node)
      case node.children[1]
      when :attr_accessible
        @attr_accessible = process_attr_accessible(node)
      when :accepts_nested_attributes_for
        @accepts_nested_attributes_for = process_accepts_nested_attributes_for(node)
      end
    end

    private

    def process_attr_accessible(node)
      node.children.select {|n| %i(sym str).include? n.try(:type)}.map { |n| n.to_a.first.to_sym }
    end

    def process_accepts_nested_attributes_for(node)
      default_options = { update_only: false, allow_destroy: false }
      attrs = node.children.select {|n| %i(sym str).include? n.try(:type)}.map { |n| n.to_a.first.to_sym }
      options = eval(Unparser.unparse(node.children.last)) if node.children.last.type == :hash
      @nested_attribute_options << attrs.map { |attr| OpenStruct.new( name: attr, options: default_options.merge(options) ) }
    end
  end

  it '' do
    # file = File.read('spec/fixtures/app/models/user.rb')
    # file_ast = Parser::CurrentRuby.parse(file)
    # processor = Processor.new
    # result = processor.process_all(file_ast)
    # puts result

    puts File.expand_path(File.dirname(__FILE__))
  end
end
