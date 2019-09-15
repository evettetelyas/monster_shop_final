require 'rails_helper'

RSpec.describe "change address for pending orders" do
    before :each do
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @user = create(:user)
        @address_1 = create(:address, user: @user, nickname: "addy 1")
        @address_2 = create(:address, user: @user, nickname: "addy 2")
        @order_1 = @user.orders.create!(address: @address_1)
        @order_2 = @user.orders.create!(address: @address_1, status: 2)
        @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
        @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    end
    it "should change address for pending orders" do
        visit '/login'
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password

        within '#login-form' do
            click_on 'Log In'
          end

        click_on "My Orders"
        click_on "Order #{@order_1.id}"
        select "#{@address_2.nickname}", from: :address
        click_on "Update Address"

        expect(current_path).to eq("/profile/orders")
        expect(page).to have_content("Your address has been updated")

        click_on "Order #{@order_1.id}"

        expect(page).to have_content(@address_2.name)
        expect(page).to have_content(@address_2.address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
    end

    it "should not change for non-pending orders" do
        visit '/login'
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password

        within '#login-form' do
            click_on 'Log In'
          end

        click_on "My Orders"
        click_on "Order #{@order_2.id}"

        expect(page).to_not have_content("Update Address")
    end
end