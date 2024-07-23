class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.string :country, null: false
      t.datetime :date, null: false
      t.decimal :lat, precision: 10, scale: 8
      t.decimal :long, precision: 11, scale: 8

      t.timestamps
    end

    add_check_constraint :events, "lat >= -90 AND lat <= 90", name: "lat_check"
    add_check_constraint :events, "long >= -180 AND long <= 180", name: "long_check"
  end
end
