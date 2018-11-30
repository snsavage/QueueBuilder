class SlackController < ApplicationController
  protect_from_forgery(
    with: :null_session,
    if: Proc.new {|c| c.request.format.json? }
  )

  SlackEvents = {
    "url_verification": SlackUrlVerification
  }

  def event
    if handshake_approved? && params.has_key?(:type)
      klass = SlackEvents[params[:type].to_sym]

      begin
        result = klass.new(params).execute
        return render json: result.body, status: result.status
      rescue
        # render json: {}, status: :bad_request
      end
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
