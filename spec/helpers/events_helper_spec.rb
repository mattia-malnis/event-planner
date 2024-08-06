require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do
  describe ".temp_details" do
    it "returns temperature and humidity when all parameters are present" do
      expect(helper.temp_details(30, 20, 25)).to eq("Temperature: 20°C to 25°C, Humidity: 30%")
    end

    it "returns only temperature when humidity is not present" do
      expect(helper.temp_details(nil, 22, 28)).to eq("Temperature: 22°C to 28°C")
    end

    it "returns only humidity when temperature is not present" do
      expect(helper.temp_details(45, nil, nil)).to eq("Humidity: 45%")
    end

    it "returns an empty string when no parameters are present" do
      expect(helper.temp_details(nil, nil, nil)).to eq("")
    end
  end

  describe ".date" do
    let(:event) { build_stubbed(:event) }

    before do
      # isolate `to_datetime` and test its functionality on Application helper
      allow(helper).to receive(:to_datetime).and_return("Formatted datetime")
    end

    it "returns formatted start and end dates" do
      expect(helper.date(event)).to eq("Formatted datetime<br>Formatted datetime")
    end

    it "returns nil if event is blank" do
      expect(helper.date(nil)).to be_nil
    end
  end

  describe ".action_button" do
    let(:event) { build_stubbed(:event) }
    let(:current_user) { build_stubbed(:user) }

    before do
      allow(helper).to receive(:current_user).and_return(current_user)
      allow(event).to receive(:open_for_registration?).and_return(true)
    end

    it "returns sign up button if user is not signed up" do
      allow(current_user).to receive(:signed_up_for_event?).with(event).and_return(false)
      expect(helper.action_button(event)).to include("Sign Up Now")
    end

    it "returns cancel registration button if user is signed up" do
      allow(current_user).to receive(:signed_up_for_event?).with(event).and_return(true)
      expect(helper.action_button(event)).to include("Cancel registration")
    end

    it "returns nil if event is not open for registration" do
      allow(event).to receive(:open_for_registration?).and_return(false)
      expect(helper.action_button(event)).to be_nil
    end
  end
end
