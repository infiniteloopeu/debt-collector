require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "index shows name of currenlty logged in user" do 
    get :index, FB_UNAUTHORIZED_PARAMS
    assert_response :success
    assert_match '<fb:name uid="loggedinuser" useyou="false" />', @response.body 
  end
  
  test "application controller assigns @method for get request" do 
    get :index, FB_UNAUTHORIZED_PARAMS
    assert_response :success
    assert_equal assigns(:method), 'GET'
  end
  
end
