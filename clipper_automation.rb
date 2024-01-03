require 'dotenv/load'
require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'securerandom'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.default_driver = :selenium
Capybara.run_server = false
include Capybara::DSL

def random_sleep(min, max)
  sleep(SecureRandom.random_number(min..max))
end

begin
  visit("https://www.hannaford.com/coupons")

  if page.has_link?('sign in')
    click_link('sign in')
    fill_in('userNameLogin', with: ENV['HANNAFORD_EMAIL'])
    fill_in('passwordLogin', with: ENV['HANNAFORD_PASSWORD'])
    find('div#loginCred button.btn-primary').click
    random_sleep(3, 7)
  end

  if page.has_button?('Ok, got it!')
    click_button('Ok, got it!')
    random_sleep(2, 5)
  end

  if page.has_css?('#fsrFocusFirst')
    find('#fsrFocusFirst').click
    random_sleep(1, 3)
  end

  def scroll_to_bottom
    execute_script("window.scrollTo(0, document.body.scrollHeight);")
    random_sleep(1, 3)
  end

  clipped_coupons = 0
  while true
    current_coupon_count = all('.clipTarget').count
    scroll_to_bottom
    random_sleep(1, 3)
    new_coupon_count = all('.clipTarget').count

    break if current_coupon_count == new_coupon_count
  end

  all('.clipTarget').each do |coupon|
    Capybara.using_wait_time(10) do
      coupon.click rescue Selenium::WebDriver::Error::ElementClickInterceptedException
    end
    random_sleep(0.5, 2)
    clipped_coupons += 1
  end

  if clipped_coupons.zero?
    puts "No coupons available to clip."
  elsif clipped_coupons == 1
    puts "Successfully clipped 1 coupon!"
  else
    puts "Successfully clipped #{clipped_coupons} coupons!"
  end

rescue StandardError => e
  puts "An error occurred: #{e.message}"
ensure
  Capybara.current_session.driver.quit
end
