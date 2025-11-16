class AddStatusFieldsToRentals < ActiveRecord::Migration[8.0]
  def change
    add_column :rentals, :status, :string
    add_column :rentals, :line_user_id, :string
    add_column :rentals, :display_name, :string
    add_column :rentals, :uniform_info, :string
    add_column :rentals, :rented_at, :datetime
    add_column :rentals, :returned_at, :datetime
  end
end
