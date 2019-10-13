# frozen_string_literal: true

module Zerobounce
  class Response
    # V2 specific methods for the API.
    module V2Response
      # Deliverability status
      #
      # @see https://www.zerobounce.net/docs/email-validation-api-quickstart/#status_codes__v2__
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
        @status ||= @body[:status].to_s.empty? ? nil : @body[:status].tr('-', '_').to_sym
      end

      # @return [Symbol, nil]
      def sub_status
        @sub_status ||= @body[:sub_status].to_s.empty? ? nil : @body[:sub_status].to_sym
      end

      # @return [Integer]
      def domain_age_days
        @domain_age_days ||= @body[:domain_age_days].to_i
      end

      # The SMTP Provider of the email.
      #
      # @return [String, nil]
      def smtp_provider
        @smtp_provider ||= @body[:smtp_provider]
      end

      # @return [String, nil]
      def did_you_mean
        @did_you_mean ||= @body[:did_you_mean]
      end

      # The preferred MX record of the domain.
      #
      # @return [String, nil]
      def mx_record
        @mx_record ||= @body[:mx_record]
      end

      # The UTC time the email was validated.
      #
      # @return [Time, nil]
      def processed_at
        @processed_at ||= @body[:processed_at] && Time.parse("#{@body[:processed_at]} UTC")
      end

      # If the email comes from a free provider.
      #
      # @return [Boolean]
      def free_email?
        @free_email ||= @body[:free_email] || false
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
        @disposable ||= sub_status == :disposable
      end

      # These domains are known for abuse, spam, or are bot created.
      #
      # @note If you have a valid email with this flag set to +true+, you shouldn't email them.
      #
      # @return [Boolean]
      def toxic?
        @toxic ||= sub_status == :toxic
      end

      # Does the domain have an MX record.
      #
      # @return [Boolean]
      def mx_found?
        @mx_found ||= @body[:mx_found] == 'true'
      end
    end
  end
end
