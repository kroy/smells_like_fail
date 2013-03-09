# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hon_id     :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :nickname,:hon_id #,:email

  #before_save { |user| user.email = email.downcase }
  before_save { |user| user.nickname = nickname.downcase }
  before_save { |user| user.hon_id = hon_id.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :nickname, presence: true, length: { maximum: 50 },
  			uniqueness: { case_sensitive: false }
  #validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  			#uniqueness: { case_sensitive: false }
  validates :hon_id, presence: true, uniqueness: { case_sensitive: false } #also add length validator.  Potentially make this primary key

end
