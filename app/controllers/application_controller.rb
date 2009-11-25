# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :assign_request_method
  # filter_parameter_logging :password
  
  def friends
    params[:fb_sig_friends].split(',').map(&:to_i)
  end
  
  def assign_request_method
    @method = params['fb_sig_request_method']
  end
end
