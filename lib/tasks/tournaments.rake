namespace :tournaments do
  desc "Updates the tournament cache"
  task update: :environment do
    LoadTournamentsV2.perform
  end
end
