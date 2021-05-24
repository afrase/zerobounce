# frozen_string_literal: true

require 'json'

module Zerobounce
  # The base Zerobounce error.
  #
  # @author Aaron Frase
  class Error < StandardError
    attr_reader :env

    def initialize(env={})
      @env = env
      super(env[:body])
    end

    class << self
      # Parse the response for errors.
      #
      # @param [Hash] env
      # @return [Error, nil]
      def from_response(env)
        case env[:status]
        when 500
          parse500(env)
        when 200
          parse200(env)
        else
          UnknownError.new(env)
        end
      end

      private

      # @param [Hash] env
      # @return [Error]
      def parse500(env)
        if env[:body].to_s.start_with?('Missing parameter')
          MissingParameter.new(env)
        else
          InternalServerError.new(env)
        end
      end

      # @param [Hash] env
      # @return [Error, nil]
      def parse200(env)
        # The body hasn't been parsed yet and to avoid potentially parsing the body twice
        # we just use String#start_with?
        ApiError.new(env) if env[:body].to_s.start_with?('{"error":')
      end
    end
  end

  # Server returned a 500 error.
  #
  # @author Aaron Frase
  class InternalServerError < Error
  end

  # A parameter was missing, usually the apikey.
  #
  # @author Aaron Frase
  class MissingParameter < Error
  end

  # When the status code isn't in the defined codes to parse.
  #
  # @author Aaron Frase
  class UnknownError < Error
  end

  # General API error, the response code was 200 but an error still occurred.
  #
  # @author Aaron Frase
  class ApiError < Error
    # @see #message
    def message
      JSON.parse(@env[:body])['error']
    end
  end
end
