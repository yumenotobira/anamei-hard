# coding:utf-8

require 'twitter'
require 'dotenv'

Dotenv.load

class Bot
  attr_accessor :rest, :stream
  def initialize
    @rest = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    @stream = Twitter::Streaming::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    @stop_flag = 0
  end

  def tweet(user: nil, text: nil, in_reply_to_status: nil)
    return if @stop_flag == 1
    if user
      @rest.update("@#{user} #{text}", in_reply_to_status: in_reply_to_status)
    else
      @rest.update("#{text}")
    end
  end

  def random_text
    ran = (1..7).to_a.shuffle
    url = "http://textage.cc/score/12/_mei.html?1AC00R0#{ran.join}01234567~55-65"
    return "#{ran[1]} #{ran[2]} #{ran[0]} #{url}"
  end

  def stop_tweet
    @stop_flag = 1
  end
end
