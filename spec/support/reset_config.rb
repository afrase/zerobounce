# frozen_string_literal: true

RSpec.configure do |config|
  config.after do
    Zerobounce.instance_variable_set(:@configuration, Zerobounce::Configuration.new)
  end
end
