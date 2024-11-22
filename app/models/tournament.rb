class Tournament < ApplicationRecord

  IMMUTABLE_ATTRIBUTES = []

  def self.create_or_update(attributes)
    if tournament = Tournament.find_by(provider: attributes[:provider], provider_identifier: attributes[:provider_identifier])
      tournament.update(
        attributes_to_tournament(attributes)
      )
    else
      Tournament.create(
        attributes_to_tournament(attributes)
      )
    end
  end

  def to_json
    {
      id: id,
      name: name,
      location: location,
      status: status,
      event_type: event_type,
      season: season,
      starts_at: starts_at,
      ends_at: ends_at
    }
  end

  private

  def self.process_season(name, fallback_date)
    numbers = name.delete("^0-9")
    if numbers.length == 4
      numbers
    elsif numbers.length == 8
      numbers[4..]
    else
      fallback_date.year.to_s
    end
  end

  def self.attributes_to_tournament(attributes)
    {
      name: attributes[:name],
      location: attributes[:location],
      status: "Unknown",
      event_type: attributes[:event_type],
      season: process_season(attributes[:name], attributes[:end_date]),
      starts_at: attributes[:start_date],
      ends_at: attributes[:end_date],
      provider_identifier: attributes[:provider_identifier],
      provider: attributes[:provider]
    }
  end

end
