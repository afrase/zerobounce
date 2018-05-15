# frozen_string_literal: true

require 'time'

module Zerobounce
  class Response
    attr_reader :response
    attr_reader :request

    def initialize(response, request)
      @response = response
      @request = request
      @body = response.body
    end

    # valid | invalid | catch_all | unknown | spamtrap | abuse | do_not_mail
    #
    # @return [Symbol]
    def status
      @status ||= underscore(@body[:status])&.to_sym
    end

    # antispam_system | greylisted | mail_server_temporary_error | forcible_disconnect | mail_server_did_not_respond |
    # timeout_exceeded | failed_smtp_connection | mailbox_quota_exceeded | exception_occurred | possible_traps |
    # role_based | global_suppression | mailbox_not_found | no_dns_entries | failed_syntax_check | possible_typo |
    # unroutable_ip_address | leading_period_removed | does_not_accept_mail | alias_address
    #
    # @return [Symbol]
    def sub_status
      @sub_status ||= @body[:sub_status]&.to_sym
    end

    # The email address you are validating.
    # @return [String]
    def address
      @address ||= @body[:address]
    end

    # The portion of the email address before the "@" symbol.
    def account
      @account ||= @body[:account]
    end

    # The portion of the email address after the "@" symbol.
    def domain
      @domain ||= @body[:domain]
    end

    # The first name of the owner of the email when available or nil.
    def firstname
      @firstname ||= @body[:firstname]
    end

    # The last name of the owner of the email when available or nil.
    def lastname
      @lastname ||= @body[:lastname]
    end

    # The gender of the owner of the email when available or nil.
    def gender
      @gender ||= @body[:gender]
    end

    # The location of the owner of the email when available or nil.
    def location
      @location ||= @body[:location]
    end

    # The country of the IP passed in.
    def country
      @country ||= @body[:country]
    end

    # The region/state of the IP passed in.
    def region
      @region ||= @body[:region]
    end

    # The city of the IP passed in.
    def city
      @city ||= @body[:city]
    end

    # The zipcode of the IP passed in.
    def zipcode
      @zipcode ||= @body[:zipcode]
    end

    # @return [Boolean]
    def valid?
      @valid ||= Zerobounce.config.valid_statuses.include?(status)
    end

    # @return [Boolean]
    def invalid?
      !valid?
    end

    # If the email domain is disposable, which are usually temporary email addresses.
    #
    # @return [Boolean]
    def disposable?
      @disposable ||= @body[:disposable] || false
    end

    # These domains are known for abuse, spam, and bot created.
    #
    # @return [Boolean]
    def toxic?
      @toxic ||= @body[:toxic] || false
    end

    # The UTC time the email was validated.
    # @return [Time, nil]
    def process_date
      @process_date ||= @body[:processedat] && Time.parse(@body[:processedat])
    end

    # The creation date of the email when available or nil.
    # @return [Time, nil]
    def creation_date
      @creation_date ||= @body[:creationdate] && Time.parse(@body[:creationdate])
    end

    def inspect
      # Overriding inspect to hide the @request/@response instance variables
      "#<#{self.class.name}:#{object_id}>"
    end

    # @return [String]
    def to_json
      JSON.dump(@body)
    end

    private

    # @param [String, nil] word
    # @return [String, nil]
    def underscore(word)
      return if word.nil?
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase
    end
  end
end
