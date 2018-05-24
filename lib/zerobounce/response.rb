# frozen_string_literal: true

require 'time'

module Zerobounce
  # A Zerobounce response
  #
  # @author Aaron Frase
  #
  # @attr_reader [Zerobounce::Request] request
  #   The request instance.
  #
  # @attr_reader [Faraday::Response] response
  #   The original {https://www.rubydoc.info/gems/faraday/0.15.2/Faraday/Response Faraday::Response}
  class Response
    attr_reader :response
    attr_reader :request

    # @param [Faraday::Response] response
    # @param [Zerobounce::Request] request
    def initialize(response, request)
      @response = response
      @request = request
      @body = response.body
    end

    # Deliverability status
    #
    # Possible values:
    #   :valid
    #   :invalid
    #   :catch_all
    #   :unknown
    #   :spamtrap
    #   :abuse
    #   :do_not_mail
    #
    # @return [Symbol] The status as a +Symbol+.
    def status
      @status ||= underscore(@body[:status])&.to_sym
    end

    # A more detailed status
    #
    # Possible values:
    #   :antispam_system
    #   :greylisted
    #   :mail_server_temporary_error
    #   :forcible_disconnect
    #   :mail_server_did_not_respond
    #   :timeout_exceeded
    #   :failed_smtp_connection
    #   :mailbox_quota_exceeded
    #   :exception_occurred
    #   :possible_traps
    #   :role_based
    #   :global_suppression
    #   :mailbox_not_found
    #   :no_dns_entries
    #   :failed_syntax_check
    #   :possible_typo
    #   :unroutable_ip_address
    #   :leading_period_removed
    #   :does_not_accept_mail
    #   :alias_address
    #
    # @return [Symbol] The sub_status as a +Symbol+.
    def sub_status
      @sub_status ||= underscore(@body[:sub_status])&.to_sym
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

    # The location of the owner of the email when available.
    #
    # @return [String, nil]
    def location
      @location ||= @body[:location]
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

    # If the email domain is disposable, which are usually temporary email addresses.
    #
    # These are temporary emails created for the sole purpose to sign up to websites without giving their real
    # email address. These emails are short lived from 15 minutes to around 6 months.
    #
    # @note If you have valid emails with this flag set to +true+, you shouldn't email them.
    #
    # @return [Boolean]
    def disposable?
      @disposable ||= @body[:disposable] || false
    end

    # These domains are known for abuse, spam, or are bot created.
    #
    # @note If you have a valid email with this flag set to +true+, you shouldn't email them.
    #
    # @return [Boolean]
    def toxic?
      @toxic ||= @body[:toxic] || false
    end

    # The UTC time the email was validated.
    #
    # @return [Time, nil]
    def process_date
      @process_date ||= @body[:processedat] && Time.parse(@body[:processedat])
    end

    # The creation date of the email when available.
    #
    # @return [Time, nil]
    def creation_date
      @creation_date ||= @body[:creationdate] && Time.parse(@body[:creationdate])
    end

    # Returns a string containing a human-readable representation.
    #
    # @note Overriding inspect to hide the {#request}/{#response} instance variables
    #
    # @return [String]
    def inspect
      "#<#{self.class.name}:#{object_id}>"
    end

    # Convert to a hash.
    #
    # @return [Hash]
    def to_h
      public_methods(false).each_with_object({}) do |meth, memo|
        next if %i[request response inspect to_json to_h].include?(meth)
        memo[meth] = send(meth)
      end
    end

    private

    # @param [String, nil] word
    # @return [String, nil]
    def underscore(word)
      return if word.nil? || word.empty?
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2') # for words like HTTPResponse => HTTP_Response
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2') # for words like ResponseCode Response_Code
      word.downcase.tr('-', '_')
    end
  end
end
