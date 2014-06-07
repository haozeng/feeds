class FeedsController < ApplicationController
  respond_to :json

  def index
    subscriptee_ids = Subscription.by_subscripter_id(params[:subscripter_id]).pluck(:subscriptee_id)
    @events = Event.by_subscriptee_ids(subscriptee_ids).order('created_at desc')

    respond_with @events
  end

  def subscription
    @subscription = Subscription.new(subscription_params)
    flash[:notice] = 'subscription was successfully created.' if @subscription.save

    respond_with @subscription, :location => nil
  end

  def event
    @event = Event.new(event_params)

    flash[:notice] = 'event was successfully created.' if @event.save
    respond_with @event, :location => nil
  end

  private

  def subscription_params
    params.require(:subscription).permit(:subscriptee_id, :subscripter_id)
  end

  def event_params
    params.require(:event).permit(:subscriptee_id, :item_id, :event_type)
  end
end
