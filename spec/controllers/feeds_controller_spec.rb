require 'spec_helper'

describe FeedsController do
  let(:subscripter_id) { 100 }
  let(:subscriptee_id) { 200 }

  describe "#POST subscription" do
    it "should create a subscription" do
      post :subscription, subscription: {
                            subscripter_id: subscripter_id,
                            subscriptee_id: subscriptee_id
                          },
                          format: :json

      expect(response).to be_successful
      expect(response.status).to eql(201)
      expect(Subscription.count).to eql(1)
    end

    it "should return 422 if validation fails" do
      post :subscription, subscription: {
                            subscripter_id: subscripter_id
                          },
                          format: :json

      expect(response).to_not be_successful
      expect(response.status).to eql(422)
    end
  end

  describe "#POST event" do
    let(:event_type) { 'want' }
    let(:item_id) { 100 }

    it "should create an event" do
      post :event, event: {
                     subscriptee_id: subscriptee_id,
                     event_type: event_type,
                     item_id: item_id
                   },
                   format: :json
      expect(response).to be_successful
      expect(response.status).to eql(201)
      expect(Event.count).to eql(1)
    end

    it "should return 422 if validation fails" do
      post :event, event: {
                     subscriptee_id: subscriptee_id,
                     item_id: item_id
                   },
                   format: :json
      expect(response).to_not be_successful
      expect(response.status).to eql(422)
    end
  end

  describe "#GET feeds" do
    let(:item_id) { rand(100) }

    context "get feeds from subscriptees (want, price_drop)" do
      let(:event_type) { 'want' }
      before do
        Subscription.create(subscriptee_id: subscriptee_id,
                         subscripter_id: subscripter_id)
        Event.create(subscriptee_id: subscriptee_id, event_type: event_type,
                     item_id: item_id)
      end

      it "should return the feeds from subscripter" do
        get :index, subscripter_id: subscripter_id, format: :json
        body = JSON.parse(response.body)
        expect(body.size).to eql(1)
        expect(body[0]['item_id']).to eql(item_id)
      end
    end

    context "get feeds from global users (list)" do
      let(:event_type) { 'list' }
      before do
        Event.create(item_id: item_id, event_type: event_type)
      end

      it "should return the global users list" do
        get :index, subscripter_id: subscripter_id, format: :json
        body = JSON.parse(response.body)
        expect(body.size).to eql(1)
        expect(body[0]['item_id']).to eql(item_id)
      end
    end
  end
end
