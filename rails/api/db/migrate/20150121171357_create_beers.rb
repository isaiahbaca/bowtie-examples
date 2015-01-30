class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string  :name
      t.text    :description
      t.string  :user_id
      t.integer :brewery_id

      t.timestamps null: false
    end
    add_index :beers, :brewery_id
  end
end
