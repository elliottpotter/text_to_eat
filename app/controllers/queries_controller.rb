require 'mechanize'

class QueriesController < ApplicationController
  

  def create
    if User.where(phone_number: params[:from])
      @user = User.where(phone_number: params[:from_number])
    else
      @user = User.create(phone_number: params[:phone_number])
    end
    @query = Query.create(user: @user, query: params[:body].strip.lstrip)
    find_restaurants(@query)
  end


  def find_restaurants(query)
    query = (query.split.each {|w| w.capitalize!}).join(' ')
    agent = Mechanize.new
    first_page = agent.get("https://www.tripadvisor.com/Restaurants.com")
    first_page.forms[0]["q"] = query
    second_page = first_page.forms[0].submit
    restaurants = []
    city = query.split.first.lower.capitalize
    restaurant_page = second_page.link_with(href: /(Restaurants).*(city)/).click
    restaurant_page.search(".property_title").first(5).each { |res| restaurants << res.text.gsub(/\n/, '') }
    send_results(restaurants)
  end


  def send_results(restaurants)
    @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
    @client.messages.create(
      from: '+12052895050',
      to:   @user.phone_number,
      body: restaurants.each_with_index { |restaurant, i| puts "#{i + 1}. #{restaurant}" }
    )
  end


end
