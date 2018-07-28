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
    #     config.apikey = 'api-key'
    #   end
    #
    # @yieldparam [Zerobounce::Configuration] config
    def configure
      yield configuration
    end

    # Validates the email address and gets geoip information for an IP if provided.
    #
    # @param [Hash] params
    # @option params [String] :email The email address to validate.
    # @option params [String] :ip_address An IP address, :ipaddress also works.
    # @option params [String] :apikey Use a different API key for this request.
    # @option params [String] :host Use a different host for this request.
    # @option params [String] :headers Use different headers for this request.
    # @option params [Proc] :middleware Use different middleware for this request.
    # @return [Zerobounce::Response]
    def validate(params)
      Request.new(params).validate(params)
    end

    # Get the number of remaining credits on the account.
    #
    # @param [Hash] params
    # @option params [String] :apikey Use a different API key for this request.
    # @option params [String] :host Use a different host for this request.
    # @option params [String] :headers Use different headers for this request.
    # @option params [Proc] :middleware Use different middleware for this request.
    # @return [Integer]
    def credits(params={})
      Request.new(params).credits(params)
    end

    # Convenience method for checking if an email address is valid.
    #
    # @param [String] email
    # @param [Hash] params
    # @return [Boolean]
    def valid?(email, params={})
      validate(params.merge(email: email)).valid?
    end

    # Convenience method for checking if an email address is invalid.
    #
    # @param [String] email
    # @param [Hash] params
    # @return [Boolean]
    def invalid?(email, params={})
      validate(params.merge(email: email)).invalid?
    end
  end
end
