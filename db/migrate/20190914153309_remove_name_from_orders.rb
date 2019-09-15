class RemoveNameFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :name, :string
    remove_column :orders, :address, :string
    remove_column :orders, :city, :string
    remove_column :orders, :state, :string
    remove_column :orders, :zip, :string
    remove_column :users, :address, :string
    remove_column :users, :city, :string
    remove_column :users, :state, :string
    remove_column :users, :zip, :string
  end
end
