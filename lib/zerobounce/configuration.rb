# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'zerobounce/middleware/raise_error'

module Zerobounce
  # Configuration object for Zerobounce.
  #
  # @author Aaron Frase
  #
  # @attr [String] host
  #   The Zerobounce API host.
  #
  # @attr [Hash] headers
  #   Headers to use in all requests.
  #
  # @attr [String] api_key
  #   A Zerobounce API key.
  #
  # @attr [Proc] middleware
  #   The middleware used by Faraday for each request.
  #
  #   @note If you modify the default make sure to add middleware to parse
  #     the response as json and symbolize the keys.
  #
  # @attr [Array<Symbol>] valid_statues
  #   The statuses that are considered valid by {Response#valid?}.
  class Configuration
    attr_accessor :host
    attr_accessor :headers
    attr_accessor :api_key
    attr_accessor :middleware
    attr_accessor :valid_statuses

    def initialize
      self.host = 'https://api.zerobounce.net'
      self.api_key = ENV['ZEROBOUNCE_API_KEY']
      self.valid_statuses = %i[valid catch_all]
      self.headers = { user_agent: "ZerobounceRubyGem/#{Zerobounce::VERSION}" }

      self.middleware = proc do |builder|
        builder.response(:json, content_type: /\bjson$/, parser_options: { symbolize_names: true })
        builder.use(Zerobounce::Middleware::RaiseError)
        builder.adapter(Faraday.default_adapter)
      end
    end
  end
end
