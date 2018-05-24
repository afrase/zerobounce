# frozen_string_literal: true

require 'zerobounce/error'

module Zerobounce
  # Faraday middleware.
  module Middleware
    # Raises an error if the response wasn't successful.
    #
    # @author Aaron Frase
    class RaiseError < Faraday::Response::Middleware
      # Check for errors after the response has finished.
      #
      # @param [Hash] env
      # @raise [Error]
      def on_complete(env)
        if (error = Zerobounce::Error.from_response(env)) # rubocop:disable GuardClause
          raise error
        end
      end
    end
  end
end
