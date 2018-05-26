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

    # Validates the email address and gets geoip information for an IP if provided.
    #
    # @param [Hash] params
    # @option params [String] :email
    # @option params [String] :ip_address An IP address. :ipaddress also works.
    # @option params [String] :apikey
    # @option params [String] :host
    # @option params [String] :headers
    # @option params [Proc] :middleware
    # @return [Zerobounce::Response]
    def validate(params)
      if params.key?(:ipaddress) || params.key?(:ip_address)
        Request.new(params).validate_with_ip(params)
      else
        Request.new(params).validate(params)
      end
    end

    # Get the number of remaining credits on the account.
    #
    # @param [Hash] params
    # @option params [String] :apikey
    # @option params [String] :host
    # @option params [String] :headers
    # @option params [Proc] :middleware
    # @return [Integer]
    def credits(params={})
      Request.new(params).credits(params)
    end

    # Convenience method for checking if an email address is valid.
    #
    # @param [String] email
    # @return [Boolean]
    def valid?(email)
      validate(email: email).valid?
    end
  end
end
