require 'capybara/dsl'
require_relative 'utils'

module AutomationProcess
  include Capybara::DSL

  def self.run
    visit("https://www.hannaford.com/coupons")

    if page.has_link?('sign in')
      click_link('sign in')
      fill_in('userNameLogin', with: ENV['HANNAFORD_EMAIL'])
      fill_in('passwordLogin', with: ENV['HANNAFORD_PASSWORD'])
      find('div#loginCred button.btn-primary').click
      Utils.random_sleep(3, 7)
    end
  
    if page.has_button?('Ok, got it!')
      click_button('Ok, got it!')
      Utils.random_sleep(2, 5)
    end
  
    if page.has_css?('#fsrFocusFirst')
      find('#fsrFocusFirst').click
      Utils.random_sleep(1, 3)
    end
  
    def Utils.scroll_to_bottom
      execute_script("window.scrollTo(0, document.body.scrollHeight);")
      Utils.random_sleep(1, 3)
    end
  
    clipped_coupons = 0
    while true
      current_coupon_count = all('.clipTarget').count
      Utils.scroll_to_bottom
      Utils.random_sleep(1, 3)
      new_coupon_count = all('.clipTarget').count
  
      break if current_coupon_count == new_coupon_count
    end
  
    all('.clipTarget').each do |coupon|
      Capybara.using_wait_time(10) do
        coupon.click rescue Selenium::WebDriver::Error::ElementClickInterceptedException
      end
      Utils.random_sleep(0.5, 2)
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
end
