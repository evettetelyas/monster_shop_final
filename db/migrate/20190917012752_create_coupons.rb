class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :percent, default: 0
      t.integer :amount, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
