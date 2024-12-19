class User < ApplicationRecord
  devise :database_authenticatable,
         :validatable, :api

  ROLES = ["admin", "owner"]

  validates :role, inclusion: { in: ROLES }, allow_blank: false

  def owner?
    role == "owner"
  end
end
