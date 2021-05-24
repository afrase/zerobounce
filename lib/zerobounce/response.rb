# frozen_string_literal: true

require 'time'
require 'zerobounce/response/v1_response'
require 'zerobounce/response/v2_response'

module Zerobounce
  # A Zerobounce response
  #
  # @author Aaron Frase
  #
  # @attr_reader [Zerobounce::Request] request
  #   The request instance.
  #
  # @attr_reader [Faraday::Response] response
  #   The original {https://www.rubydoc.info/gems/faraday/1.4.2/Faraday/Response Faraday::Response}
  class Response
    attr_reader :response
    attr_reader :request

    # @param [Faraday::Response] response
    # @param [Zerobounce::Request::V2Response, Zerobounce::Request::V1Response] request
    def initialize(response, request)
      @response = response
      @request = request
      @body = response.body

      case request.api_version
      when 'v2'
        extend(V2Response)
      else
        extend(V1Response)
      end
    end

    # The email address you are validating.
    #
    # @return [String]
    def address
      @address ||= @body[:address]
    end

    # The portion of the email address before the "@" symbol.
    #
    # @return [String]
    def account
      @account ||= @body[:account]
    end

    # The portion of the email address after the "@" symbol.
    #
    # @return [String]
    def domain
      @domain ||= @body[:domain]
    end

    # The first name of the owner of the email when available.
    #
    # @return [String, nil]
    def firstname
      @firstname ||= @body[:firstname]
    end

    # The last name of the owner of the email when available.
    #
    # @return [String, nil]
    def lastname
      @lastname ||= @body[:lastname]
    end

    # The gender of the owner of the email when available.
    #
    # @return [String, nil]
    def gender
      @gender ||= @body[:gender]
    end

    # The country of the IP passed in.
    #
    # @return [String, nil]
    def country
      @country ||= @body[:country]
    end

    # The region/state of the IP passed in.
    #
    # @return [String, nil]
    def region
      @region ||= @body[:region]
    end

    # The city of the IP passed in.
    #
    # @return [String, nil]
    def city
      @city ||= @body[:city]
    end

    # The zipcode of the IP passed in.
    #
    # @return [String, nil]
    def zipcode
      @zipcode ||= @body[:zipcode]
    end

    # Is this email considered valid?
    #
    # @note Uses the values from {Zerobounce::Configuration#valid_statuses}
    #
    # @return [Boolean]
    def valid?
      @valid ||= Zerobounce.config.valid_statuses.include?(status)
    end

    # The opposite of {#valid?}
    #
    # @return [Boolean]
    def invalid?
      !valid?
    end

    # Returns a string containing a human-readable representation.
    #
    # @note Overriding inspect to hide the {#request}/{#response} instance variables
    #
    # @return [String]
    def inspect
      "#<#{self.class.name}:0x#{object_id.to_s(16)} @address=#{address}>"
    end

    # Convert to a hash.
    #
    # @return [Hash]
    def to_h
      public_methods(false).each_with_object({}) do |meth, memo|
        next if %i[request response inspect to_h].include?(meth)

        memo[meth] = send(meth)
      end
    end
  end
end
