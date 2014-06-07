class Subscription < ActiveRecord::Base
  has_many :events

  validates_presence_of :subscripter_id
  validates_presence_of :subscriptee_id
  validates_numericality_of :subscriptee_id
  validates_numericality_of :subscripter_id
  # validates_uniqueness_of :subscripter_id
end
