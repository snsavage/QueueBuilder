require 'rails_helper'

RSpec.describe SlackUrlVerification do
  ENV["SLACK_TOKEN"] = "test_token"

  let(:params) {
    {
      token: ENV["SLACK_TOKEN"],
      challenge: "test_challenge",
      type: "url_verification"
    }
  }

  describe "#initialize" do
    let(:error) { ArgumentError }

    it "sets a params attributes" do
      command = SlackUrlVerification.new(params)
      expect(command.params).to eq(params)
    end

  end

  describe ".execute" do
    describe "with a valid token" do
      let(:slack_url_verification) {
        SlackUrlVerification.new(params)
      }

      it "returns an EventResponse object" do
        expect(slack_url_verification.execute).to be_a(EventResponse)
      end

      it "returns an EventResponse with 200 Ok status" do
        status = slack_url_verification.execute.status

        expect(status).to eq(:ok)
      end

      it "returns an EventResponse with application/json content type" do
        content_type = slack_url_verification.execute.content_type

        expect(content_type).to eq("application/json")
      end

      it "returns an EventResponse with the challenge key" do
        body = slack_url_verification.execute.body

        expect(body).to eq({"challenge": params[:challenge]}.to_json)
      end
    end

    describe("with missing params keys") do
      it "requires a 'url_verification' type" do
        params[:type] = 'not_url_vertification'

        expect(
          SlackUrlVerification.new(params).execute.status
        ).to be(:bad_request)
      end

      it "requires a type" do
        params.delete(:type)

        expect(
          SlackUrlVerification.new(params).execute.status
        ).to be(:bad_request)
      end

      it "requires a token" do
        params.delete(:token)

        expect(
          SlackUrlVerification.new(params).execute.status
        ).to be(:bad_request)
      end

      it "requires a challenge" do
        params.delete(:challenge)

        expect(
          SlackUrlVerification.new(params).execute.status
        ).to be(:bad_request)
      end
    end

    describe "with a properly formed invalid token" do
      let(:invalid_token) {
        {
          token: "invalid_token",
          challenge: "test_challenge",
          type: "url_verification"
        }
      }

      it "returns an EventResponse with a 400 Bad Request status" do
        status = SlackUrlVerification.new(invalid_token).execute.status

        expect(status).to eq(:bad_request)
      end

      it "returns an EventResponse with application/json content type" do
        content_type = SlackUrlVerification
          .new(invalid_token)
          .execute
          .content_type

        expect(content_type).to eq("application/json")
      end

      it "returns an EventResponse with a an empty JSON object body" do
        body = SlackUrlVerification
          .new(invalid_token)
          .execute
          .body

        expect(body).to eq({}.to_json)
      end
    end
  end

  describe ".unexecute" do
    it "raises a NotImplementedError" do
      message = "SlackUrlVerification does not implement unexecute"

      expect {
        SlackUrlVerification.new(params).unexecute
      }.to raise_error(NotImplementedError, message)
    end
  end
end
