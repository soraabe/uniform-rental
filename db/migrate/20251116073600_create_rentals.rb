class CreateRentals < ActiveRecord::Migration[8.0]
  def change
    create_table :rentals do |t|
      t.string :customer_name
      t.string :uniform_type
      t.date :rental_date
      t.date :return_date
      t.decimal :price

      t.timestamps
    end
  end
end
