class DataProviders::Arcanine
  BASE_URL = "https://rk9.gg"

  class << self
    def tournaments_url
      "#{BASE_URL}/events/pokemon"
    end

    def tournament_url(identifier)
      "#{BASE_URL}/tournament/#{identifier}"
    end

    def provider_id
      "RK9"
    end
  end
end
