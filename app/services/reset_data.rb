class ResetData < Base

  def perform
    drop_and_reload_tournaments
  end

  private

  def drop_and_reload_tournaments
    Tournament.all.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence!('tournaments')
    LoadTournaments.perform
  end
end
