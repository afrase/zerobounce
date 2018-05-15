# frozen_string_literal: true

require 'zerobounce/error'

module Zerobounce
  module Middleware
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        if (error = Zerobounce::Error.from_response(env)) # rubocop:disable GuardClause
          raise error
        end
      end
    end
  end
end
