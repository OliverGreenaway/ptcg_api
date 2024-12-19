class Api::Admin::DataController < Api::Admin::BaseController
  before_action :ensure_owner!

  def reset
    ResetData.perform

    render json: {
      status: :ok
    }.to_json
  end

end
