require 'test_helper'

class SortControllerTest < ActionController::TestCase
  test "should get comments" do
    get :comments
    assert_response :success
  end

end
