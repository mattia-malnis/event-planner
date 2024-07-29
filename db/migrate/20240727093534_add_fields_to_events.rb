class AddFieldsToEvents < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :country
    rename_column :events, :date, :date_start
    add_column :events, :date_end, :datetime
    add_column :events, :city, :string
    add_column :events, :external_ref, :string
    add_reference :events, :country
    add_index :events, :external_ref, unique: true
  end
end
