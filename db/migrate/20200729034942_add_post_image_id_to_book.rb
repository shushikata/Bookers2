class AddPostImageIdToBook < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :post_image_id, :string
  end
end
