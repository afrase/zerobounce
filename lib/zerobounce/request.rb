# frozen_string_literal: true

require 'faraday'
require 'zerobounce/request/v1_request'
require 'zerobounce/request/v2_request'

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
    attr_reader :host
    attr_reader :headers
    attr_reader :middleware
    attr_reader :api_version

    # Set instance variables and extends the correct Zerobounce::Request
    #
    # @param [Hash] params
    # @option params [String] :middleware default: {Configuration#middleware} {include:#middleware}
    # @option params [String] :headers default: {Configuration#headers} {include:#headers}
    # @option params [String] :host default: {Configuration#host} {include:#host}
    # @option params [String] :api_version default: {Configuration#api_version} {include:#api_version}
    def initialize(params={})
      @middleware = params[:middleware] || Zerobounce.config.middleware
      @headers = params[:headers] || Zerobounce.config.headers
      @host = params[:host] || Zerobounce.config.host
      @api_version = params[:api_version] || Zerobounce.config.api_version

      case api_version
      when 'v2'
        extend(V2Request)
      else
        extend(V1Request)
      end
    end

    # Get the number of remaining credits on the account.
    #
    # @param [Hash] params
    # @option params [String] :apikey
    # @return [Integer] A value of -1 can mean the API is invalid.
    def credits(params={})
      get('getcredits', params).body[:Credits]&.to_i
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
      @conn ||= Faraday.new("#{host}/#{api_version}", headers: headers, &middleware)
    end
  end
end
