require 'rom/support/registry'
require 'rom/command_registry'

module ROM
  class Finalize
    class FinalizeCommands
      # Build command registry hash for provided relations
      #
      # @param [RelationRegistry] relations registry
      # @param [Hash] gateways
      # @param [Array] command_classes a list of command subclasses
      #
      # @api private
      def initialize(relations, gateways, command_classes)
        @relations = relations
        @gateways = gateways
        @command_classes = command_classes
      end

      # @return [Hash]
      #
      # @api private
      def run!
        registry = @command_classes.each_with_object({}) do |klass, h|
          begin
            rel_name = klass.relation
          rescue NoMethodError => e
            puts("Unable to load commands class #{klass}; #{e}.")
            next
          end

          relation = @relations[rel_name]
          if relation.nil?
            puts("Unable to load commands class #{klass}; no relation found for name '#{rel_name}'.")
            next
          end

          name = klass.register_as || klass.default_name

          gateway = @gateways[relation.class.gateway]
          gateway.extend_command_class(klass, relation.dataset)

          klass.send(:include, relation_methods_mod(relation.class))

          (h[rel_name] ||= {})[name] = klass.build(relation)
        end

        commands = registry.each_with_object({}) do |(name, rel_commands), h|
          h[name] = CommandRegistry.new(rel_commands)
        end

        Registry.new(commands)
      end

      # @api private
      def relation_methods_mod(relation_class)
        mod = Module.new
        relation_class.view_methods.each do |meth|
          mod.module_eval <<-RUBY
          def #{meth}(*args)
            response = relation.public_send(:#{meth}, *args)

            if response.is_a?(relation.class)
              new(response)
            else
              response
            end
          end
          RUBY
        end

        mod
      end
    end
  end
end
