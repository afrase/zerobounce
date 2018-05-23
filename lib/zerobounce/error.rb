# frozen_string_literal: true

require 'json'

module Zerobounce
  # The base Zerobounce error.
  class Error < StandardError
    def initialize(env=nil)
      @env = env
    end

    # Message for the error.
    def message
      @env[:body]
    end

    class << self
      # @param [Hash] env
      # @return [Error]
      def from_response(env)
        case env[:status]
        when 500
          parse_500(env)
        when 200
          parse_200(env)
        end
      end

      private

      def parse_500(env)
        if env[:body].start_with?('Missing parameter')
          MissingParameter.new(env)
        else
          InternalServerError.new(env)
        end
      end

      def parse_200(env)
        # The body hasn't been parsed yet and to avoid potentially parsing the body twice
        # we just use String#start_with?
        ApiError.new(env) if env[:body].start_with?('{"error":"')
      end
    end
  end

  # Server returned a 500 error.
  class InternalServerError < Error
  end

  # A parameter was missing, usually the apiKey.
  class MissingParameter < Error
  end

  # General API error, the response code was 200 but an error still occurred.
  class ApiError < Error
    # @see #message
    def message
      JSON.parse(@env[:body])['error']
    end
  end
end
