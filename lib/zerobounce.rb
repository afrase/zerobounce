# frozen_string_literal: true

require 'zerobounce/error'
require 'zerobounce/version'
require 'zerobounce/request'
require 'zerobounce/response'
require 'zerobounce/configuration'

# Validate an email address with Zerobounce.net
module Zerobounce
  # @author Aaron Frase
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
    #     config.api_key = 'api-key'
    #   end
    #
    # @yieldparam [Zerobounce::Configuration] config
    def configure
      yield configuration
    end

    # Validate an email address and/or IP address.
    #
    # @param [Hash] params
    # @return [Zerobounce::Response]
    def validate(params)
      Request.new(params).get(params)
    end
  end
end
