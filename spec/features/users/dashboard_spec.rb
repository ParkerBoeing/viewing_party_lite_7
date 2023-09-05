require 'rails_helper'

RSpec.describe "User Dashboard" do
  describe "user dashboard show" do
    before do
      @user1 = User.create!(name: "Marvin", email: "Marvin@gmail.com", password: "password1")
      @user2 = User.create!(name: "Vincent", email: "VincentVega@gmail.com", password: "password2")
      @viewing_party1 = @user1.viewing_parties.create!(name: "Marvin's Pulp Fiction Party", movie_title: "Pulp Fiction", host: "Marvin", event_date: "2023-08-28", start_time: "1:00 AM" )
      @viewing_party2 = @user2.viewing_parties.create!(name: "Vincent's 5 Dollar Shake Party", movie_title: "Shake it", host: "Vincent", event_date: "2023-08-29", start_time: "2:00 PM" )
      @viewing_party3 = @user2.viewing_parties.create!(name: "Butch's Watch Polishing Party", movie_title: "Watches a Documentary", host: "Vincent", event_date: "2023-08-23", start_time: "3:00 AM" )
      @user1.viewing_parties << @viewing_party2
      @user1.viewing_parties << @viewing_party3
    end

    it "displays the users name at the top of the page" do
      visit user_path(@user1)
      expect(page).to have_content("#{@user1.name}'s Dashboard")
      expect(page).to have_button("Discover Movies")
      expect(page).to have_content(@viewing_party1.name)
    end

    it "redirects me to users discover page when I click discover movies button" do
      visit user_path(@user1)

      click_button "Discover Movies"

      expect(current_path).to eq(discover_user_path(@user1))
    end

    it "each movie title is a link to the details page", :vcr do
      visit user_path(@user1)

      expect(page).to_not have_link("Parasite")

      visit user_movies_path(@user1)

      click_link "Parasite"

      expect(page).to have_button("New Viewing Party")

      click_button "New Viewing Party"
      fill_in :duration, with: 240
      fill_in :event_date, with: "2024-05-09"
      fill_in :start_time, with: "1:30 PM"
      fill_in :name, with: "Super Mega Ultra Party"
      click_button "Create"
      within "##{@user2.id}" do
        check("user_ids[]")
      end

      click_button "Invite"

      visit user_path(@user1)
      
      expect(page).to have_link("Parasite")
    end

    it "displays the viewing parties that the user has been invited to and created" do
      visit user_path(@user1)

      viewing_parties = [@viewing_party1, @viewing_party2, @viewing_party3]

      viewing_parties.each do |party|
        expect(page).to have_content(party.movie_title)
        expect(page).to have_content(party.event_date.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(party.start_time)
        expect(page).to have_content(party.host)

        party.users.each do |user|
          expect(page).to have_content(user.name)
        end
      end
    end
  end

  describe "Movie poster image links" do
    it "displays a movie poster image for each viewing party", :vcr do
      @user1 = User.create!(name: "Marvin", email: "Marvin@gmail.com", password: "password1")
      @user_2 = User.create!(name: "User2", email: "email2@example.com", password: "password2")
      @user_3 = User.create!(name: "User3", email: "email3@example.com", password: "password3")
      @user_4 = User.create!(name: "User4", email: "email4@example.com", password: "password4")
      visit user_path(@user1)
      expect(page).to_not have_selector("img[alt='Movie poster']")
      expect(page).to_not have_selector("img")
      
      visit user_movies_path(@user1)
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

      expect(page).to have_selector("img[alt='Movie poster']")
      expect(page).to have_selector("img")
    end
  end
end