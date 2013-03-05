class User < ActiveRecord::Base
  attr_accessible :avatar, :nickname
  has_many :comments
end
