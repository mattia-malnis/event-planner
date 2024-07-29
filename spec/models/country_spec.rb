require "rails_helper"

RSpec.describe Country, type: :model do
  context "associations" do
    it { should have_many(:events) }
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(Country.new(iso: "it", name: "Italy")).to be_valid
    end

    it "is not valid without name" do
      expect(Country.new(iso: "it")).not_to be_valid
    end

    it "is not valid with wrong iso format" do
      expect(Country.new(iso: "i", name: "Italy")).not_to be_valid
      expect(Country.new(iso: "ita", name: "Italy")).not_to be_valid
      expect(Country.new(name: "Italy")).not_to be_valid
    end

    it "is not valid with a non-unique iso" do
      Country.create(iso: "it", name: "Italy")
      expect(Country.new(iso: "it", name: "Italy 2")).not_to be_valid
    end
  end

  context "field normalization" do
    it "normalize iso and name" do
      country = Country.create(iso: " H K ", name: " Hong  Kong ")

      expect(country.iso).to eq("hk")
      expect(country.name).to eq("Hong Kong")
    end
  end
end
