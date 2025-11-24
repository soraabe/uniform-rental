class AddRequestedAtToRentals < ActiveRecord::Migration[8.0]
  def change
    add_column :rentals, :requested_at, :datetime
  end
end
