require 'rails_helper'

describe Cart do
  it "can initialize with no contents" do
    cart = Cart.new(nil)
    expect(cart.contents).to eq({})
  end

  it "can initialize with contents" do
    cart = Cart.new({"4"=>"2", "7"=>"1"})
    expect(cart.contents).to eq({"4"=>"2", "7"=>"1"})
  end

  it "can report total items in cart" do
    cart = Cart.new(nil)
    expect(cart.total_items).to eq(0)

    cart = Cart.new({"4"=>"2", "7"=>"1"})
    expect(cart.total_items).to eq(3)
  end

  it "can add items to contents" do
    cart = Cart.new(nil)
    cart.add_item("7")
    expect(cart.contents).to eq({"7"=>1})
    cart.add_item("7")
    expect(cart.contents).to eq({"7"=>2})
    cart.add_item("2")
    expect(cart.contents).to eq({"7"=>2, "2"=>1})
  end

  it "can add item quantity" do
    cart = Cart.new(nil)
    cart.add_item("7")
    cart.add_quantity("7")
    cart.add_quantity("7")
    expect(cart.contents).to eq({"7"=>3})
  end

  it "can subtract item quantity" do
    cart = Cart.new({"7"=>3})
    cart.subtract_quantity("7")
    cart.subtract_quantity("7")
    expect(cart.contents).to eq({"7"=>1})
  end

  it "can check item quantity" do
    cart = Cart.new({"7"=>3})
    expect(cart.quantity_of("7")).to eq(3)
  end

  before :each do
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 3)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 2)
    @cart = Cart.new({@pull_toy.id.to_s => 1, @dog_bone.id.to_s => 2})
  end

  it "discounts a dollar amount" do
    expect(@cart.discount_amount(20)).to eq(32)
  end

  it "has enough merchant stuff to apply an amount discount" do
    expect(@cart.has_enough_merchant_stuff?(20, @dog_shop.id)).to be true
  end

  it "generates the total for a discount percentage" do
    expect(@cart.total_discount_percent(20, @dog_shop.id)).to eq(41.6)
  end

  it "generates subtotal for a percent discount" do
    expect(@cart.subtotal_discount(@pull_toy, 20, @dog_shop.id)).to eq(8.0)
  end

  it "discounts for percentage" do
    merchant_2 = Merchant.create(name: "Not a Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    thing = merchant_2.items.create(name: "Thing", description: "Great thing!", price: 10, image: "thing.jpg", inventory: 3)
    cart_2 = Cart.new({@pull_toy.id.to_s => 1, @dog_bone.id.to_s => 2, thing.id.to_s => 1})

    expect(cart_2.discount_price_percent(20, @dog_shop.id)).to eq({@pull_toy => 8.0, @dog_bone => 16.8, thing => 10})
  end

  it "has merchant items" do
    expect(@cart.has_merchant_items?(@dog_shop.id)).to be true
  end

  it "can calculate subtotals" do
    expect(@cart.subtotal(@pull_toy)).to eq(10)
    expect(@cart.subtotal(@dog_bone)).to eq(42)
  end

  it "can calculate order total" do
    expect(@cart.total).to eq(52)
  end

  it '#items' do
    expect(@cart.items).to eq({@pull_toy => 1, @dog_bone => 2})
  end

  it '#limit_reached?' do
    expect(@cart.limit_reached?(@pull_toy.id)).to be(false)
    @cart = Cart.new({@pull_toy.id.to_s => 3, @dog_bone.id.to_s => 2})
    expect(@cart.limit_reached?(@pull_toy.id)).to be(true)
  end

  it '#quantity_zero?' do
    expect(@cart.quantity_zero?(@pull_toy.id)).to be(false)
    @cart = Cart.new({@pull_toy.id.to_s => 0, @dog_bone.id.to_s => 2})
    expect(@cart.quantity_zero?(@pull_toy.id)).to be(true)
  end
end
