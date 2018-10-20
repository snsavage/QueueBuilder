class SlackController < ApplicationController
  SlackEvents = {
    "url_verification": SlackUrlVerification
  }

  def event
    if handshake_approved?
      klass = SlackEvents[params[:type].to_sym]
      result = klass.new(params).execute

      return render json: result.json, status: result.status
    end

    render json: {}, status: :bad_request
  end

  private
  # TODO: Move this to a service object.
  def handshake_approved?
    return false if params[:token] != ENV["SLACK_TOKEN"]
    return false unless !event_type_supported?

    return true
  end

  # TODO: Move this to a service object.
  def event_type_supported?
    return false if type = params[:type]
    SlackEvents.has_key?(type)
  end
end
