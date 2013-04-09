# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  nickname                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  games_played            :integer
#  wins                    :integer
#  losses                  :integer
#  kills                   :integer
#  deaths                  :integer
#  assists                 :integer
#  secs                    :integer
#  secs_dead               :integer
#  avg_hero_damage         :float
#  avg_exp                 :float
#  gold                    :integer
#  avg_gold_from_hero_kill :float
#  avg_gold_lost_deaths    :float
#  avg_creep_kills         :float
#  avg_creep_exp           :float
#  avg_creep_gold          :float
#  avg_neutral_kills       :float
#  avg_neutral_exp         :float
#  avg_neutral_gold        :float
#  avg_building_gold       :float
#  avg_wards               :float
#  mmr                     :float
#  avg_denies              :float
#  last_match              :integer
#  hon_id                  :integer
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
end
