#require 'snoo'
class RedditController < ApplicationController
  include RedditHelper
  before_filter :signed_in_user

  def index
    # accounts = reddit_accounts
    # @accs = {}
    # accounts.each do |acc|
    #   refresh_token(acc) if acc.stale?
    #   @accs[acc["login"]] = get_info(acc)
    # end
  end

  def whoami
    accounts = reddit_accounts
    @accs = {}
    accounts.each do |acc|
      refresh_token(acc) if acc.stale?
      @accs[acc["login"]] = get_info(acc)
    end
  end

  def messages

    baseurl = "https://ssl.reddit.com/api"
    address = URI("#{baseurl}/me.json")
    @http = Net::HTTP.new address.host, address.port
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    consumer_key = OAuth::Consumer.new(
        APP_CONFIG['REDDIT_KEY'], APP_CONFIG['REDDIT_SECRET']
    )



    @res = {}
    accounts.each do |acc|
      access_token = OAuth::Token.new(acc[:token], acc[:aux_token])
      request = Net::HTTP::Get.new address.request_uri
      request.oauth! @http, consumer_key, access_token

      @http.start
      response = @http.request request
      @res[acc[:login]] = JSON.parse(response.body)

    end
    @result = {} # get_mails
    respond_to do |format|
      format.html
      format.json { render :json => @result.to_json }
    end
  end

  def analyse
  end

  def refresh
    acc = Account.where(provider: "reddit", user: current_user).find(params[:id])
    q = BUNNYCHAN.queue("reddit.mprefresh")
    BUNNYCHAN.default_exchange.publish(acc.to_json, routing_key: q.name) if acc
    head :ok
  end

  def refresh_all
    accs = Account.where(provider: "reddit", user: current_user)
    # binding.pry
    q = BUNNYCHAN.queue("reddit.mprefresh")
    accs.each do |acc|
      BUNNYCHAN.default_exchange.publish(acc.to_json, routing_key: q.name)
    end
    head :ok
  end

  private
    def get_mails
      @r ||= Snoo::Client.new(useragent: "Jeeves Social Manager. Version: alpha. By Sahasya")
      accounts = reddit_accounts
      @result = {count: 0, data: {}}
      accounts.each {|a|
        @r.log_in a[:login], a[:pwd]
        @result[:data][a[:login]] = @r.me["data"]["has_mail"]
        @result[:count] += 1 if @result[:data][a[:login]]
        @r.log_out
        sleep(1.0/4.0)
      }
      return @result
    end
    
    def get_info (acc)
      url = URI(oauth_api_domain)
      http = Net::HTTP.new url.host, url.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      bearer_auth_header = "Bearer " + acc["token"]
      request = Net::HTTP::Get.new("#{oauth_api_domain}/api/v1/me")
      request['Authorization'] = bearer_auth_header
      response = http.request(request)

      JSON.parse(response.body)
    end

    def reddit_accounts
      current_user.accounts.where(provider: "reddit")
    end
end
