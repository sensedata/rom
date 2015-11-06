require 'rom/configuration'
require 'rom/environment'
require 'rom/setup'
require 'rom/setup/finalize'

module ROM
  class CreateContainer
    include ROM::Support::Publisher

    attr_reader :container

    def initialize(environment, setup)
      @container = finalize(environment, setup)
    end

    private

    def finalize(environment, setup)
      environment.configure do |config|
        environment.gateways.each_key do |key|
          gateway_config = config.gateways[key]
          gateway_config.infer_relations = true unless gateway_config.key?(:infer_relations)
        end
      end

      finalize = Finalize.new(
        gateways: environment.gateways,
        gateway_map: environment.gateways_map,
        relation_classes: setup.relation_classes,
        command_classes: setup.command_classes,
        mappers: setup.mapper_classes,
        config: environment.config.dup.freeze
      )

      finalize.run!
    end
  end

  class InlineCreateContainer < CreateContainer
    def initialize(*args, &block)
      if args.first.is_a? Configuration
        environment = args.first.environment
        setup = args.first.setup
      elsif args.first.is_a? Environment
        environment = args.first
        setup = args[1]
      else
        configuration = Configuration.new(*args, &block)
        environment = configuration.environment
        setup = configuration.setup
      end

      super(environment, setup)
    end
  end

  def self.create_container(*args, &block)
    InlineCreateContainer.new(*args, &block).container
  end
end
