require "capybara/cuprite"

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite_custom) do |app|
  headless = ENV["HEADLESS"].blank? || ENV["HEADLESS"]&.downcase == "true"
  Capybara::Cuprite::Driver.new(
    app, browser_options: { "no-sandbox": nil }, process_timeout: 20, window_size: [ 1400, 900 ],
    inspector: ENV["INSPECTOR"], headless:
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :cuprite_custom
  end
end
