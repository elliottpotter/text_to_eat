require 'mechanize'

class QueriesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if User.where(phone_number: params[:from]).first
      @user = User.where(phone_number: params[:from]).first
    else
      @user = User.create(phone_number: params[:from])
    end
    @query = Query.create(user: @user, query: params[:body].strip.lstrip)
    find_restaurants(@query.query)
  end


  def find_restaurants(query)
    query = (query.split.each {|w| w.capitalize!}).join(' ').gsub(",","")
    agent = Mechanize.new
    first_page = agent.get("https://www.tripadvisor.com/Restaurants")
    first_page.forms[0]["q"] = query
    second_page = first_page.forms[0].submit
    restaurants = []
    city = query.split.first.downcase.capitalize
    restaurant_page = second_page.link_with(href: /(Restaurants).*(#{city})/).click
    restaurant_page.search(".property_title").first(5).each { |res| restaurants << res.text.gsub(/\n/, '') }
    send_results(restaurants)
  end


  def send_results(restaurants)
    @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
    @client.messages.create(
      from: '+12052895050',
      to:   @user.phone_number,
      body: "1. #{restaurants[0]} \n2. #{restaurants[1]} \n3. #{restaurants[2]} \n4. #{restaurants[3]} \n5. #{restaurants[4]}"
    )
  end


end
