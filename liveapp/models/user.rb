class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :permissions
  has_many :views, through: :permissions, source: :view
  scope :non_admin, -> { where("admin is false") }

  def admin?
    admin
  end

  def permissible?(params)
    admin? || permissions.where(view_id: params[:id]).present?
  end
end
