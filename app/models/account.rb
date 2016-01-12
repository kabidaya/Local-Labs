class Account < ActiveRecord::Base
  self.primary_key = :id 
  validates_presence_of :name, :analytics_id
  validates_uniqueness_of :analytics_id
  has_many :views
end
