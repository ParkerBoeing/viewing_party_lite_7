require 'rails_helper'

RSpec.describe "Movie details page" do
  before do
    @user1 = User.create!(name: "Marvin", email: "Marvin@gmail.com", password: "password1")
    visit root_path
    click_on "I already have an account"
    expect(current_path).to eq(login_path)

    fill_in :email, with: @user1.email
    fill_in :password, with: @user1.password

    click_on "Log In"
  end

  describe "movie details page" do
    it "displays movie details", :vcr do
      visit user_movies_path(@user1)
      expect(page).to have_link("Parasite")
      click_link "Parasite"

      within "#Movie_details" do
        expect(page).to have_content("Title: Parasite")
        expect(page).to have_content("Vote average: 8.515")
        expect(page).to have_content("Runtime: 2 hours 13 minutes")
        expect(page).to have_content("Genre(s): Comedy, Thriller, Drama")
        expect(page).to have_content("Overview: All unemployed, Ki-taek's family takes")
      end

      within "#Cast_members" do
        expect(page).to have_content("Name: Song Kang-ho")
        expect(page).to have_content("Character: Kim Ki-taek")
        expect(all('p', text: 'Name:').count).to eq(10)
        expect(all('p', text: 'Character:').count).to eq(10)
      end

      within "#Reviews" do
        expect(page).to have_content("Total reviews: 15")
        expect(page).to have_content("Author: SWITCH.")
        expect(page).to have_content("Content: What makes ‘Parasite’ so satisfying is that it commits neither error.")
      end
    end

    it "has a link back to the discover page", :vcr do
      visit user_movies_path(@user1)
 
      expect(page).to have_link("Parasite")
      click_link "Parasite"
      expect(page).to have_link("Discover")
      click_link "Discover"
      expect(current_path).to eq(discover_user_path(@user1))
    end

    it "has a button to create new viewing party", :vcr do
      visit user_movies_path(@user1)
 
      expect(page).to have_link("Parasite")
      click_link "Parasite"
      expect(page).to have_button("New Viewing Party")
      click_button "New Viewing Party"
      expect(current_path).to eq("/users/#{@user1.id}/movies/496243/viewing-party/new")
    end
  end
end

