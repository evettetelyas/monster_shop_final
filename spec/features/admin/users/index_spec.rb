require 'rails_helper'

describe 'admin users index' do
  before :each do
    @admin = create(:user, role: 4)
    address = create(:address, user: @admin)
    @user_1 = create(:user)
    address_1 = create(:address, user: @user_1)
    @user_2 = create(:user, role: 2)
    address_2 = create(:address, user: @user_2)
    @user_3 = create(:user, role: 3)
    address_3 = create(:address, user: @user_3)
    @users = [@user_1,@user_2,@user_3]

    visit login_path

    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password

    within '#login-form' do
      click_on 'Log In'
    end
  end

  it "I see all users in the system" do
    within ".topnav" do
      click_on 'Users'
    end

    expect(current_path).to eq('/admin/users')

    @users.each do |user|
      within ".topnav" do
        click_on 'Users'
      end

      within "#user-#{user.id}" do
        expect(page).to have_content(user.role)
        expect(page).to have_content(user.created_at.strftime('%D'))
        expect(page).to have_link(user.name)

        click_link(user.name)

        expect(current_path).to eq("/admin/users/#{user.id}")
      end
    end
  end

  it "other users cannot access this page" do
    click_on 'Log Out'

    visit login_path

    fill_in 'Email', with: @user_1.email
    fill_in 'Password', with: @user_1.password

    within '#login-form' do
      click_on 'Log In'
    end

    within ".topnav" do
      expect(page).to_not have_content('users')
    end
  end
end
