require "rails_helper"

RSpec.describe User, type: :model do
  describe "relationships" do
    it { should have_many :user_viewing_parties}
    it { should have_many(:viewing_parties).through(:user_viewing_parties) }
  end

  describe "validations" do
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of(:email)}
    it {should validate_presence_of(:password)}
    it {should validate_presence_of(:name)}

    it "properly stores passwords" do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password123')
    end
  end
end