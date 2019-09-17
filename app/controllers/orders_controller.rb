class OrdersController <ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def new
    user = User.find(session[:user_id])
    @addresses = user.addresses
    @coupon = Coupon.find_by(name: session[:coupon_code])
  end

  def cancel_item_orders(order)
    order.item_orders.each do |item_order|
      item_order.status = "unfulfilled"
      item = Item.find(item_order.item_id)
      item.restock(item_order.quantity)
      item_order.save
    end
  end

  def cancel
    order = Order.find(params[:id])
    cancel_item_orders(order)
    order.status = "cancelled"
    order.save
    if current_admin?
      flash[:success] = "You destroyed the users order dawg"
      redirect_to "/admin"
    else
      flash[:success] = "Your order has been cancelled dawg"
      redirect_to "/profile"
    end
  end

  def show
    @order = Order.find(params[:order_id])
    @coupon = Coupon.find_by(name: @order.coupon_code)
    @address = @order.address
    user = User.find(session[:user_id])
    @addresses = user.addresses
  end

  def create_item_orders(order)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
    if session[:coupon_code]
      coupon = Coupon.find_by(name: session[:coupon_code])
      order.update(coupon_code: session[:coupon_code])
      order.update_coupon_discounts(coupon)
      order.save
    end
  end

  def create
    user = User.find(session[:user_id])
    address = Address.find(params[:address].to_i)
    order = user.orders.create(address: address)
    create_item_orders(order)
    session.delete(:cart)
    session[:coupon_code] = nil
    redirect_to "/profile/orders"
    flash[:success] = "Thank You For Your Order!"
  end

  def ship
    order = Order.find(params[:order_id])
    order.update(status: 'shipped')
    order.save
    flash[:success] = "Order No. #{order.id} has been shipped, yo!"
    redirect_to "/admin"
  end

  def update_address
    order = Order.find(params[:id].to_i)
    address = Address.find(params[:address].to_i)
    order.update(address: address)
    order.save
    flash[:success] = "Your address has been updated"
    redirect_to "/profile/orders"
  end
end
