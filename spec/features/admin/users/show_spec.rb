require 'rails_helper'

describe 'admin users show' do
  before :each do
    @admin = create(:user, role: 4)
    @address = create(:address, user: @admin)
    @user_1 = create(:user)
    @address_2 = create(:address, user: @user_1)

    visit login_path

    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it "I see the user profile" do
    visit "/admin/users/#{@user_1.id}"

    within '.user-profile' do
      expect(current_path).to eq("/admin/users/#{@user_1.id}")

      expect(page).to have_content("#{@user_1.name}'s Profile")
      expect(page).to have_content("#{@address_2.address}")
      expect(page).to have_content("#{@address_2.city}, #{@address_2.state} #{@address_2.zip}")
      expect(page).to have_content("Email: #{@user_1.email}")

      expect(page).to_not have_link('Edit Profile')
      expect(page).to_not have_link('Change Password')
    end
  end
end
