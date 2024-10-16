class Api::TournamentsController < Api::BaseController

  def index
    service = GetTournaments.new

    render json: service.result
  end

end
