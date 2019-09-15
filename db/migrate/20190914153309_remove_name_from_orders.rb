class RemoveNameFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :name, :string
    remove_column :orders, :address, :string
    remove_column :orders, :city, :string
    remove_column :orders, :state, :string
    remove_column :orders, :zip, :string
  end
end
