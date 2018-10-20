require 'rails_helper'

RSpec.describe SlackController, type: :controller do
  describe "POST #event" do
    describe "URL verification handshake" do
      describe "with a valid request" do
        before(:each) do
          ENV["SLACK_TOKEN"] = "test_token"

          @params = {
            "token": ENV["SLACK_TOKEN"],
            "challenge": "test_challenge",
            "type": "url_verification"
          }
        end

        it "creates a new Slack command class and calls execute" do
          post :event, { params: @params }

          expect(SlackUrlVerification).to have_received(:new)
          expect(instance).to have_received(:execute)
        end

        it "renders the command instance response" do
          post :event, { params: @params }

          expect(response).to have_http_status(:success)
          expect(response.content_type).to eq "application/json"
          expect(response.body).to eq(@params[:challenge].to_json)
        end
      end

      describe "with an invalid request" do
        describe "with an invalid token" do
          it "returns a 400 status" do
            ENV["SLACK_TOKEN"] = "test_token"

            params = {
              "token": "invalid token",
              "challenge": "test_challenge",
              "type": "url_verification"
            }

            post :event, { params: params }

            expect(response).to have_http_status(:bad_request)
          end
        end

        describe "without a challenge param" do
          it "returns a 400 status" do
            ENV["SLACK_TOKEN"] = "test_token"

            params = {
              "token": ENV["SLACK_TOKEN"],
              "type": "url_verification"
            }

            post :event, { params: params }

            expect(response).to have_http_status(:bad_request)
          end
        end

        describe "with an invalid type " do
          it "returns a 400 status" do
            ENV["SLACK_TOKEN"] = "test_token"

            params = {
              "token": ENV["SLACK_TOKEN"],
              "challenge": "test_challenge",
              "type": "invalid_type"
            }

            post :event, { params: params }

            expect(response).to have_http_status(:bad_request)
          end
        end
      end
    end
  end
end
