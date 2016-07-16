module RedditHelper
  def oauth_token_url
    URI("https://ssl.reddit.com/api/v1/access_token")
  end

  def oauth_api_domain
    "https://oauth.reddit.com"
  end

  def refresh_token(account)
    http = Net::HTTP.new oauth_token_url.host, oauth_token_url.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Post.new(oauth_token_url.request_uri)
    request['Authorization'] = basic_auth_header
    params = {"grant_type" => "refresh_token"}
    params["refresh_token"] = account[:aux_token]
    request.set_form_data(params)
    response = http.request(request)
    rep = JSON.parse(response.body)

    unless rep["error"]
      expires_at = DateTime.now + rep["expires_in"].seconds
      account.update_attributes(token: rep["access_token"], expiresat: expires_at)
    else
      # ERROR!
    end
  end

  def basic_auth_header
    "Basic " + Base64.strict_encode64("#{APP_CONFIG['REDDIT_KEY']}:#{APP_CONFIG['REDDIT_SECRET']}")
  end
end
