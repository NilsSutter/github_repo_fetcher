require "./src/lib/presentation_error"

describe PresentationError do
  test_cases = [
    OpenStruct.new(
      error_key: :malformed_request,
      error_message: "There was a problem communicating with another provider."
    ),
    OpenStruct.new(
      error_key: :unauthorized,
      error_message: "You are not authorized to perform this request."
    ),
    OpenStruct.new(
      error_key: :not_found,
      error_message: "The resource you're trying to access does not exist."
    ),
    OpenStruct.new(
      error_key: :third_party_config_issue,
      error_message: "Server error. Please try again later."
    ),
    OpenStruct.new(
      error_key: :server,
      error_message: "Server error. Please try again later."
    ),
    OpenStruct.new(
      error_key: :something_else,
      error_message: "Server error. Please try again later."
    )
  ]

  test_cases.each do |test_case|
    context "when initialized with an error_key #{test_case.error_key}" do
      it "returns the right error message" do
        expect(PresentationError.new(test_case.error_key).message).to eq(test_case.error_message)
      end
    end
  end
end
