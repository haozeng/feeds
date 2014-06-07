class Event < ActiveRecord::Base
  validates_inclusion_of :event_type,
    in: %w(want price_drop list),
    message: "%{value} is not a valid event_type"

  scope :by_subscriptee_ids, ->(subscriptee_ids) { where('subscriptee_id IN (?) OR event_type is ?', subscriptee_ids, 'list') }
end
