require 'rails_helper'

describe 'User logs in and tries to visit /login' do
  it 'Redirects a user to their profile' do
    user = create(:user)
    address = create(:address, user: user)

    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Silly pup, you are already logged in!')
  end

  it 'Redirects a merchant_employee to their merchant dashboard' do
    user = create(:user, role: 2)
    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/merchant')
    expect(page).to have_content('Silly pup, you are already logged in!')

  end

  it 'Redirects a merchant_admin to their merchant dashboard' do
    user = create(:user, role: 3)
    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/merchant')
    expect(page).to have_content('Silly pup, you are already logged in!')

  end

  it 'Redirects an admin to their admin dashboard' do
    user = create(:user, role: 4)
    visit '/login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    within '#login-form' do
      click_on 'Log In'
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/login'

    expect(current_path).to eq('/admin')
    expect(page).to have_content('Silly pup, you are already logged in!')
  end
end
