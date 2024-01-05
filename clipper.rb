require 'dotenv/load'
require_relative 'lib/browser_setup'
require_relative 'lib/utils'
require_relative 'lib/automation_process'

include BrowserSetup
include Utils
include AutomationProcess

begin
  BrowserSetup.setup
  AutomationProcess.run
rescue StandardError => e
  puts "An error occurred: #{e.message}"
ensure
  Capybara.current_session.driver.quit
end
