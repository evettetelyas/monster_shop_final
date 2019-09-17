class Merchant::CouponsController < Merchant::BaseController
    def new
        @merchant = User.find(session[:user_id]).merchant
        @coupon = @merchant.coupons.new
    end

    def create
        merchant = User.find(session[:user_id]).merchant
        coupon = merchant.coupons.new(coupon_params)
        if coupon.save
            flash[:success] = "Added, bro"
            redirect_to merchant_dash_path
        else
            flash[:error] = coupon.errors.full_messages.to_sentence
            redirect_to merchant_dash_path
        end
    end

    def edit
        @coupon = Coupon.find(params[:id])
    end

    def update
        @coupon = Coupon.find(params[:id])
        @coupon.update(coupon_params)
        @coupon.save
        redirect_to merchant_dash_path
    end

    def destroy
        @coupon = Coupon.find(params[:id])
        @coupon.destroy
        redirect_to merchant_dash_path
    end

    def change_status
        coupon = Coupon.find(params[:id])
        coupon.change_status
        redirect_to merchant_dash_path
    end

    private

    def coupon_params
        params.require(:coupon).permit(:name,:percent,:amount)
    end
end