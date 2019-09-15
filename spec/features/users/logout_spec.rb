require 'rails_helper'

describe "logout user" do
  it "logs them out" do

    user = create(:user)
    address = create(:address, user: user)

    visit '/login'

    within "#login-form" do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log In'
    end

    within ".login-options" do
      click_on "Log Out"
    end
    
    expect(current_path).to eq("/")
    expect(page).to have_content("L8r, yo")
  end
end
