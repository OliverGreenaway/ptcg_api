namespace :tournaments do
  desc "Updates the tournament cache"
  task update: :environment do
    GetTournaments.new.refresh!
  end
end
