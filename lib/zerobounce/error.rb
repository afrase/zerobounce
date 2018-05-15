# frozen_string_literal: true

require 'json'

module Zerobounce
  class Error < StandardError
    def initialize(env=nil)
      @env = env
    end

    def message
      @env[:body]
    end

    class << self
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

  class InternalServerError < Error
  end

  class MissingParameter < Error
  end

  class ApiError < Error
    def message
      JSON.parse(@env[:body])['error']
    end
  end
end
