require 'rails_helper'

describe 'admin dashboard' do
  before :each do
    @admin = create(:user, role: 4)
    user = create(:user)
    @order_1 = create(:order, user: user, status: 0)
    @order_2 = create(:order, user: user, status: 1)
    @order_3 = create(:order, user: user, status: 2)
    @order_4 = create(:order, user: user, status: 3)

    visit login_path

    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it "admin can see all orders in the system" do
    visit "/admin"

    within "#pending-order-#{@order_1.id}" do
      expect(page).to have_content(@order_1.address.name)
      expect(page).to have_link("Order ##{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime('%D'))
    end

    within "#packaged-order-#{@order_2.id}" do
      expect(page).to have_content(@order_2.address.name)
      expect(page).to have_link("Order ##{@order_2.id}")
      expect(page).to have_content(@order_2.created_at.strftime('%D'))
    end

    within "#shipped-order-#{@order_3.id}" do
      expect(page).to have_content(@order_3.address.name)
      expect(page).to have_link("Order ##{@order_3.id}")
      expect(page).to have_content(@order_3.created_at.strftime('%D'))
    end

    within "#cancelled-order-#{@order_4.id}" do
      expect(page).to have_content(@order_4.address.name)
      expect(page).to have_link("Order ##{@order_4.id}")
      expect(page).to have_content(@order_4.created_at.strftime('%D'))
    end
  end
end
