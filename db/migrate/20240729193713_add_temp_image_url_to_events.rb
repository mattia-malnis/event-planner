class AddTempImageUrlToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :temp_image_url, :string
  end
end
