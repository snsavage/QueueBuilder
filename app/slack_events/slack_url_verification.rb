class SlackUrlVerification
  attr_reader :params

  TYPE = 'url_verification'.freeze
  CONTENT_TYPE = "application/json".freeze

  def initialize(params, event_response = EventResponse, error = ArgumentError)
    @params = params
    @event_response = event_response
  end

  def execute
    if params_valid? && params[:token] == ENV["SLACK_TOKEN"]
      body = {"challenge": params[:challenge]}.to_json
      success_response(body)
    else
      error_response
    end
  end

  def unexecute
    raise NotImplementedError.new(
      "SlackUrlVerification does not implement unexecute"
    )
  end

  private

  def params_valid?
    return false unless params.has_key?(:type)
    return false unless params.has_key?(:token)
    return false unless params.has_key?(:challenge)
    return false unless params[:type] == TYPE

    return true
  end

  def success_response(body)
    @event_response.new(
      status: :ok,
      content_type: CONTENT_TYPE,
      body: body
    )
  end

  def error_response
    @event_response.new(
      status: :bad_request,
      content_type: CONTENT_TYPE,
      body: {}.to_json
    )
  end
end
