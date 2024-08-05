require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { FactoryBot.create :event }

  context "associations" do
    it { should have_and_belong_to_many(:users) }
    it { should belong_to(:country) }

    it "can have many users" do
      user1 = FactoryBot.create :user
      user2 = FactoryBot.create :user
      event.users << user1
      event.users << user2

      expect(event.users).to include(user1, user2)
    end
  end

  context "validations" do
    # Shoulda matchers alternative:
    # it { should validate_presence_of(:title) }
    # it { should validate_presence_of(:country) }
    # it { should validate_presence_of(:city) }
    # it { should validate_presence_of(:date_start) }
    # it { should validate_numericality_of(:lat).is_in(-90..90) }
    # it { should validate_numericality_of(:long).is_in(-180..180) }

    it "is valid with valid attributes" do
      expect(event).to be_valid
    end

    it "is valid with valid dates" do
      event.date_start = nil
      expect(event).not_to be_valid

      event.date_start = 1.day.from_now
      event.date_end = DateTime.now
      expect(event).not_to be_valid

      event.date_start = DateTime.now
      event.date_end = 1.day.from_now
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

    it "is not valid without city" do
      event.city = nil
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

  describe "scopes" do
    let!(:past_event) { FactoryBot.create(:event, date_start: 1.day.ago) }
    let!(:future_event) { FactoryBot.create(:event, date_start: 1.day.from_now) }
    let!(:another_future_event) { FactoryBot.create(:event, date_start: 2.days.from_now) }

    describe ".upcoming" do
      it "returns events with start date in the future" do
        expect(Event.upcoming).to contain_exactly(future_event, another_future_event)
      end

      it "does not return events with start date in the past" do
        expect(Event.upcoming).not_to include(past_event)
      end
    end

    describe ".past" do
      it "returns events with start date in the past" do
        expect(Event.past).to contain_exactly(past_event)
      end

      it "does not return events with start date in the future" do
        expect(Event.past).not_to include(future_event, another_future_event)
      end
    end

    describe ".ordered" do
      it "returns events ordered by date" do
        expect(Event.ordered).to eq([ past_event, future_event, another_future_event ])
      end
    end
  end
end
