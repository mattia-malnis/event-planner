require 'rails_helper'

RSpec.describe "Documentations", type: :request do
  let(:user) { FactoryBot.create :user }

  describe "GET /documentation" do
    it "returns http success when user is logged in" do
      sign_in user
      get documentation_path
      expect(response).to have_http_status(:success)
    end
  end
end
