require 'rails_helper'

describe 'user clicks login' do
  it "logs them in" do

    user = create(:user)
    address = create(:address, user: user)

    visit '/'

    within ".login-options" do
      click_link('Log In')
    end

    expect(current_path).to eq('/login')

    within "#login-form" do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log In'
    end

    expect(current_path).to eq('/profile')
    expect(page).to have_content(user.name)
  end

  it "won't log in with bad email" do
    user = create(:user)

    visit '/login'

    within "#login-form" do
      fill_in 'Email', with: 'bad_email'
      fill_in 'Password', with: user.password
      click_on 'Log In'
    end

    expect(current_path).to eq('/login')
    expect(page).to have_content("Invalid Email or Password")
  end

  it "won't log in with bad password" do
    user = create(:user)
    address = create(:address, user: user)

    visit '/login'

    within "#login-form" do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'bad_password'
      click_on 'Log In'
    end

    expect(current_path).to eq('/login')
    expect(page).to have_content("Invalid Email or Password")
  end
end
