# frozen_string_literal: true

RSpec.configure do |config|
  config.around(mock_env: true) do |example|
    original_env = ENV.to_h

    begin
      example.run
    ensure
      ENV.clear
      ENV.update(original_env)
    end
  end
end
