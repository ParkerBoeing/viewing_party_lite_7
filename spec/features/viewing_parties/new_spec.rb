require 'rails_helper'

RSpec.describe 'New Viewing Party' do
  before :each do
    @user_1 = User.create!(name: "User1", email: "email1@example.com", password: "password1")
  end
  describe 'happy path' do
    it 'can create a new viewing party', :vcr do
      visit root_path
      click_on "I already have an account"
      expect(current_path).to eq(login_path)

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password

      click_on "Log In"

      visit user_movies_path(@user_1)
      expect(page).to have_link("Parasite")
      click_link "Parasite"
      expect(page).to have_button("New Viewing Party")
      click_button "New Viewing Party"
      fill_in :duration, with: 240
      fill_in :event_date, with: "2024-05-09"
      fill_in :start_time, with: "1:30 PM"
      fill_in :name, with: "Super Mega Ultra Party"

      click_button "Create"
      expect(current_path).to eq("/users/#{@user_1.id}/movies/496243/viewing-party/new")
      expect(page).to have_content("Viewing party successfully created! Now it's time to invite your friends!")
    end

    it 'can invite other users to viewing party', :vcr do
      @user_2 = User.create!(name: "User2", email: "email2@example.com", password: "password2")
      @user_3 = User.create!(name: "User3", email: "email3@example.com", password: "password3")
      @user_4 = User.create!(name: "User4", email: "email4@example.com", password: "password4")
      visit root_path
      click_on "I already have an account"
      expect(current_path).to eq(login_path)

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_on "Log In"
      
      visit user_path(@user_1)
      expect(page).to_not have_content("Super Mega Ultra Party")
      expect(page).to_not have_content(@user_2.name)
      expect(page).to_not have_content(@user_3.name)

      visit user_movies_path(@user_1)
      expect(page).to have_link("Parasite")
      click_link "Parasite"
      expect(page).to have_button("New Viewing Party")
      click_button "New Viewing Party"

      fill_in :duration, with: 240
      fill_in :event_date, with: "2024-05-09"
      fill_in :start_time, with: "1:30 PM"
      fill_in :name, with: "Super Mega Ultra Party"
      click_button "Create"

      within "##{@user_2.id}" do
        check("user_ids[]")
      end
      within "##{@user_3.id}" do
        check("user_ids[]")
      end

      click_button "Invite"

      expect(current_path).to eq(user_path(@user_1))

      expect(page).to have_content("Super Mega Ultra Party")
      expect(page).to have_content(@user_2.name)
      expect(page).to have_content(@user_3.name)
    end
  end

  describe 'sad path' do
    it 'will display an error message if movie runtime > viewing party duration', :vcr do
      visit root_path
      click_on "I already have an account"
      expect(current_path).to eq(login_path)

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_on "Log In"
      visit user_movies_path(@user_1)
 
      expect(page).to have_link("Parasite")
      click_link "Parasite"
      expect(page).to have_button("New Viewing Party")
      click_button "New Viewing Party"
      fill_in :duration, with: 45
      fill_in :event_date, with: "2024-05-09"
      fill_in :start_time, with: "1:30 PM"
      fill_in :name, with: "Super Mega Ultra Party"

      click_button "Create"
      expect(current_path).to eq("/users/#{@user_1.id}/movies/496243/viewing-party/new")
      expect(page).to have_content("Creation unsuccessful. Your viewing party can't take less time than the movie!")
    end

    it 'now allow user to create new viewing party if not logged in', :vcr do
      visit user_movies_path(@user_1)
 
      expect(page).to have_link("Parasite")
      click_link "Parasite"
      expect(page).to have_button("New Viewing Party")
      click_button "New Viewing Party"

      expect(current_path).to eq("/users/#{@user_1.id}/movies/496243")
      expect(page).to have_content("Must be logged in to create a new viewing party.")
    end
  end
end