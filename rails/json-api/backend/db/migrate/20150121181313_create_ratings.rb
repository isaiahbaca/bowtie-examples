class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :user_id
      t.integer :beer_id
      t.text :comment
      t.integer :rating

      t.timestamps null: false
    end
  end
end
