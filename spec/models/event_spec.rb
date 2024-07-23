require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryBot.create :event }

  context "associations" do
    it { should have_and_belong_to_many(:users) }
  end

  context "validations" do
    # Shoulda matchers alternative:
    # it { should validate_presence_of(:title) }
    # it { should validate_presence_of(:country) }
    # it { should validate_presence_of(:date) }
    # it { should validate_numericality_of(:lat).is_in(-90..90) }
    # it { should validate_numericality_of(:long).is_in(-180..180) }

    it "is valid with valid attributes" do
      expect(event).to be_valid
    end

    it "is not valid without title" do
      event.title = nil
      expect(event).not_to be_valid
    end

    it "is not valid without country" do
      event.country = nil
      expect(event).not_to be_valid
    end

    it "is not valid without date" do
      event.date = nil
      expect(event).not_to be_valid
    end

    it "is not valid with wrong latitude values" do
      event.lat = nil
      expect(event).not_to be_valid
      event.lat = 95
      expect(event).not_to be_valid
      event.lat = -95
      expect(event).not_to be_valid
    end

    it "is not valid with wrong longitude values" do
      event.long = nil
      expect(event).not_to be_valid
      event.long = 190
      expect(event).not_to be_valid
      event.long = -190
      expect(event).not_to be_valid
    end
  end
end
