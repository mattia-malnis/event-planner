class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :iso, limit: 2, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :countries, "lower(iso)", unique: true, name: "index_countries_on_lower_iso"
  end
end
