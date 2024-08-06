require 'rails_helper'

RSpec.describe EventImageProcessingJob, type: :job do
  describe ".perform" do
    let(:event) { create(:event) }

    it "calls attach_image_from_url on the event" do
      expect_any_instance_of(Event).to receive(:attach_image_from_url)
      EventImageProcessingJob.perform_now(event.id)
    end

    context "when event is not found" do
      it "logs an error" do
        expect(Rails.logger).to receive(:error).with("Event with ID 0 not found")
        EventImageProcessingJob.perform_now(0)
      end
    end
  end
end
