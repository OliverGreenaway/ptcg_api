class Api::TournamentsController < Api::BaseController

  def index
    tournaments = Tournament.all.order(&:starts_at).reverse
    render json: {tournaments: tournaments.collect(&:to_json)}
  end

  def show
    tournament = Tournament.find(params[:id])
    render json: { tournament: tournament.to_json }
  end

end
