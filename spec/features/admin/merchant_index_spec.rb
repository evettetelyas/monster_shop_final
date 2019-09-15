require 'rails_helper'

describe 'merchant index as an admin' do
  before :each do
    @merchant_1 = create(:merchant, status: 0)
    @merchant_2 = create(:merchant, status: 0)
    @merchant_3 = create(:merchant, status: 1)
    @item = create(:item, merchant_id: @merchant_1.id)
    @merchants = [@merchant_1,@merchant_2,@merchant_3]
    @user = create(:user)
    address = create(:address, user: @user)
    @admin = create(:user, role: 4)
    admin_addy = create(:address, user: @admin)

    visit login_path

    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it "merchant info is shown and namex are links to namespaced admin merchant show page" do

    @merchants.each do |merchant|
      visit '/merchants'

      within "#merchant-#{merchant.id}" do
        expect(page).to have_link(merchant.name)
        expect(page).to have_content(merchant.city)
        expect(page).to have_content(merchant.state)
        expect(page).to have_content(merchant.status)

        click_link(merchant.name)

        expect(current_path).to eq("/admin/merchants/#{merchant.id}")
      end
    end
  end

  it "merchants can be enabled and disabled " do
    visit '/merchants'

    within "#merchant-#{@merchant_1.id}" do
      expect(page).to have_link('Disable')

      click_link 'Disable'

      expect(current_path).to eq('/merchants')
      expect(page).to_not have_link('Disable')
    end

    expect(page).to have_content("#{@merchant_1.name} has been disabled")

    within "#merchant-#{@merchant_1.id}" do
      expect(page).to have_link('Enable')

      click_link 'Enable'
    end

    expect(page).to have_content("#{@merchant_1.name} has been enabled")
  end

  it "Other users do not have access to this functionality" do
    click_on 'Log Out'

    visit login_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    within '#login-form' do
      click_on 'Log In'
    end

    visit '/merchants'

    click_link(@merchant_1.name)

    expect(current_path).to eq("/merchants/#{@merchant_1.id}")

    visit '/merchants'

    expect(page).to_not have_link('Disable')
  end

  it "All of a merchants items are disabled if the merchant is disabled" do
    visit '/merchants'

    within "#merchant-#{@merchant_1.id}" do
      click_link 'Disable'
    end

    visit '/items'

    expect(page).to_not have_content("#{@item.name}")
  end
end
