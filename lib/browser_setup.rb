require 'capybara'
require 'selenium-webdriver'

module BrowserSetup
  def self.setup

    headless_mode = nil

    until ['y', 'n'].include?(headless_mode)
      puts "Do you want to see the browser window? (y/n)"
      headless_mode = gets.chomp.downcase
      puts "Invalid input. Please enter 'y' for yes or 'n' for no." unless ['y', 'n'].include?(headless_mode)
    end
    
    headless_mode = headless_mode == 'n'

    Capybara.register_driver :selenium do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--window-size=1440,900')
      options.add_argument('--headless') if headless_mode
      options.add_argument('--disable-gpu') if headless_mode

      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara.default_max_wait_time = 5
    Capybara.default_driver = :selenium
    Capybara.run_server = false
  end
end
  