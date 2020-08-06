class AddFruitAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :fruit_address, :float
  end
end
