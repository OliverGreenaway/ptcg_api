namespace :tournaments do
  desc "Updates the tournament cache"
  task update: :environment do
    LoadTournaments.perform
  end
end
