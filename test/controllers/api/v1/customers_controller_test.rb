require "controllers/api/v1/test"

class Api::V1::CustomersControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @customer = build(:customer, team: @team)
    @other_customers = create_list(:customer, 3)

    @another_customer = create(:customer, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @customer.save
    @another_customer.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(customer_data)
    # Fetch the customer in question and prepare to compare it's attributes.
    customer = Customer.find(customer_data["id"])

    assert_equal_or_nil customer_data['name'], customer.name
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal customer_data["team_id"], customer.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/customers", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    customer_ids_returned = response.parsed_body.map { |customer| customer["id"] }
    assert_includes(customer_ids_returned, @customer.id)

    # But not returning other people's resources.
    assert_not_includes(customer_ids_returned, @other_customers[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/customers/#{@customer.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/customers/#{@customer.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    customer_data = JSON.parse(build(:customer, team: nil).api_attributes.to_json)
    customer_data.except!("id", "team_id", "created_at", "updated_at")
    params[:customer] = customer_data

    post "/api/v1/teams/#{@team.id}/customers", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/customers",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/customers/#{@customer.id}", params: {
      access_token: access_token,
      customer: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @customer.reload
    assert_equal @customer.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/customers/#{@customer.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Customer.count", -1) do
      delete "/api/v1/customers/#{@customer.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/customers/#{@another_customer.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
