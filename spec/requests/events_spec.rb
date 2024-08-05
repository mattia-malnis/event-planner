require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user) { FactoryBot.create :user }

  describe "GET /" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "filters events correctly" do
        past_event = FactoryBot.create(:event, date_start: 1.day.ago)
        future_event = FactoryBot.create(:event, date_start: 1.day.from_now)

        get root_path(filter: 'past')
        expect(assigns(:events)).to include(past_event)
        expect(assigns(:events)).not_to include(future_event)

        get root_path(filter: 'upcoming')
        expect(assigns(:events)).to include(future_event)
        expect(assigns(:events)).not_to include(past_event)
      end
    end

    context "when user is not signed in" do
      it "redirects to the login page" do
        get root_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /events/subscribed" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns http success" do
        get subscribed_events_path
        expect(response).to have_http_status(:success)
      end

      it "filters events correctly" do
        past_event = FactoryBot.create(:event, date_start: 1.day.ago)
        future_event = FactoryBot.create(:event, date_start: 1.day.from_now)
        user.events << past_event
        user.events << future_event
        other_user = FactoryBot.create(:user)
        other_event = FactoryBot.create(:event, date_start: 1.day.from_now)
        other_user.events << other_event

        get subscribed_events_path(filter: 'past')
        expect(assigns(:events)).to include(past_event)
        expect(assigns(:events)).not_to include(future_event)
        expect(assigns(:events)).not_to include(other_event)

        get subscribed_events_path(filter: 'upcoming')
        expect(assigns(:events)).to include(future_event)
        expect(assigns(:events)).not_to include(past_event)
        expect(assigns(:events)).not_to include(other_event)
      end
    end

    context "when user is not signed in" do
      it "redirects to the login page" do
        get subscribed_events_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /events/:id" do
    let(:event) { create(:event) }

    context "when user is signed in" do
      before { sign_in user }

      it "returns http success for existing event" do
        get event_path(event)
        expect(response).to have_http_status(:success)
      end

      it "returns http not found for non-existent event" do
        get event_path(id: 999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when user is not signed in" do
      it "redirects to the login page" do
        get event_path(event)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
