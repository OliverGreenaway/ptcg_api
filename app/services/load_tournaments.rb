class LoadTournaments

  attr_reader :success

  def perform
    fetch_tournament_data
  end

  private

  def fetch_tournament_data
    headers = [:date, :logo, :name, :city, :links]

    response = HTTParty.get(DataProviders::Arcanine.tournaments_url)
    doc = Nokogiri::HTML(response)

    #Load upcoming events
    tournaments = []
    doc.css("table#dtUpcomingEvents tbody tr, table#dtPastEvents tbody tr").each do |row|
      working_row = {}
      row.css("td").each_with_index do |cell, i|
        case headers[i]
        when :date
          working_row.merge!(parse_date_range(cell.text))
        when :logo
          #Handle logo (event_type)
        when :name
          working_row[:name] = cell.css("a").present? ? cell.css("a").text : clean_text(cell.text)
          working_row[:event_type] = extract_event_type(working_row[:name])
        when :city
          working_row[:location] = cell.text
        when :links
          working_row[:tcg] = is_tcg_tournament?(cell)
        end
      end
      Tournament.create_or_update(working_row) if working_row[:tcg]
    end
    @success = true
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

  def is_tcg_tournament?(cell)
    cell.text.include?("TCG")
  end

  def clean_text(text)
    text.gsub("\n","").strip
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
