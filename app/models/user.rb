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
  attr_accessible :email, :nickname,:hon_id
end
