class Api::TournamentsController < Api::BaseController

  def index
    tournaments = Tournament.all

    render json: {tournaments: tournaments.collect(&:to_json)}
  end

end
