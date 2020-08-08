class RemoveFruitAddressFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :fruit_address, :float
  end
end
