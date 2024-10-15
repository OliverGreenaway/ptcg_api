class GetTournaments

  attr_reader :result

  def perform
    @result = [
      {
        id: 1234,
        name: "Louisville Pokémon Regional Championships 2025",
        location: "Louisville, US",
        start_date: Date.new(2024,10,11),
        end_date: Date.new(2024,10,13)
      }
    ]
  end
end
