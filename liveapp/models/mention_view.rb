class MentionView < ActiveRecord::Base
  belongs_to :mention
  belongs_to :view

  validates_uniqueness_of :view_id, scope: :mention_id
end
