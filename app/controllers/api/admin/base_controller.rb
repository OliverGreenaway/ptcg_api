class Api::Admin::BaseController < Api::BaseController
  before_action :authenticate_devise_api_token!
end
