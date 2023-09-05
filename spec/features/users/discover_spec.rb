require 'rails_helper'

RSpec.describe "Discover Movies" do
  before do
    @user1 = User.create!(name: "Marvin", email: "Marvin@gmail.com", password: "password1")
    @viewing_party1 = @user1.viewing_parties.create!(name: "Marvin's Pulp Fiction Party", movie_title: "Pulp Fiction", host: "Marvin", event_date: "8/22/23", start_time: "1" )
  end

  describe "discover movies show" do
    it "has a button called discover top rated movies" do
      visit discover_user_path(@user1)

      expect(page).to have_button("Discover Top Rated Movies")
    end

    it "has a text field to enter keywords to search by movie title" do
      visit discover_user_path(@user1)

      expect(page).to have_field("Enter Movie Title")
      expect(page).to have_button("Search")
    end
  end
end