class Order <ApplicationRecord
  validates_presence_of :status, :user_id, :address_id

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user
  belongs_to :address

  enum status: { pending: 0, packaged: 1, shipped: 2 , cancelled: 3 }

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def items_count
    item_orders.sum(:quantity)
  end

  def my_items_count(merchant_id)
    item_orders.joins(:item).where("items.merchant_id = #{merchant_id}").sum("item_orders.quantity")
  end

  def my_total(merchant_id)
    item_orders.joins(:item).where("items.merchant_id = #{merchant_id}").sum("item_orders.quantity * item_orders.price")
  end

  def merchant_items(merchant)
    items.where(merchant_id: merchant.id)
  end

  def qty_item_in_order(item)
    item_orders.find_by(item_id: item.id).quantity
  end

  def find_item_status(item)
    item_orders.find_by(item_id: item.id).status
  end

  def update_status
    self.update(status: 1) if item_orders.pluck(:status).all? {|status| status == "fulfilled"}
  end

  def update_coupon_discounts
    coupon = Coupon.find_by(name: self.coupon_code)
    merchant_items = ItemOrder.where(item_id: items.where(merchant_id: coupon.merchant_id).ids, order_id: self.id)
    if coupon.percent > 0 && coupon.status == "active"
      merchant_items.each do |io|
        io.update(price: io.price - (io.price * (coupon.percent * 0.01)))
        io.save
      end
    end
    if coupon.amount > 0 && (merchant_items.sum('price * quantity') >= coupon.amount) && coupon.status == "active"
      self.update(grand_total: (item_orders.sum('price * quantity') - coupon.amount) )
      self.save
    end
  end
end
