require 'test_helper'

class GroupUserTest < ActiveSupport::TestCase
  
  def setup
    @one = groups(:one)
  end

  
  test "group_user belongs to group" do
    gu = GroupUser.create(:fb_uid => 1)
    gu.group = @one
    assert_equal @one.id, gu.group_id, "User should be assigned to group" 
  end
  
end
