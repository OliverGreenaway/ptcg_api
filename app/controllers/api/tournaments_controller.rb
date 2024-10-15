class Api::TournamentsController < Api::BaseController

  def index
    service = GetTournaments.new
    service.perform

    render json: {
      tournaments: service.result
    }
  end

end
