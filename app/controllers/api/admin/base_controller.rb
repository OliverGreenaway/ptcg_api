class Api::Admin::BaseController < Api::BaseController
  protect_from_forgery prepend: true
  before_action :authenticate_devise_api_token!
end
