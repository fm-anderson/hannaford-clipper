require 'securerandom'

module Utils
  def self.random_sleep(min, max)
    sleep(SecureRandom.random_number(min..max))
  end

  def self.scroll_to_bottom
    Capybara.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    random_sleep(1, 3)
  end
end
