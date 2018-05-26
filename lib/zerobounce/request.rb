# frozen_string_literal: true

require 'faraday'

module Zerobounce
  # Sends the HTTP request.
  #
  # @author Aaron Frase
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
    # The path to get number number of credits remaining on the account.
    GET_CREDITS_PATH = '/v1/getcredits'

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
    end

    # Validate the email address.
    #
    # @param [Hash] params
    # @option params [String] :email
    # @option params [String] :apikey
    # @return [Zerobounce::Response]
    def validate(params)
      Response.new(get(VALIDATE_PATH, params), self)
    end

    # Validate the email address and get geoip info for the IP.
    #
    # @param [Hash] params
    # @option params [String] :email
    # @option params [String] :ip_address
    # @option params [String] :apikey
    # @return [Zerobounce::Response]
    def validate_with_ip(params)
      Response.new(get(VALIDATE_WITH_IP_PATH, params), self)
    end

    # Get the number of remaining credits on the account.
    #
    # @param [Hash] params
    # @option params [String] :apikey
    # @return [Integer] A value of -1 can mean the API is invalid.
    def credits(params={})
      get(GET_CREDITS_PATH, params).body[:Credits]&.to_i
    end

    private

    # Sends a GET request.
    #
    # @param [Hash] params
    # @param [String] path
    # @return [Zerobounce::Response]
    def get(path, params)
      conn.get(path, get_params(params))
    end

    # @return [Faraday::Connection]
    def conn
      @conn ||= Faraday.new(host, headers: headers, &middleware)
    end

    # @param [Hash] params
    # @return [Hash]
    def get_params(params)
      valid_params = %i[apikey ipaddress email]
      params[:ipaddress] = params.delete(:ip_address) if params.key?(:ip_address) # normalize ipaddress key
      { apikey: Zerobounce.config.apikey }.merge(params.select { |k, _| valid_params.include?(k) })
    end
  end
end
