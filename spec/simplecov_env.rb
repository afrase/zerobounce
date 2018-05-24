# frozen_string_literal: true

require 'simplecov'

module SimpleCovEnv
  def self.start!
    configure_profile
    SimpleCov.start
  end

  def self.configure_profile
    formatters = [SimpleCov::Formatter::HTMLFormatter]
    SimpleCov.configure do
      formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
      # Don't run coverage on the spec folder.
      add_filter 'spec'
      # save to CircleCI's artifacts directory if we're on CircleCI
      coverage_dir(File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')) if ENV['CIRCLE_ARTIFACTS']
    end
  end
end
