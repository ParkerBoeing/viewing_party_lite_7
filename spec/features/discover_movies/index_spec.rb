require 'rails_helper'

RSpec.describe "Movie results page" do
  before do
    @user1 = User.create!(name: "Marvin", email: "Marvin@gmail.com", password: "password1")
  end

  describe "movie results page" do
    it "each movie title is a link to the details page", :vcr do
      visit user_movies_path(@user1)
 
      expect(page).to have_link("Parasite")
      click_link "Parasite"

      expect(current_path).to eq("/users/#{@user1.id}/movies/496243")
    end

    it "displays 20 top rated movies", :vcr do
      visit discover_user_path(@user1)
      click_button("Discover Top Rated Movies")
      expect(page).to have_content("Title: The Godfather")
      expect("The Godfather").to appear_before("The Shawshank Redemption")
      
      expect(all('p', text: 'Title:').count).to eq(20)
    end

    it "displays searched for movies", :vcr do
      visit discover_user_path(@user1)
      fill_in :search, with: "Nemo"

      click_button "Search"

      expect(page).to have_content("Finding Nemo")
      expect(page).to have_content("Captain Nemo")
      expect(all('p', text: 'Title:').count).to be <= 20
    end

    it "has a link back to the discover page", :vcr do
      visit user_movies_path(@user1)
 
      expect(page).to have_link("Discover")
      click_link "Discover"
      expect(current_path).to eq(discover_user_path(@user1))
    end
  end
end