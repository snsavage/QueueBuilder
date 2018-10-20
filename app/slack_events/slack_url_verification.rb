class SlackUrlVerification
  attr_reader :params

  TYPE = 'url_verification'.freeze

  def initialize(params, event_response = EventResponse, error = ArgumentError)
    @params = params
    @event_response = event_response

    raise error.new("missing slack event type") unless params.has_key?(:type)
    raise error.new("missing slack event token") unless params.has_key?(:token)
    raise error.new("missing slack event challenge") \
      unless params.has_key?(:challenge)
    raise error.new("invalid slack event type") if params[:type] != TYPE
  end

  def execute
    content_type = "application/json"

    if params[:token] == ENV["SLACK_TOKEN"]
      body = {"challenge": params[:challenge]}.to_json
      EventResponse.new(
        status: :ok,
        content_type: content_type,
        body: body
      )
    else
      EventResponse.new(
        status: :bad_request,
        content_type: content_type,
        body: {}.to_json
      )
    end
  end

  def unexecute
    raise NotImplementedError.new(
      "SlackUrlVerification does not implement unexecute"
    )
  end
end
