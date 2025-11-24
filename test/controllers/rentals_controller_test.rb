require "test_helper"

class RentalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rentals_url
    assert_response :success
  end

  test "should update rental status" do
    rental = rentals(:one)
    patch rental_url(rental), params: { status: "rented" }
    assert_redirected_to rentals_path
  end
end
