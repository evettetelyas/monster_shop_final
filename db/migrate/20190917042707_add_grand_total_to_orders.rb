class AddGrandTotalToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :grand_total, :float
  end
end
