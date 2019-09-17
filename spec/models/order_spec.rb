require 'rails_helper'

describe Order, type: :model do

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
    it {should belong_to :address}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user = create(:user)
      @address = create(:address)
      @order_1 = @user.orders.create!(address: @address)
      @io_1 = @order_1.item_orders.create(item: @tire, price: @tire.price, quantity: 2)
      @io_2 = @order_1.item_orders.create(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it '#grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it '#items_count' do
      expect(@order_1.items_count).to eq(5)
    end


    it '#my_total' do
      expect(@order_1.my_total(@brian.id)).to eq(30)
    end

    it "#my_items_count" do
      expect(@order_1.my_items_count(@brian.id)).to eq(3)
    end

    it '#merchant_items' do
      expect(@order_1.merchant_items(@meg)).to eq([@tire])
    end

    it '#qty_item_in_order' do
      expect(@order_1.qty_item_in_order(@tire)).to eq(2)
    end

    it '#find_item_status' do
      expect(@order_1.find_item_status(@tire)).to eq('unfulfilled')
    end

    it '#update_status' do
      expect(@order_1.status).to eq('pending')

      @order_1.item_orders.each do |item_order|
        item_order.fulfill
      end

      @order_1.update_status

      expect(@order_1.status).to eq('packaged')
    end

    it "updates for a $ off coupon" do
      twenty = @meg.coupons.create(name: "20OFF", amount: 20)
      @order_1.update(coupon_code: twenty.name)

      @order_1.update_coupon_discounts(twenty)

      expect(@order_1.grand_total).to eq(210)
    end

    it "updates for percent off coupon" do
      twentyp = @meg.coupons.create(name: "20%OFF", percent: 20)
      @order_1.update(coupon_code: twentyp.name)
      @order_1.update_coupon_discounts(twentyp)

      expect(@order_1.grandtotal).to eq(190)
    end

  end
end
