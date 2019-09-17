class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    if current_admin?
      render file: "/public/404"
    else
      @items = cart.items
    end
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_decrement
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end

  def apply_coupon
    if coupon = Coupon.find_by(name: params[:coupon_code])
      if coupon.percent > 0 && coupon.status == "active" && cart.has_merchant_items?(coupon.merchant_id)
        cart.discount_price_percent(coupon.percent, coupon.merchant_id)
        session[:coupon_code] = coupon.name
        flash[:success] = "Coupon applied homie"
      elsif coupon.amount > 0 && (cart.total >= coupon.amount) && coupon.status == "active" && cart.has_enough_merchant_stuff?(coupon.amount, coupon.merchant_id)
        cart.discount_amount(coupon.amount)
        session[:coupon_code] = coupon.name
        flash[:success] = "Coupon applied homie"
      elsif coupon.status == "inactive"
        flash[:error] = "Nah this code is expired yo"
        session[:coupon_code] = nil
      elsif !cart.has_merchant_items?(coupon.merchant_id)
        flash[:error] = "you cant use a merchant's code for other people's stuff"
        session[:coupon_code] = nil
      elsif !cart.has_enough_merchant_stuff?(coupon.amount, coupon.merchant_id)
        flash[:error] = "you're a cheapo that's not how this works. add more things from the coupon's merchant."
        session[:coupon_code] = nil
      end
    else
      flash[:error] = "that's not a real code"
      session[:coupon_code] = nil
    end
    redirect_to new_order_path
  end
end
