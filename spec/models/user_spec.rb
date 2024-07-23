require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }

  context "associations" do
    it { should have_and_belong_to_many(:events) }
  end

  context "validations" do
    # Shoulda matchers alternative:
    # it { should validate_presence_of(:email) }
    # it { should validate_presence_of(:password) }

    it "is valid with email and password" do
      expect(user).to be_valid
    end

    it "is not valid without email" do
      user.email = nil
      expect(user).not_to be_valid
    end
  end
end
