class User < ApplicationRecord
  devise :database_authenticatable,
         :validatable, :api
end
