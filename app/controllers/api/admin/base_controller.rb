class Api::Admin::BaseController < Api::BaseController
  protect_from_forgery prepend: true
  before_action :authenticate_devise_api_token!

  private

  def ensure_owner!
    unless current_devise_api_user && current_devise_api_user.owner?
      head(401)
    end
  end
end
