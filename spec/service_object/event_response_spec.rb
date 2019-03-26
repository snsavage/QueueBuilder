require 'rails_helper'

RSpec.describe EventResponse do
  describe "#initialize" do
    let(:response_data) {
      {
        body: "test body",
        content_type: "content type",
        status: :ok
      }
    }

    describe "default values" do
      it ".body defaults to an empty hash" do
        expect(EventResponse.new.body).to eq({})
      end

      it ".content_type defaults to application/json" do
        expect(EventResponse.new.content_type).to eq("application/json")
      end

      it ".status defaults to 400 :bad_request" do
        expect(EventResponse.new.status).to eq(:bad_request)
      end
    end

    describe "arguments override defaults" do
      let(:event) { EventResponse.new(**response_data) }

      it "sets body" do
        expect(event.body).to eq(response_data[:body])
      end

      it "sets content_type" do
        expect(event.content_type).to eq(response_data[:content_type])
      end

      it "sets status" do
        expect(event.status).to eq(response_data[:status])
      end
    end

    describe "status parameter" do
      it "raises ArgumentError if not contained in HTTP status codes" do
        invalid_status_code = { status: :invalid_status_code }

        error_message = "EventResponse.status to be contained " +
          "in Rack::Utils::HTTP_STATUS_CODES"

        expect {
          EventResponse.new(**invalid_status_code)
        }.to raise_error(ArgumentError, error_message)
      end
    end
  end
end
