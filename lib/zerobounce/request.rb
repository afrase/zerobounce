# frozen_string_literal: true

require 'faraday'

module Zerobounce
  class Request
    attr_reader :url
    attr_reader :server
    attr_reader :headers
    attr_reader :middleware

    # @param [Hash] params
    def initialize(params)
      @middleware = params[:middleware] || Zerobounce.config.middleware
      @headers = params[:headers] || Zerobounce.config.headers
      @server = params[:server] || Zerobounce.config.host
      @url = params.key?(:ipaddress) ? '/v1/validatewithip' : '/v1/validate'
    end

    # @param [Hash] params
    # @return [Zerobounce::Response]
    def get(params={})
      Response.new(adapter.get(url, get_params(params)), self)
    end

    private

    # @return [Faraday::Connection]
    def adapter
      @adapter ||= Faraday.new(server, headers: headers, &middleware)
    end

    # @param [Hash] params
    def get_params(params)
      valid_params = %i[apiKey ipaddress email]
      { apiKey: Zerobounce.config.key }.merge(params.select { |k, _| valid_params.include?(k) })
    end
  end
end
