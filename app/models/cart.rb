class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def quantity_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def add_quantity(item_id)
    @contents[item_id.to_s] = quantity_of(item_id) + 1
  end

  def subtract_quantity(item_id)
    @contents[item_id.to_s] = quantity_of(item_id) - 1
  end

  def total_items
    num_items = @contents.values.map(&:to_i).sum
    @contents.empty? ? 0 : num_items
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    @contents[item.id.to_s].to_i * item.price
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def limit_reached?(item_id)
    @contents[item_id.to_s] == Item.find(item_id).inventory
  end

  def quantity_zero?(item_id)
    @contents[item_id.to_s] == 0
  end

  def has_merchant_items?(id)
    @contents.keys.any? {|item_id| Item.find(item_id.to_i).merchant_id == id.to_i}
  end

  def discount_price_percent(pct, merchant_id)
    disc_price = {}
    @contents.keys.each do |item_id|
      item = Item.find(item_id.to_i)
      if item.merchant_id == merchant_id
        disc_price[item] = (item.price - (item.price * (pct * 0.01)))
      else 
        disc_price[item] = item.price
      end
    end
    disc_price
  end

  def subtotal_discount(item, pct, merchant_id)
    discount_price_percent(pct, merchant_id)[item] * @contents[item.id.to_s].to_i
  end

  def total_discount_percent(pct, merchant_id)
    total = 0
    @contents.keys.each do |item_id|
      total += subtotal_discount(Item.find(item_id.to_i), pct, merchant_id)
    end
    total
  end

  def has_enough_merchant_stuff?(amount, id)
    total = 0
    item_ids = @contents.keys.select {|item_id| Item.find(item_id.to_i).merchant_id == id.to_i}
    item_ids.each do |id|
      total += @contents[id.to_s]
    end
    return true if total > amount
  end

  def discount_amount(amount)
    sum = @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
    sum -= amount
  end

end
