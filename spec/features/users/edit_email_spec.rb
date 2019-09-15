require 'rails_helper'

# As a registered user
# When I attempt to edit my profile data
# If I try to change my email address to one that belongs to another user
# When I submit the form
# Then I am returned to the profile edit page
# And I see a flash message telling me that email address is already in use

describe 'User edits their profile' do
  it 'Cannot use an email of a user who already registered' do
    bob = create(:user, email: 'bob@email.com')
    bob_add = create(:address, user: bob)
    bob_2 = create(:user)
    bob_2_add = create(:address, user: bob_2)

    visit '/login'

    within "#login-form" do
      fill_in 'Email', with: bob_2.email
      fill_in 'Password', with: bob_2.password
      click_on 'Log In'
    end

    click_link 'Edit Profile'

    fill_in 'Email', with: bob.email

    click_on('Update Profile')

    expect(current_path).to eq(profile_edit_path)
    expect(page).to have_content('Email has already been taken')
  end
end
