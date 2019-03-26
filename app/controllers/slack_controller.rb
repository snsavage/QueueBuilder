class SlackController < ApplicationController
  protect_from_forgery(
    with: :null_session,
    if: Proc.new {|c| c.request.format.json? }
  )

  SLACK_EVENTS = {
    "url_verification": SlackUrlVerification
  }.freeze

  def event
    return render bad_request unless type_valid?(params)

    klass = SLACK_EVENTS[params[:type].to_sym]
    result = klass.new(params).execute

    if result.status == :ok
      render json: result.body, status: result.status
    else
      render bad_request
    end
  end

  private

  def type_valid?(params)
    return false unless params.has_key?(:type)
    return false unless SLACK_EVENTS.has_key?(params[:type].to_sym)

    return true
  end

  def bad_request
    { json: {}, status: :bad_request }
  end

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
