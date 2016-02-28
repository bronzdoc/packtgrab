#!/usr/bin/ruby

require "bundler/inline"

LOG_FILE = "grab_packt.log"

gemfile true do
  source "https://rubygems.org"
  gem "json"
  gem "mechanize", "~> 2.7"
  gem 'colored',   "~> 1.2"
end

agent = Mechanize.new do |config|
  config.log = Logger.new(LOG_FILE)
  config.user_agent_alias = 'Windows Chrome' #:troll:
end

puts "packt grab started.....".blue
agent.get("https://www.packtpub.com/packt/offers/free-learning") do |promo_page|
  # Get login form and sumbit
  page = promo_page.form_with(dom_id: "packt-user-login-form") do |form|
    form.email         = ENV["EMAIL"]
    form.password      = ENV["PASSWORD"]
    form.form_id       = form["form_id"]
    form.form_build_id = form["form_build_id"]
  end.submit

  promo_link = page.link_with(dom_class: "twelve-days-claim")
  book_title = page.search("//div[@id='deal-of-the-day']//div[@class='dotd-title']").text
  book_title.strip! unless book_title.nil?

  begin
    agent.click(promo_link)
    puts "packt grab succeed.".green
    puts "Book title: #{book_title}".green
    puts "Claim URL: https://www.packtpub.com#{promo_link.href}".green
  rescue => e
    puts "packt grab failed, check #{LOG_FILE} for more details".red
    agent.log.fatal(e.message)
  end

end
