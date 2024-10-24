namespace :tournaments do
  desc "Updates the tournament cache"
  task update: :environment do
    LoadTournaments.new.perform
  end
end
