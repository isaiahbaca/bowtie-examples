class CreateBreweries < ActiveRecord::Migration
  def change
    create_table :breweries do |t|
      t.string :name
      t.text :description
      t.string :city
      t.string :state
      t.string :country
      t.string :user_id

      t.timestamps null: false
    end
  end
end
