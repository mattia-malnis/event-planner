class AddApiKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :api_key, :string
    add_index :users, :api_key, unique: true
    User.reset_column_information
    User.all.each(&:regenerate_api_key)
  end
end
