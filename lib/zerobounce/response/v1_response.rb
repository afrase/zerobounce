# frozen_string_literal: true

module Zerobounce
  class Response
    # V1 specific methods for the API.
    module V1Response
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
        @status ||= @body[:status].to_s.empty? ? nil : underscore(@body[:status]).to_sym
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
      #   :unknown
      #
      # @return [Symbol] The sub_status as a +Symbol+.
      def sub_status
        @sub_status ||= @body[:sub_status].to_s.empty? ? nil : underscore(@body[:sub_status]).to_sym
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

      # The location of the owner of the email when available.
      #
      # @return [String, nil]
      def location
        @location ||= @body[:location]
      end

      # The UTC time the email was validated.
      #
      # @return [Time, nil]
      def processed_at
        @processed_at ||= @body[:processedat] && Time.parse("#{@body[:processedat]} UTC")
      end

      # The creation date of the email when available.
      #
      # @return [Time, nil]
      def creation_date
        @creation_date ||= @body[:creationdate] && Time.parse("#{@body[:creationdate]} UTC")
      end

      private

      # @param [String] word
      # @return [String]
      def underscore(word)
        word.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.tr('-', '_')
      end
    end
  end
end
