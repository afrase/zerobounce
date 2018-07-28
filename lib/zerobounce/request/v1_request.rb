# frozen_string_literal: true

module Zerobounce
  class Request
    # Request methods specific to V1 of the API.
    module V1Request
      # Valid v1 get query params
      VALID_GET_PARAMS = %i[apikey ipaddress email].freeze

      # Validate the email address.
      #
      # @param [Hash] params
      # @option params [String] :email
      # @option params [String] :ip_address
      # @option params [String] :apikey
      # @return [Zerobounce::Response]
      def validate(params)
        if params.key?(:ipaddress) || params.key?(:ip_address)
          validate_with_ip(params)
        else
          Response.new(get('validate', params), self)
        end
      end

      # Validate the email address and get geoip info for the IP.
      #
      # @param [Hash] params
      # @option params [String] :email
      # @option params [String] :ip_address
      # @option params [String] :apikey
      # @return [Zerobounce::Response]
      def validate_with_ip(params)
        Response.new(get('validatewithip', params), self)
      end

      private

      # @param [Hash] params
      # @return [Hash]
      def get_params(params)
        params[:ipaddress] = params.delete(:ip_address) if params.key?(:ip_address) # normalize ipaddress key
        params[:apikey] = params.delete(:api_key) if params.key?(:api_key) # normalize apikey param
        { apikey: Zerobounce.config.apikey }.merge(params.select { |k, _| VALID_GET_PARAMS.include?(k) })
      end
    end
  end
end
