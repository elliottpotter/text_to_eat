class QueriesController < ApplicationController

  def create
    if User.where(phone_number: params[:from_number])
      @user = User.where(phone_number: params[:from_number])
    else
      @user = User.create(phone_number: params[:phone_number])
    end

    @query = Query.create(user: @user, query: params[:body])
    code               = @driver.verification_code
    @client = Twilio::REST::Client.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
    @client.messages.create(
      from: '+12052895050',
      to:   '+12178163505',
      body: "This is elliott from a test app, let me know if you get dits!"
    )
  end
end
