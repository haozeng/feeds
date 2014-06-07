require 'spec_helper'

describe Event do
  it { expect(subject).to respond_to(:subscriptee_id) }
  it { expect(subject).to respond_to(:event_type) }
  it { expect(subject).to respond_to(:item_id) }
  it { should ensure_inclusion_of(:event_type).in_array(%w(want price_drop list)) }
end
