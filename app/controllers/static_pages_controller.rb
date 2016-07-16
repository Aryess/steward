require 'pp'
class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: 'dashboard'

  def home
  end

  def help
  end

  def dashboard
    @content = request.env.delete('omniauth.auth') || Hash.new("nil")
    @account = @content.empty? ? @content : account_from_auth(@content)
  end

  private
    def account_from_auth(auth)
      provider = auth['provider']
      uid = auth['uid']
      token = auth['credentials']['token']
      login = auth['info']['name']
      login += " (#{auth['info']['nickname']})" if auth['info']['nickname']
      aux_token = auth['credentials']['secret'] || auth['credentials']['refresh_token']
      expires_at = DateTime.strptime("#{auth['credentials']['expires_at']}",'%s')
      {provider: provider, uid: uid, token: token, login: login,
        aux_token: aux_token, expiresat: expires_at}
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
