class Api::Admin::TournamentsController < Api::Admin::BaseController
    def index
      tournaments = Tournament.all
      render json: {tournaments: tournaments.collect(&:to_json)}
    end
end
