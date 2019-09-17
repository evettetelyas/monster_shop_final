require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before :each do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '123 Dog Rd.', city: 'Denver', state: 'CO', zip: 80204)
      @coupon_1 = @meg.coupons.create(name: "20DOLLASOFF", amount: 20)
      @coupon_2 = @meg.coupons.create(name: "20PERCENTOFF", percent: 20)
      @coupon_3 = @mike.coupons.create(name: "200OFF", amount: 200)
      @coupon_4 = @meg.coupons.create(name: "FREESTUFF", amount: 200, status: 1)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @pulltoy = @brian.items.create(name: "Pulltoy", description: "It'll never fall apart!", price: 14, image: "https://www.valupets.com/media/catalog/product/cache/1/image/650x/040ec09b1e35df139433887a97daa66f/l/a/large_rubber_dog_pull_toy.jpg", inventory: 7)

      @user = create(:user)
      address = create(:address, user: @user)

      visit '/login'

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password

      within '#login-form' do
        click_on 'Log In'
      end
    end

    it 'I can create a new order' do
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      expect(page).to have_button('Create Order')

      click_on "Create Order"

      new_order = Order.last

      expect(current_path).to eq("/profile/orders")

      expect(page).to have_content('Thank You For Your Order!')
      expect(page).to have_content(new_order.updated_at.strftime('%D'))
      expect(page).to have_content(new_order.status)
      expect(page).to have_content(new_order.items_count)
      expect(page).to have_content("$142.00")
      expect(page).to have_content(new_order.created_at.strftime('%D'))
    end

    it "creates new order with a amount off coupon" do
    
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in "Maximize yo discounts with a coupon!", with: @coupon_1.name
      click_on "Check yo discounts"

      expect(page).to have_content("$80.00")
      expect(page).to have_content("Coupon applied homie")
      expect(page).to have_content("Coupon Applied: #{@coupon_1.name}")
      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end

    it "won't create a new order with a amount off coupon for another merchant" do
    
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in "Maximize yo discounts with a coupon!", with: @coupon_1.name
      click_on "Check yo discounts"

      expect(page).to have_content("you cant use a merchant's code for other people's stuff")

      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end

    it "won't create a new order with a amount off coupon higher than the merchants subtotal" do
    
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in "Maximize yo discounts with a coupon!", with: @coupon_3.name
      click_on "Check yo discounts"

      expect(page).to have_content("you're a cheapo that's not how this works. add more things from the coupon's merchant.")

      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end

    it "adds a percent off coupon" do
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in "Maximize yo discounts with a coupon!", with: @coupon_2.name
      click_on "Check yo discounts"

      expect(page).to have_content("$80.00")
      expect(page).to have_content("Coupon applied homie")
      expect(page).to have_content("Coupon Applied: #{@coupon_2.name}")
      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end

    it "won't use an expired coupon" do
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in "Maximize yo discounts with a coupon!", with: @coupon_4.name
      click_on "Check yo discounts"

      expect(page).to have_content("Nah this code is expired yo")

      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end

    it "won't use a random coupon" do
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      fill_in "Maximize yo discounts with a coupon!", with: "random stuff"
      click_on "Check yo discounts"

      expect(page).to have_content("that's not a real code")
      
      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end
  end
end
