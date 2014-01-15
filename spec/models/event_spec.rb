# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  match_id     :integer
#  match_number :integer
#  event_type   :string(255)
#  time         :integer
#  x            :integer
#  y            :integer
#  z            :integer
#  player       :integer
#  team         :integer
#  source       :integer
#  gold         :decimal(, )
#  exp          :decimal(, )
#  extra_params :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  nickname     :string(255)
#

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
