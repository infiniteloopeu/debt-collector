class GroupsController < ApplicationController
  before_filter :ensure_application_is_installed_by_facebook_user
  
  before_filter :new_group, :only => [:new, :create]
  before_filter :assign_group, :only => [:show, :edit, :update, :add_users, :remove_user]
  
  before_filter :user_owns_group?, :only => [:edit, :update, :add_users, :remove_user]
  
  before_filter :user_can_view_group?, :only => [:show]
  
  def index
    
    @owned_groups = Group.owned_by(@facebook_session.user.id).sorted
    @friends_groups = Group.owned_by(*friends).sorted
  end
  
  def show
  end
  
  def new
  end

  def edit
  end

  def create
    @group.attributes = params[:group]
    @group.fb_uid = @facebook_session.user.id 

    if @group.save
      redirect_to(@group)
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to(@group)
    else
      render :action => "edit"
    end
  end

  def add_users
    if @method == 'GET'
      @exclude_ids = @group.group_users.map(&:fb_uid).join(',')
    elsif @method == 'POST'
      if params[:ids]
        params[:ids].each do |id|
          GroupUser.create!(:fb_uid => id.to_i, :group_id => @group.id)
        end
      end
      redirect_to :action => :edit
    else
      raise_unknown_action_error
    end
  end
  
  def remove_user
    @group.group_users.find(:first, :conditions => {:fb_uid => params[:uid]}).destroy
    redirect_to :action => :edit
  end
  
  protected 
  
  def new_group
    @group = Group.new
  end
  
  def assign_group
    @group = Group.find params[:id]
  end
  
  def user_owns_group?
    (@group.fb_uid == @facebook_session.user.id) || raise_unknown_action_error
  end
  
  def user_belongs_to_group?
    @group.group_users.map(&:fb_uid).include?(@facebook_session.user.id)
  end
  
  def user_can_view_group?
    friends.include?(@group.fb_uid) || user_belongs_to_group? || user_owns_group? 
  end
  
  private
  
  def raise_unknown_action_error
    raise ::ActionController::UnknownAction, 'Action is hidden', caller
  end   
end
