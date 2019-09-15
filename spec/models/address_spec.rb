require 'rails_helper'

describe Address, type: :model do
    describe "validations" do
      it {should validate_presence_of(:nickname)}
      it {should validate_presence_of(:name)}
      it {should validate_presence_of(:address)}
      it {should validate_presence_of(:city)}
      it {should validate_presence_of(:state)}
      it {should validate_presence_of(:zip)}
    end

    describe "relationships" do
        it { should belong_to :user }
    end

    describe "model methods" do
      before :each do
        @user = create(:user)
        @address = create(:address, user: @user)
        @merchant_admin = create(:user, role: 3)
        @merchant = create(:merchant)
        @admin = create(:user, role: 4)
        @item = create(:item, merchant: @merchant)
        @order = create(:order, address: @address, user: @user)
        @io = @order.item_orders.create(item: @item, quantity: 2)
      end

      it "should return status of no shipped orders" do
        expect(@address.has_no_shipped_orders?).to be true
      end

      it "should return status of any pending/packaged/shipped orders" do
        expect(@address.has_pending_orders?).to be true
      end
    end

end