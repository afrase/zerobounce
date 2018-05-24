# frozen_string_literal: true

require 'faraday'

module Zerobounce
  # Sends the HTTP request.
  #
  # @author Aaron Frase
  #
  # @attr_reader [String] url
  #   The path of the request.
  #
  # @attr_reader [String] host
  #   The host to send the request to.
  #
  # @attr_reader [Hash] headers
  #   The headers used for the request.
  #
  # @attr_reader [Proc] middleware
  #   Faraday middleware used for the request.
  class Request
    # The normal email validation endpoint.
    VALIDATE_PATH = '/v1/validate'
    # The validation endpoint for email and IP validation.
    VALIDATE_WITH_IP_PATH = '/v1/validatewithip'

    attr_reader :url
    attr_reader :host
    attr_reader :headers
    attr_reader :middleware

    # @param [Hash] params
    # @option params [String] :middleware default: {Configuration#middleware} {include:#middleware}
    # @option params [String] :headers default: {Configuration#headers} {include:#headers}
    # @option params [String] :host default: {Configuration#host} {include:#host}
    def initialize(params={})
      @middleware = params[:middleware] || Zerobounce.config.middleware
      @headers = params[:headers] || Zerobounce.config.headers
      @host = params[:host] || Zerobounce.config.host
      @url = params.key?(:ipaddress) || params.key?(:ip_address) ? VALIDATE_WITH_IP_PATH : VALIDATE_PATH
    end

    # Sends a GET request.
    #
    # @param [Hash] params
    # @return [Zerobounce::Response]
    def get(params={})
      Response.new(conn.get(url, get_params(params)), self)
    end

    private

    # @return [Faraday::Connection]
    def conn
      @conn ||= Faraday.new(host, headers: headers, &middleware)
    end

    # @param [Hash] params
    # @return [Hash]
    def get_params(params)
      valid_params = %i[apiKey ipaddress email]
      params[:ipaddress] = params.delete(:ip_address) if params.key?(:ip_address) # normalize ipaddress key
      { apiKey: Zerobounce.config.api_key }.merge(params.select { |k, _| valid_params.include?(k) })
    end
  end
end
