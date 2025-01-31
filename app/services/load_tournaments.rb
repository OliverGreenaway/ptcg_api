class LoadTournaments < Base

  attr_reader :success

  def perform
    get_tournament_ids_and_locations
    create_or_update_tournaments
  end

  private

  attr_reader :tournament_ids, :locations_by_id, :status_by_id

  def get_tournament_ids_and_locations
    tournaments_response = HTTParty.get(DataProviders::Arcanine.tournaments_url)
    doc = Nokogiri::HTML(tournaments_response)
    @tournament_ids = doc.css("a:contains('TCG')").collect { |e| e.attributes["href"].value.split('/')[2] }

    @locations_by_id = {}
    @status_by_id = {}
    tournament_ids.each do |tournament_id|
      locations_by_id[tournament_id] = doc.css("a[href*='#{tournament_id}']").first.parent.parent.css("td")[3].text

      section = doc.css("a[href*='#{tournament_id}']").first.parent.parent.parent.parent.parent.parent.parent.css("h4")[0].text
      status_by_id[tournament_id] = calculate_status(section, tournament_id)
    end

  end

  def create_or_update_tournaments
    @tournament_ids.each do |tournament_id|
      tournament_response = HTTParty.get(DataProviders::Arcanine.tournament_url(tournament_id))
      doc = Nokogiri::HTML(tournament_response)

      name = doc.css("h3").first.text.split("\n").first
      event_type = extract_event_type(name)
      location = locations_by_id[tournament_id]
      event_dates = parse_date_range(clean_text((doc.css("dt:contains('Event dates')") + doc.css("dt:contains('Dates')")).first.next.next.text))
      starts_at = DateTime.parse(clean_text(doc.css("dt:contains('Tournament start')").first.next.next.text).split("Junior").first.strip)
      ends_at = event_dates[:end_date].to_datetime.change(:offset => starts_at.zone).end_of_day
      status = status_by_id[tournament_id]

      Tournament.create_or_update(
        name: name,
        event_type: event_type,
        location: location,
        start_date: starts_at,
        end_date: ends_at,
        provider: DataProviders::Arcanine.provider_id,
        provider_identifier: tournament_id,
        status: status
      )
    end
  end

  def calculate_status(section, tournament_id)
    return "finished" if section == "Past Pokémon Events"

    roster_response = HTTParty.get(DataProviders::Arcanine.roster_url(tournament_id))
    doc = Nokogiri::HTML(roster_response)
    check_in_open = doc.css("#dtLiveRoster tbody").first.children.count > 1

    return "upcoming" unless check_in_open

    pairing_response = HTTParty.get(DataProviders::Arcanine.pairings_url(tournament_id))
    doc = Nokogiri::HTML(pairing_response)
    tournament_running = doc.css(".tab-content.pt-2.px-3").first.children.count > 0

    tournament_running ? "running" : "check-in"
  end

  def clean_text(text)
    text.gsub("\n","").strip
  end

  def parse_date_range(date_string)
    hythen_delimiters = ["-", "–"]

    if date_string.split(" ").count == 3
      #Range is within the one month e.g. August 11–13, 2023
      month, day_range, year = date_string.split(" ")
      day_range.gsub!(",","")
      days = day_range.split(Regexp.union(hythen_delimiters)).collect(&:to_i)
      date_hash(
        "#{days.min} #{month} #{year}",
        "#{days.max} #{month} #{year}"
      )
    else
      #Range spans two months e.g. November 30-December 1, 2024
      first_month, first_date_and_second_month, second_date, year = date_string.split(" ")
      first_date, second_month = first_date_and_second_month.split(Regexp.union(hythen_delimiters))
      second_date.gsub!(",","")
      date_hash(
        "#{first_date} #{first_month} #{year}",
        "#{second_date} #{second_month} #{year}"
      )
    end
  end

  def date_hash(start_date_str, end_date_str)
    {
      start_date: Date.parse(start_date_str),
      end_date: Date.parse(end_date_str)
    }
  end

  def extract_event_type(name)
    types = {
      "Regional" => :regional,
      "International" => :international,
      "World" => :world,
      "Special" => :special
    }

    types.keys.each do |type|
      return types[type] if name.include?(type)
    end
  end

end
