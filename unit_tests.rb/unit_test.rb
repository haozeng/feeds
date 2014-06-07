#!/usr/bin/env ruby

require 'json'
require "addressable/uri"
require "test/unit"
require 'rack/utils'
require 'queryparams'

class ThreadfeedTest < Test::Unit::TestCase

  def test_run
    $url = "http://localhost:3000"

    def get(path)
      `curl #{$url}/#{path} 2> /dev/null`
    end

    def post(path, params)
      # uri = Addressable::URI.new
      # params_string = Rack::Utils.build_nested_query(params, nil)
      # uri.query_values = params
      # params_string = uri.query
      # params_string = params

      # params_string = ::CGI::unescape(nested_data.to_query(params))
      # puts params_string
      params_string = QueryParams.encode(params)
      puts params_string
      `curl -X POST -g -d '#{params_string}' #{$url}/#{path} 2> /dev/null`
    end

    def feed(user_id)
      JSON.parse(get("/feeds/#{user_id}"))
    end

    assert(feed(1).empty?)

    post("/feeds/subscription", {subscription: {subscripter_id: 1, subscriptee_id: 2}})
    post("/feeds/subscription", {subscription: {subscripter_id: 5, subscriptee_id: 2}})
    post("/feeds/subscription", {subscription: {subscripter_id: 1, subscriptee_id: 3}})

    assert(feed(1).empty?)
    assert(feed(5).empty?)

    post("/feeds/event", {event: {subscriptee_id: 2, event_type: "want", item_id: 5000}})
    post("/feeds/event", {event: {subscriptee_id: 3, event_type: "price_drop", item_id: 7000}})
    post("/feeds/event", {event: {subscriptee_id: 4, event_type: "want", item_id: 9000}})

    assert_equal([7000, 5000], feed(1).map {|event| event["item_id"]})
    assert_equal([5000], feed(5).map {|event| event["item_id"]})

    post("/feeds/event", {event: {subscriptee_id: 2, event_type: "list", item_id: 6000}})
    post("/feeds/event", {event: {subscriptee_id: 4, event_type: "price_drop", item_id: 4000}})
    post("/feeds/event", {event: {subscriptee_id: 3, event_type: "want", item_id: 8000}})
    post("/feeds/event", {event: {subscriptee_id: 4, event_type: "list", item_id: 3000}})

    assert_equal([3000, 8000, 6000, 7000, 5000], feed(1).map {|event| event["item_id"]})
    assert_equal([3000, 6000, 5000], feed(5).map {|event| event["item_id"]})
  end
end
