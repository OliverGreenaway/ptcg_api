class Api::Admin::TournamentsController < Api::Admin::BaseController
    def index
      tournaments = Tournament.all
      render json: {tournaments: tournaments.collect(&:to_json)}
    end

    def show
      tournament = Tournament.find(params[:id])
      render json: { tournament: tournament.to_json }
    end

    def update
      tournament = Tournament.find(params[:id])
      tournament.update(tournament_params.merge(admin_updated_at: Time.now))

      render json: { tournament: tournament.to_json }
    end

    private

    def tournament_params
      params.require(:tournament).permit(:name)
    end
end
