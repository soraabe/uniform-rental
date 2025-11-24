require "test_helper"

class LineControllerTest < ActionDispatch::IntegrationTest
  test "should post webhook" do
    post line_webhook_url, params: { events: [] }.to_json, headers: { "Content-Type" => "application/json" }
    assert_response :success
  end
end
