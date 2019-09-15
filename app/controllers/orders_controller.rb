class OrdersController <ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def new
    user = User.find(session[:user_id])
    @addresses = user.addresses
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
  end

  def create
    user = User.find(session[:user_id])
    address = Address.find(params[:address].to_i)
    order = user.orders.create(address: address)
    create_item_orders(order)
    session.delete(:cart)
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

  private

  # def user_info(address)
  #   info = Hash.new
  #   info[:name] = address.name
  #   info[:street_address] = address.address
  #   info[:city] = address.city
  #   info[:state] = address.state
  #   info[:zip] = address.zip
  #   info[:address_id] = address.id
  #   info
  # end
end
