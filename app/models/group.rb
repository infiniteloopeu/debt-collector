class Group < ActiveRecord::Base
  named_scope :sorted, :order => "id desc"

  named_scope :owned_by, lambda { |*owners| { :conditions => ['fb_uid in (?)', owners] } }

  has_many :group_users
  
end
