require 'rails_helper'

RSpec.describe SlackController, type: :controller do

  describe "POST #event" do
    describe "URL verification handshake" do
      describe "with a valid request" do
        it "returns the challenge string" do
          ENV["TEST_TOKEN"] = "test_token"

          params = {
            "token": ENV["TEST_TOKEN"],
            "challenge": "test_challenge",
            "type": "url_verification"
          }

          post :event, { params: params }

          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq "application/json"
        end
      end
    end
  end

end
