require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  
  def setup
    stub_facebook
    @one = groups(:one)
    @three = groups(:three)
  end
  
  test "index returns 200 and links to new group" do
    get :index, FB_PARAMS
    assert_response :success
    assert_match 'Create new group', @response.body
  end
  
  test "render new" do
    get :new, FB_PARAMS
    assert_response :success
    assert_match 'New group', @response.body
  end
  
  test "create group" do
    gr = Group.find(:first, :conditions => {:name => "new name test create group"})
    assert_nil gr, "record shouldn't exist in db before create"
    
    post :create, FB_PARAMS.merge(:group => {:name => "new name test create group"})
    
    gr = Group.find(:first, :conditions => {:name => "new name test create group"})
    assert gr, "new record should exist in db"
    assert_equal "new name test create group", gr.name
    assert_equal 11235, gr.fb_uid, "Owner of the created group should be the stubbed user 11235"
  end

  test "edit group for good user" do
    get :edit, FB_PARAMS.merge(:id => @one.id)
    assert_response :success
    assert_match @one.name, @response.body    
  end

  test "edit group for other user should fail" do
    assert_raises_hidden_action do 
      get :edit, FB_PARAMS.merge(:id => @three.id)
    end
  end
  
  test "update own group" do
    post :update, FB_PARAMS.merge(:id => @one.id, :group => {:name => "Nowa nazwa"})
    @one.reload
    assert_equal "Nowa nazwa", @one.name
  end

  test "update someone else's group" do
    assert_raises_hidden_action do
      post :update, FB_PARAMS.merge(:id => @three.id, :group => {:name => "Nowa nazwa"})
    end
  end

  
  test "show group if user is owner" do
    group = @one
    get :show, FB_PARAMS.merge(:id => group.id)
    assert_response :success
    assert_match group.name, @response.body
  end
  
  
  test "show group if user is friend with owner" do
    group = groups(:friends_group)
    get :show, FB_PARAMS.merge(:id => group.id)
    assert_response :success
    assert_match group.name, @response.body
  end
  
  test "show group if user belongs to group" do
    group = groups(:belonging_group)
    get :show, FB_PARAMS.merge(:id => group.id)
    assert_response :success
    assert_match group.name, @response.body
  end
  
  test "don't show other groups" do
    assert_raises_hidden_action do 
      group = groups(:other_group)
      get :show, FB_PARAMS.merge(:id => group.id)
    end
  end
  
  test "get add users assigns @exclude_ids" do
    group = @one
    get :add_users, FB_PARAMS.merge(:id => group.id)
    assert_response :success
    assert_equal assigns(:exclude_ids), "1"
  end
  
  test "post add users adds new user to group" do
    group = @one
    assert_equal 1, group.group_users.count, "Group should have one user"
    post :add_users, FB_POST_PARAMS.merge(:id => group.id, :ids => ["101","102"])
    assert_equal 3, group.reload.group_users.count, "group should have 3 users after action"
  end

  test "remove users from group" do
    post :remove_user, FB_POST_PARAMS.merge(:id => @one.id, :uid => "1")
    assert_equal 0, @one.reload.group_users.count, "group should have no users after removal"
  end

  test "remove users from group shouldn't be allowed for other's users group" do
    group = groups(:group7)
    assert_raises_hidden_action do
      post :remove_user, FB_POST_PARAMS.merge(:id => group.id, :uid => "159")
    end
    assert_equal 1, group.reload.group_users.count, "group should still have 1 user after failed removal"
  end
  
end
