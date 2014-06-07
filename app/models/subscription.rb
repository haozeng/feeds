class Subscription < ActiveRecord::Base
  validates_presence_of :subscripter_id
  validates_presence_of :subscriptee_id
  validates_numericality_of :subscriptee_id
  validates_numericality_of :subscripter_id

  scope :by_subscripter_id, -> (id) { where(:subscripter_id => id) }
end
