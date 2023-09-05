require 'rails_helper'

RSpec.describe 'User welcome' do
  before :each do
    @user_1 = User.create!(name: "User1", email: "email1@example.com", password: "password1")
    @user_2 = User.create!(name: "User2", email: "email2@example.com", password: "password2")
    @user_3 = User.create!(name: "User3", email: "email3@example.com", password: "password3")
  end

  describe 'happy path' do
    it 'has a landing page' do
      visit root_path
      
      expect(page).to have_content("Viewing Party")
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content(@user_2.name)
      expect(page).to have_content(@user_3.name)
      expect(page).to have_link("Home")

      click_on 'New User'
      expect(current_path).to eq("/register")
      click_on 'Home'
      expect(current_path).to eq(root_path)

      click_on @user_2.name
      expect(current_path).to eq(user_path(@user_2))
      click_on 'Home'
      expect(current_path).to eq(root_path)
    end

    it 'allows user to log in' do
      visit root_path
      click_on "I already have an account"
      expect(current_path).to eq(login_path)

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password

      click_on "Log In"
    
      expect(current_path).to eq(user_path(@user_1))
    end
  end

  describe "sad path" do
    it "warns for invalid credentials" do
      visit root_path
      click_on "I already have an account"
      expect(current_path).to eq(login_path)

      fill_in :email, with: ""
      fill_in :password, with: @user_1.password

      click_on "Log In"
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  end
end