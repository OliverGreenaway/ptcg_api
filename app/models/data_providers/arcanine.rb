class DataProviders::Arcanine
  BASE_URL = "https://rk9.gg"

  class << self
    def tournaments_url
      "#{BASE_URL}/events/pokemon"
    end
  end
end
