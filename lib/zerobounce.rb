# frozen_string_literal: true

require 'zerobounce/version'
require 'zerobounce/request'
require 'zerobounce/response'
require 'zerobounce/configuration'

module Zerobounce
  class << self
    attr_writer :configuration

    # Zerobounce configuration
    #
    # @return [Zerobounce::Configuration]
    def configuration
      @configuration ||= Configuration.new
    end
    alias config configuration

    # Configure Zerobounce inside a block.
    #
    # @example
    #   Zerobounce.configure do |config|
    #     config.key = 'api-key'
    #   end
    #
    # @yieldparam [Zerobounce::Configuration] config
    def configure
      yield configuration
    end

    # @param [Hash] params
    # @return [Zerobounce::Response]
    def validate(params)
      Request.new(params).get(params)
    end
  end
end
