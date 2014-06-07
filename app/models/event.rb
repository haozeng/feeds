class Event < ActiveRecord::Base
  belongs_to :subscription

  validates_inclusion_of :event_type,
    in: %w(want price_drop list),
    message: "%{value} is not a valid event_type"
end
