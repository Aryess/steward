module TwitterHelper

  def twitter_for(acc)
    "https://twitter.com/#{acc["screen_name"] || acc}"
  end

  def pic_for(acc)
    url = acc["profile_image_url_https"] || acc
    image_tag(url, class: "gravatar")
  end

end
