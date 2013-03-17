# == Schema Information
#
# Table name: matches
#
#  id               :integer          not null, primary key
#  match_id         :string(255)
#  date_played      :date
#  duration_seconds :integer
#  winner           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Match do
  pending "add some examples to (or delete) #{__FILE__}"
end
