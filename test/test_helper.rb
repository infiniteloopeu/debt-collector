ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true

  self.use_instantiated_fixtures  = false

  fixtures :all

  def stub_facebook
    @controller.stubs(:ensure_application_is_installed_by_facebook_user).returns(true)
    @fb_user = stub('fb_user', :id => 11235)
    @fb_session = stub('fb_session', :user => @fb_user)
    @controller.instance_variable_set(:@facebook_session, @fb_session)
  end
  
  FB_UNAUTHORIZED_PARAMS = {"fb_sig_app_id"=>"196582146120",
    "format"=>"fbml",
    "fb_sig_request_method"=>"GET",
    "fb_sig_locale"=>"pl_PL",
    "_method"=>"GET",
    "fb_sig_in_canvas"=>"1",
    "fb_sig_in_new_facebook"=>"1",
    "fb_sig"=>"82179d5b494f129741476ed6ce47c0d3",
    "fb_sig_added"=>"0",
    "fb_sig_api_key"=>"5fe565b6fb8ad6ec74195677e47b56c2",
    "fb_sig_time"=>"1259066793.6153"}
  
  FB_PARAMS = {"fb_sig_app_id"=>"196582146120",
    "format"=>"fbml",
    "fb_sig_request_method"=>"GET",
    "fb_sig_locale"=>"en_US",
    "_method"=>"GET",
    "fb_sig_in_canvas"=>"1",
    "fb_sig_in_new_facebook"=>"1",
    "fb_sig"=>"a1bbce47218541f8caa725280a48bd5d",
    "fb_sig_friends"=>"1, 2, 3, 4, 5, 6, 7, 8, 9, 100000000000001, 100000000000002, 100000000000003, 100000000000004, 100000000000005, 100000000000006",
    "fb_sig_added"=>"1",
    "fb_sig_expires"=>"1259154000",
    "fb_sig_session_key"=>"2.babWhRy9oKJpKanU7bHg6A__.86400.1259154000-100000072475823",
    "fb_sig_ext_perms"=>"auto_publish_recent_activity",
    "fb_sig_api_key"=>"5fe565b6fb8ad6ec74195677e47b56c2",
    "fb_sig_time"=>"1259065820.2845",
    "fb_sig_profile_update_time"=>"0",
    "fb_sig_user"=>"11235"}
    
  FB_POST_PARAMS = FB_PARAMS.merge("fb_sig_request_method"=>"POST")
  
  def assert_raises_hidden_action(&block)
    assert_raise ::ActionController::UnknownAction do
      yield
    end
  end
  
end
