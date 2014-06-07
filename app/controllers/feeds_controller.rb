class FeedsController < ApplicationController

  def index
    subscriptee_ids = Subscription.where(:subscripter_id => params[:subscripter_id]).pluck(:subscriptee_id)
    @events = Event.where('subscriptee_id IN (?) OR event_type is ?', subscriptee_ids, 'list').order('created_at desc')

    render json: @events.to_json
  end

  def subscription
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      render json: @subscription.to_json
    else
      render :nothing => true, :status => 404
    end
  end

  def event
    @event = Event.new(event_params)

    if @event.save
      render json: @event.to_json
    else
      render :nothing => true, :status => 404
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:subscriptee_id, :subscripter_id)
  end

  def event_params
    params.require(:event).permit(:subscriptee_id, :item_id, :event_type)
  end
end
