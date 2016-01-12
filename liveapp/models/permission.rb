class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :view

end
