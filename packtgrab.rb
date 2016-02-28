#!/usr/bin/ruby

require "bundler/inline"
require  "yaml"

LOG_FILE = "packtgrab.log"

gemfile true do
  source "https://rubygems.org"
  gem "json"
  gem "mechanize", "~> 2.7"
  gem "colored",   "~> 1.2"
end

agent = Mechanize.new do |config|
  config.log = Logger.new(LOG_FILE)
  config.user_agent_alias = 'Windows Chrome' #:troll:
end

# Get credential
auth = YAML.load_file("packt_auth.yaml")

puts "packt grab started.....".cyan
agent.get("https://www.packtpub.com/packt/offers/free-learning") do |promo_page|
  # Get login form and sumbit
  page = promo_page.form_with(dom_id: "packt-user-login-form") do |form|
    form.email         = auth["PACKT_EMAIL"]
    form.password      = auth["PACKT_PASSWORD"]
    form.form_id       = form["form_id"]
    form.form_build_id = form["form_build_id"]
  end.submit

  promo_link = page.link_with(dom_class: "twelve-days-claim")
  book_title = page.search("//div[@id='deal-of-the-day']//div[@class='dotd-title']").text
  book_title.strip! unless book_title.nil?

  begin
    agent.click(promo_link)
    puts "Book title: #{book_title}".green
    puts "Claim URL: https://www.packtpub.com#{promo_link.href}".green
    puts "packt grab succeed.".cyan
  rescue => e
    puts "packt grab failed, check #{LOG_FILE} for more details".red
    agent.log.fatal(e.message)
  end
end
