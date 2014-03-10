module PostHelper

  def set_post_info(post)
    @slug = "p" #default is p when not in a collection
    @collection_name = ""
    @author_name = "unknown"
    @author_image = "unknown"

    # set info for collection post is in
    @collections.each do |collection|  
      if collection[0] == post["homeCollectionId"]
        @slug            = collection[1]["slug"]
        @collection_name = collection[1]["name"]
        break
      end
    end

    # get author info
    @authors.each do |author| 
      if author[0] == post["creatorId"]
        @author_name = author[1]["name"]
        @author_image = author[1]["imageId"]
        break
      end
    end
  end

end
