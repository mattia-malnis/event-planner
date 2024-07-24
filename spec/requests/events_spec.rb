require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user) { FactoryBot.create :user }

  describe "GET /index" do
    it "returns http success when user is signed in" do
      sign_in user
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to the user login page when user is not signed in" do
      get root_path
      expect(response).to redirect_to new_user_session_path
    end
  end
end
