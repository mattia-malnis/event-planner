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

  describe "signed_up_for_event?(event)" do
    it "is true when a user is subscribed to an event" do
      event = FactoryBot.create :event
      user.events << event
      expect(user.signed_up_for_event?(event)).to be_truthy
    end
  end

  describe "toggle_event!(event)" do
    it "subscribe user to an event" do
      event = FactoryBot.create :event
      user.toggle_event!(event)
      expect(user.events).to include(event)
    end

    it "unsubscribe user from an event" do
      event = FactoryBot.create :event
      user.events << event
      user.toggle_event!(event)
      expect(user.events).not_to include(event)
    end
  end
end
