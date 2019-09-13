class AddressesController < ApplicationController

    def index
        @user = User.find(session[:user_id])
    end

    def show
        @address = Address.find(params[:id])
        redirect_to profile_addresses_path
    end

    def new
        @user = User.find(session[:user_id])
        @address = Address.new
    end

    def create
        user = User.find(session[:user_id])
        address = user.addresses.new(address_params)
        if address.save
            flash[:success] = "Your new address has been added"
            redirect_to "/profile/addresses"
        else
            flash[:error] = address.errors.full_messages.to_sentence
            render :new
        end
    end

    def edit
        @address = Address.find(params[:id])
    end

    def update
        @address = Address.find(params[:id])
        @address.update(address_params)
        if @address.save
            flash[:success] = "Your address has been updated"
            redirect_to "/profile/addresses"
        else             
            flash[:error] = @address.errors.full_messages.to_sentence
            render :edit
        end
    end

    def destroy
        address = Address.find(params[:id])
        if address.has_pending_orders?
            flash[:error] = "You can't delete an address with pending, cancelled, or shipped orders, yo."
            redirect_to "/profile/addresses"
        else
            address.destroy
            flash[:success] = "Your address has been removed"
            redirect_to "/profile/addresses"
        end
    end


    private

    def address_params
        params.require(:address).permit(:nickname,:name,:address,:city,:state,:zip)
    end
end