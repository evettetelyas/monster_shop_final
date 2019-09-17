require 'rails_helper'

describe Coupon, type: :model do
    describe "relationships" do
        it { should belong_to :merchant }
    end

    describe "validations" do
        it { should validate_presence_of :name }
        it { should validate_uniqueness_of :name }
        it { should validate_presence_of :status }
    end

    describe "model methods" do
        before :each do
            @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
            @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

            @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
            @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

            @user = create(:user)
            @address = create(:address)
            @coupon_1 = @meg.coupons.create(name: "20OFF", amount: 20)
            @coupon_2 = @brian.coupons.create(name: "20%OFF", percent: 20)
            @order_1 = @user.orders.create(address: @address, coupon_code: @coupon_1.name)
            @order_2 = @user.orders.create(address: @address, coupon_code: @coupon_2.name)
            @io_1 = @order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2)
            @io_2 = @order_2.item_orders.create(item: @pull_toy, price: @pull_toy.price, quantity: 3)
        end
        
        it "shows percent off" do
            expect(@coupon_2.percent_off).to eq("20%")
            expect(@coupon_1.percent_off).to eq("--")
        end
        
        it "shows amount off" do
            expect(@coupon_1.amount_off).to eq("$20.00")
            expect(@coupon_2.amount_off).to eq("--")
        end

        it "shows num of redemptions" do
            expect(@coupon_1.num_redemptions).to eq(1)
        end

        it "changes status" do
            @coupon_1.change_status

            expect(@coupon_1.status).to eq("inactive")

            @coupon_1.change_status

            expect(@coupon_1.status).to eq("active")
        end

        it "has order items" do
            expect(@coupon_1.has_order_items?(@order_1)).to be true
        end
    end
end