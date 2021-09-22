class PresentationError
  def initialize(error_key)
    @error_key = error_key
  end

  # rubocop:disable Metrics/MethodLength
  def message
    generic_error_message = "Server error. Please try again later."
    case @error_key
    when :malformed_request
      "There was a problem communicating with another provider."
    when :unauthorized
      "You are not authorized to perform this request."
    when :not_found
      "The resource you're trying to access does not exist."
    when :third_party_config_issue, :server
      generic_error_message
    else
      generic_error_message
    end
  end
  # rubocop:enable Metrics/MethodLength
end
