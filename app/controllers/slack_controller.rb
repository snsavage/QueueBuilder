class SlackController < ApplicationController
  SlackEvents = {
    url_verification: :url_verification
  }

  def event
    render json: {none: :none}, status: 400
  end

  private
  def handshake_approved?
    return false if params[:token] != ENV["SLACK_TOKEN"]
    return false unless !event_type_supported?

    return true
  end

  def event_type_supported?
    return false if type = params[:type]
    SlackEvents.has_key?(type)
  end

  def signature_valid?
  end
end
