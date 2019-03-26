class EventResponse
  attr_reader :body, :content_type, :status

  def initialize(
    body: {},
    content_type: "application/json",
    status: :bad_request,
    error: ArgumentError
  )
    check_for_valid_status_code(status, error)

    @body = body
    @content_type = content_type
    @status = status
  end

  private

  def check_for_valid_status_code(status, error)
    status_codes = Rack::Utils::SYMBOL_TO_STATUS_CODE

    message = "EventResponse.status to be contained " +
      "in Rack::Utils::HTTP_STATUS_CODES"

    # raise error.new(message) unless status_codes.has_key?(status)
    if !status_codes.has_key?(status)
      raise error.new(message)
    end
  end
end
