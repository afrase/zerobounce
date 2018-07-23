# frozen_string_literal: true

module Zerobounce
  class Request
    # Request methods specific to V2 of the API.
    module V2Request
      # Valid v2 query params
      VALID_GET_PARAMS = %i[api_key ip_address email].freeze

      # Validate the email address.
      #
      # @param [Hash] params
      # @option params [String] :email
      # @option params [String] :ip_address
      # @option params [String] :api_key
      # @return [Zerobounce::Response]
      def validate(params)
        Response.new(get('validate', params), self)
      end

      private

      # @param [Hash] params
      # @return [Hash]
      def get_params(params)
        params[:ip_address] ||= '' # ip_address must be in query string
        params[:api_key] = params.delete(:apikey) if params.key?(:apikey) # normalize api_key param
        { api_key: Zerobounce.config.apikey }.merge(params.select { |k, _| VALID_GET_PARAMS.include?(k) })
      end
    end
  end
end
