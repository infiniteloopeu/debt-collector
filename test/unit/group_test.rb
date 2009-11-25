require 'test_helper'
require 'set'

class GroupTest < ActiveSupport::TestCase
  
  def setup
    @one = groups(:one)
    @two = groups(:two)
  end
  
  test "find all groups for owner" do
    groups_for_11235 = [@one, @two]
    result = Group.owned_by(11235)
    
    assert_equal 2, result.length, "results should contain 2 records"
    assert_equal Set.new(groups_for_11235), Set.new(result), "Result doesn't match"
  end

  test "find all groups for owners" do
    groups = [@one, @two, groups(:friends_group)]
    result = Group.owned_by(11235, 1)
    
    assert_equal Set.new(groups), Set.new(result), "Result doesn't match"
  end


  test "groups sorted" do
    result = Group.sorted

    result.each_cons(2) do |x|
      assert x[0].id > x[1].id
    end
  end

  test "groups sorted chained" do
    groups_for_11235 = [@one, @two]
    result = Group.sorted.owned_by(11235)
    
    assert_equal 2, result.length, "results should contain 2 records"
    assert_equal Set.new(groups_for_11235), Set.new(result), "Result doesn't match"
    
    assert result[0].id > result[1].id, "%s >? %s" %[result[0].id , result[1].id]  
  end
  
  test "group has many group_users" do
    gu1 = GroupUser.create(:fb_uid => 1)
    gu2 = GroupUser.create(:fb_uid => 2)
    
    @one.group_users << gu1 << gu2
    
    assert_equal @one.id, gu1.group_id
    assert_equal @one.id, gu2.group_id 
  end

  
  
end
