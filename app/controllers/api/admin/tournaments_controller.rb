class Api::Admin::TournamentsController < Api::Admin::BaseController

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
