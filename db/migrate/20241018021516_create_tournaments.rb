class CreateTournaments < ActiveRecord::Migration[7.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :location
      t.string :status
      t.string :identifier
      t.string :event_type
      t.string :season
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :provider_identifier
      t.string :provider

      t.timestamps
    end
  end
end
