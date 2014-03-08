class PostController < ApplicationController
  MEDIUM_URL      = "https://medium.com/"
  CLOUDFRONT_URL  = "https://d262ilb51hltx0.cloudfront.net/fit/t/1600/672/"
  JSON_FORMAT     = "?format=json"

  BUNCH_O_PAGES = ["p/2c0424c1d4bc", "race-class/b84d4011d17e", "human-parts/9f53ef6a1c10", "apple-daily/f5f8c807d868", "life-learning/2a1841f1335d"]

  def index
    spoiler = "])}while(1);</x>"
    response = HTTParty.get(MEDIUM_URL + BUNCH_O_PAGES[[*0..4].sample] + JSON_FORMAT)
    string_response = response.body.gsub(spoiler, "")
    json_response = JSON.parse(string_response)
    @title = json_response["payload"]["value"]["title"]
    @main_image = CLOUDFRONT_URL + json_response["payload"]["value"]["content"]["image"]["imageId"]
    @paragraphs = json_response["payload"]["value"]["content"]["bodyModel"]["paragraphs"].map{|block_info| block_info["text"]}
  end

  def show
  end
end
