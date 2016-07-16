require 'pp'

class TwitterController < ApplicationController
  before_action :signed_in_user

  def index
    @acc = fake_account
  end

  def analyse

    baseurl = "https://api.twitter.com"
    address = URI("#{baseurl}/1.1/friends/list.json?count=200")
    @http = Net::HTTP.new address.host, address.port
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    consumer_key = OAuth::Consumer.new(
        APP_CONFIG['TWITTER_KEY'], APP_CONFIG['TWITTER_SECRET']
    )

    twitter_accounts.each do |acc|
      access_token = OAuth::Token.new(acc[:token], acc[:aux_token])
      request = Net::HTTP::Get.new address.request_uri
      request.oauth! @http, consumer_key, access_token

      @http.start
      response = @http.request request
      @friends_full = JSON.parse(response.body)["users"]

      # The verify credentials endpoint returns a 200 status if
      # the request is signed correctly.
      address = URI("#{baseurl}/1.1/followers/list.json?count=200")

      # Build the request and authorize it with OAuth.
      request = Net::HTTP::Get.new address.request_uri
      request.oauth! @http, consumer_key, access_token

      # Issue the request and return the response.
      # response = @http.request request
      response = @http.request request
      puts "The response status was #{response.code}"
      @followers_full = JSON.parse(response.body)["users"]


      @follow_me = {}
      @i_follow = {}
      # @friends_full.each {|f| @i_follow[f["screen_name"]] = f["name"]}
      # @followers_full.each {|f| @follow_me[f["screen_name"]] = f["name"]}
      @friends_full.each {|f| @i_follow[f["screen_name"]] = filter_fields(f)}
      @followers_full.each {|f| @follow_me[f["screen_name"]] = filter_fields(f)}


      @they_dont_follow_back = @i_follow.select {|k,v| @follow_me[k] == nil}
      @i_dont_follow_back = @follow_me.select {|k,v| @i_follow[k] == nil}
      @double_link = @follow_me.select {|k,v| @i_follow[k]}

    end
  end

  private
    def twitter_accounts
      current_user.accounts.where(provider: "twitter")
    end

    def filter_fields(hash)
        fields = %w(id name screen_name description profile_image_url_https profile_banner_url)
      hash.select { |k,v| fields.include?(k) }
    end

    def fake_account
{"id"=>26127640,
 "id_str"=>"26127640",
 "name"=>"Jodie Emery",
 "screen_name"=>"JodieEmery",
 "location"=>"Vancouver, BC",
 "description"=>
  "Public speaker & political activist. Wife of Marc Emery. Owner of Cannabis Culture Headquarters store, Cannabis Culture Magazine, Pot TV & BCMP lounge.",
 "url"=>"http://t.co/E33LdwlEGf",
 "entities"=>
  {"url"=>
    {"urls"=>
      [{"url"=>"http://t.co/E33LdwlEGf",
        "expanded_url"=>"http://www.CannabisCulture.com",
        "display_url"=>"CannabisCulture.com",
        "indices"=>[0, 22]}]},
   "description"=>{"urls"=>[]}},
 "protected"=>false,
 "followers_count"=>19279,
 "friends_count"=>817,
 "listed_count"=>446,
 "created_at"=>"Tue Mar 24 00:04:14 +0000 2009",
 "favourites_count"=>1991,
 "utc_offset"=>-25200,
 "time_zone"=>"Pacific Time (US & Canada)",
 "geo_enabled"=>false,
 "verified"=>false,
 "statuses_count"=>10999,
 "lang"=>"en",
 "status"=>
  {"created_at"=>"Sun Apr 27 17:09:49 +0000 2014",
   "id"=>460465856703508480,
   "id_str"=>"460465856703508480",
   "text"=>
    "“@Komatost: @JodieEmery good morning! Have you &amp; Marc ever thought about having kids?” Not us! He has a vasectomy &amp; we don't want children..",
   "source"=>
    "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>",
   "truncated"=>false,
   "in_reply_to_status_id"=>460460563126943744,
   "in_reply_to_status_id_str"=>"460460563126943744",
   "in_reply_to_user_id"=>43840856,
   "in_reply_to_user_id_str"=>"43840856",
   "in_reply_to_screen_name"=>"Komatost",
   "geo"=>nil,
   "coordinates"=>nil,
   "place"=>nil,
   "contributors"=>nil,
   "retweet_count"=>0,
   "favorite_count"=>1,
   "entities"=>
    {"hashtags"=>[],
     "symbols"=>[],
     "urls"=>[],
     "user_mentions"=>
      [{"screen_name"=>"Komatost",
        "name"=>"Katrina",
        "id"=>43840856,
        "id_str"=>"43840856",
        "indices"=>[1, 10]},
       {"screen_name"=>"JodieEmery",
        "name"=>"Jodie Emery",
        "id"=>26127640,
        "id_str"=>"26127640",
        "indices"=>[12, 23]}]},
   "favorited"=>false,
   "retweeted"=>false,
   "lang"=>"en"},
 "contributors_enabled"=>false,
 "is_translator"=>false,
 "is_translation_enabled"=>false,
 "profile_background_color"=>"054175",
 "profile_background_image_url"=>
  "http://abs.twimg.com/images/themes/theme1/bg.png",
 "profile_background_image_url_https"=>
  "https://abs.twimg.com/images/themes/theme1/bg.png",
 "profile_background_tile"=>true,
 "profile_image_url"=>
  "http://pbs.twimg.com/profile_images/441495340311535616/9XdpZmbe_normal.jpeg",
 "profile_image_url_https"=>
  "https://pbs.twimg.com/profile_images/441495340311535616/9XdpZmbe_normal.jpeg",
 "profile_banner_url"=>
  "https://pbs.twimg.com/profile_banners/26127640/1375029679",
 "profile_link_color"=>"349419",
 "profile_sidebar_border_color"=>"FFFFFF",
 "profile_sidebar_fill_color"=>"97D57B",
 "profile_text_color"=>"000000",
 "profile_use_background_image"=>false,
 "default_profile"=>false,
 "default_profile_image"=>false,
 "following"=>true,
 "follow_request_sent"=>false,
 "notifications"=>false,
 "muting"=>false}
    end
end
