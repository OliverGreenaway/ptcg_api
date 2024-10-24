class Tournament < ApplicationRecord

  def self.create_or_update(attributes)
    identifier = build_identifier(
      city: process_city(attributes[:location]),
      event_type: attributes[:event_type],
      season: process_season(attributes[:name], attributes[:end_date])
    )
    if tournament = Tournament.find_by(identifier: identifier)
      tournament.update(
        attributes_to_tournament(attributes, identifier)
      )
    else
      Tournament.create(
        attributes_to_tournament(attributes, identifier)
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

  def self.build_identifier(city:, event_type:, season:)
    "#{city.downcase}-#{event_type}-#{season}"
  end

  def self.process_city(location)
    location.split(',')[0].split('-')[0].strip.gsub(".","").gsub(" ","-")
  end

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

  def self.attributes_to_tournament(attributes, identifier)
    {
      name: attributes[:name],
      location: attributes[:location],
      status: "Unknown",
      identifier: identifier,
      event_type: attributes[:event_type],
      season: process_season(attributes[:name], attributes[:end_date]),
      starts_at: attributes[:start_date],
      ends_at: attributes[:end_date],
      provider_identifier: "?????",
      provider: "rk9"
    }
  end

end
