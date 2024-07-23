require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }

  context "Validates using fixtures" do
    it "is valid with email and password" do
      expect(user).to be_valid
    end

    it "is not valid without email" do
      user.email = nil
      expect(user).not_to be_valid
    end
  end
end
