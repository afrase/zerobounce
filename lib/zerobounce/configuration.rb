# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'zerobounce/middleware/raise_error'

module Zerobounce
  class Configuration
    attr_accessor :key
    attr_accessor :host
    attr_accessor :headers
    attr_accessor :middleware
    attr_accessor :valid_statuses

    def initialize
      self.host = 'https://api.zerobounce.net'
      self.valid_statuses = %i[valid catch_all]
      self.headers = { user_agent: "ZerobounceRubyGem/#{Zerobounce::VERSION}" }

      self.middleware = proc do |builder|
        builder.response(:json, content_type: /\bjson$/, parser_options: { symbolize_names: true })
        builder.use(Zerobounce::Middleware::RaiseError)
        builder.adapter(Faraday.default_adapter)
      end
    end
  end
end
