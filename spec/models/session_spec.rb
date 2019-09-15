require 'rails_helper'

RSpec.describe "sessions" do
    it "show if a user is already logged in" do
        user = create(:user)
        address = create(:address, user: user)

        visit "/login"
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log In"
        visit "/login"

        expect(page).to have_content("Silly pup, you are already logged in!")
        expect(current_path).to eq("/profile")
    end

    it "show if a merchant is already logged in" do
        user = create(:user, role: 2)
        address = create(:address, user: user)

        visit "/login"
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log In"
        visit "/login"

        expect(page).to have_content("Silly pup, you are already logged in!")
        expect(current_path).to eq("/merchant")
    end

    it "show if an admin is already logged in" do
        user = create(:user, role: 4)
        address = create(:address, user: user)

        visit "/login"
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Log In"
        visit "/login"

        expect(page).to have_content("Silly pup, you are already logged in!")
        expect(current_path).to eq("/admin")
    end

    describe "login" do
        it "logs a user in" do
            user = create(:user)
            address = create(:address, user: user)

            visit "/login"
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Log In"

            expect(page).to have_content("Welcome, #{user.name}")
            expect(current_path).to eq("/profile")
        end

        it "logs a merchant in" do
            user = create(:user, role: 2)
            address = create(:address, user: user)

            visit "/login"
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Log In"

            expect(page).to have_content("Welcome, #{user.name}")
            expect(current_path).to eq("/merchant")
        end

        it "logs an admin in" do
            user = create(:user, role: 4)
            address = create(:address, user: user)

            visit "/login"
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Log In"

            expect(page).to have_content("Welcome, #{user.name}")
            expect(current_path).to eq("/admin")
        end

        it "wont logs in with bad credentials" do
            user = create(:user, role: 4)
            address = create(:address, user: user)

            visit "/login"
            fill_in "Email", with: user.email
            fill_in "Password", with: "bad password"
            click_button "Log In"

            expect(page).to have_content("Invalid Email or Password")
            expect(current_path).to eq("/login")
        end
    end

    describe "logout" do
        it "logs a user out" do
            user = create(:user, role: 4)
            address = create(:address, user: user)

            visit "/login"
            fill_in "Email", with: user.email
            fill_in "Password", with: "bad password"
            click_button "Log In"

            visit "/logout"

            expect(page).to have_content("L8r, yo")
            expect(current_path).to eq("/")
        end
    end
end