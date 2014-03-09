class PostController < ApplicationController
  MEDIUM_URL      = "https://medium.com/"
  CLOUDFRONT_URL  = "https://d262ilb51hltx0.cloudfront.net/fit/t/1600/672/"
  JSON_FORMAT     = "?format=json"
  SPOILER         = "])}while(1);</x>"

  def index
    # Medium returns json with a spoiler prepended to it. Probably to prevent json hijacking.
    dirty_response = HTTParty.get(MEDIUM_URL + JSON_FORMAT)
    json_content   = get_valid_json(dirty_response)  

    # all posts the page
    @posts = json_content["payload"]["value"].map{ |post| post }
    # list of associated collections posts on page are stored in
    @collections = json_content["payload"]["references"]["Collection"].map{ |collection| collection }
  end


  def show
    # Medium returns json with a spoiler prepended to it. Probably to prevent json hijacking.
    post_url        = MEDIUM_URL + params[:collection_name] + "/" + params[:post_id] + JSON_FORMAT
    dirty_response  = HTTParty.get(post_url)
    json_content    = get_valid_json(dirty_response)     
    
    @title      = json_content["payload"]["value"]["title"]
    @main_image = CLOUDFRONT_URL + json_content["payload"]["value"]["content"]["image"]["imageId"]
    @paragraphs = json_content["payload"]["value"]["content"]["bodyModel"]["paragraphs"].map{|block_info| block_info["text"]}
  end

  private

  def get_valid_json(dirty_response)
    clean_response = remove_spoiler(dirty_response)
    convert_to_json(clean_response)
  end
    
  def remove_spoiler(dirty_response)
    dirty_response.body.gsub(SPOILER, "")
  end

  def convert_to_json(json_string)
    JSON.parse(json_string)
  end


end
