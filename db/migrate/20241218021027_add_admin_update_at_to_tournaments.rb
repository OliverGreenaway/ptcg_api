class AddAdminUpdateAtToTournaments < ActiveRecord::Migration[7.1]
  def change
    add_column :tournaments, :admin_updated_at, :datetime
  end
end
