class Api::TournamentsController < Api::BaseController

  def index
    service = GetTournaments.new

    render json: {
      tournaments: service.result
    }
  end

end
