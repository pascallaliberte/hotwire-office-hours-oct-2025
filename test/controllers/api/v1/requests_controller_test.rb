require "controllers/api/v1/test"

class Api::V1::RequestsControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @request = build(:request, team: @team)
    @other_requests = create_list(:request, 3)

    @another_request = create(:request, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @request.save
    @another_request.save

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
  def assert_proper_object_serialization(request_data)
    # Fetch the request in question and prepare to compare it's attributes.
    request = Request.find(request_data["id"])

    assert_equal_or_nil request_data['customer_id'], request.customer_id
    assert_equal_or_nil request_data['status_id'], request.status_id
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal request_data["team_id"], request.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/requests", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    request_ids_returned = response.parsed_body.map { |request| request["id"] }
    assert_includes(request_ids_returned, @request.id)

    # But not returning other people's resources.
    assert_not_includes(request_ids_returned, @other_requests[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/requests/#{@request.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/requests/#{@request.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    request_data = JSON.parse(build(:request, team: nil).api_attributes.to_json)
    request_data.except!("id", "team_id", "created_at", "updated_at")
    params[:request] = request_data

    post "/api/v1/teams/#{@team.id}/requests", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/requests",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/requests/#{@request.id}", params: {
      access_token: access_token,
      request: {
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @request.reload
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/requests/#{@request.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Request.count", -1) do
      delete "/api/v1/requests/#{@request.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/requests/#{@another_request.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
