require 'spec_helper'

describe Subscription do
  # subject { Subscription.new }
  it { expect(subject).to respond_to(:subscripter_id) }
  it { expect(subject).to respond_to(:subscriptee_id) }

  it { should validate_presence_of(:subscriptee_id) }
  it { should validate_presence_of(:subscripter_id) }
  it { should validate_numericality_of(:subscripter_id) }
  it { should validate_numericality_of(:subscriptee_id) }
end
