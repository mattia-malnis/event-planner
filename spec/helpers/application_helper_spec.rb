require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe ".alert_error" do
    it "returns an alert with title and message" do
      result = helper.alert_error("Alert message", "Title")
      expect(result).to include("Title")
      expect(result).to include("Alert message")
      expect(result).to have_css("div.bg-red-100")
      expect(result).to have_css("p.font-bold", text: "Title")
    end

    it "returns an alert without a title" do
      result = helper.alert_error("Alert message")
      expect(result).to include("Alert message")
      expect(result).not_to have_css("p.font-bold")
    end

    it "joins array messages with <br>" do
      result = helper.alert_error([ "Message 1", "Message 2" ])
      expect(result).to include("Message 1<br>Message 2")
    end

    it "returns nil if messages are blank" do
      expect(helper.alert_error(nil)).to be_nil
      expect(helper.alert_error("")).to be_nil
      expect(helper.alert_error([])).to be_nil
    end
  end

  describe ".to_date" do
    it "returns a formatted date" do
      expect(helper.to_date(Date.new(2024, 7, 30))).to eq("Jul 30, 2024")
    end

    it "returns nil if date is nil" do
      expect(helper.to_date(nil)).to be_nil
    end
  end

  describe ".to_datetime" do
    it "returns a formatted date" do
      expect(helper.to_datetime(DateTime.new(2024, 8, 1, 12, 30))).to eq("Thu, 01 Aug 2024, 12:30")
    end

    it "returns nil if date is nil" do
      expect(helper.to_datetime(nil)).to be_nil
    end
  end

  describe ".back_or_default" do
    it "returns session[:return_to] if present" do
      session[:return_to] = "/custom_path"
      expect(helper.back_or_default("/default")).to eq("/custom_path")
    end

    it "returns default if session[:return_to] is not present" do
      session[:return_to] = nil
      expect(helper.back_or_default("/default")).to eq("/default")
    end
  end

  describe ".menu_item" do
    before do
      allow(helper).to receive(:controller_name).and_return("users")
      allow(helper).to receive(:action_name).and_return("index")
    end

    it "returns a menu item with correct classes when active" do
      result = helper.menu_item("Users", "/users", [ "users" ])
      expect(result).to have_css("li a.text-indigo-600")
      expect(result).to have_content("Users")
    end

    it "returns a menu item without active class when not active" do
      result = helper.menu_item("Posts", "/posts", [ "posts" ])
      expect(result).not_to have_css("li a.text-indigo-600")
      expect(result).to have_content("Posts")
    end

    it "considers both controller and action for active state" do
      result = helper.menu_item("New User", "/users/new", [ "users" ], [ "new" ])
      expect(result).not_to have_css("li a.text-indigo-600")
    end
  end

  describe ".active_menu?" do
    before do
      allow(helper).to receive(:controller_name).and_return("users")
      allow(helper).to receive(:action_name).and_return("index")
    end

    it "returns true when controller matches" do
      expect(helper.send(:active_menu?, [ "users" ])).to be_truthy
    end

    it "returns false when controller doesn't match" do
      expect(helper.send(:active_menu?, [ "posts" ])).to be_falsy
    end

    it "returns true when controller and action match" do
      expect(helper.send(:active_menu?, [ "users" ], [ "index" ])).to be_truthy
    end

    it "returns false when controller matches but action doesn't" do
      expect(helper.send(:active_menu?, [ "users" ], [ "new" ])).to be_falsy
    end

    it "returns false when both controllers and actions are empty" do
      expect(helper.send(:active_menu?, [], [])).to be_falsy
    end
  end
end
