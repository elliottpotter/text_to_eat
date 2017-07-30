class CookiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :cookie_params, only: [:create]

  def create
    AllflicksCookie.create(
      phpsessid:  cookie_params[:phpsessid],
      identifier: cookie_params[:identifier]
    )
  end

  private

  def cookie_params
    cookies = {}
    params[:cookies].map { |cookie| cookies[cookie[:name]] = cookie[:value] if cookie[:name] == "PHPSESSID" || cookie[:name] == "identifier" }
    params[:phpsessid]  = cookies["PHPSESSID"]
    params[:identifier] = cookies["identifier"]
    params.permit(:phpsessid, :identifier)
  end

end
