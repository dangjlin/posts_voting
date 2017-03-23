module PostsHelper

  def transform_to_idea_icon(idea)
    if idea == "1" 
      return raw("<span class=\"glyphicon glyphicon-thumbs-up icon-thumbs-up \" aria-hidden=\"true\"></span>")
    elsif idea == "-1" 
      return raw("<span class=\"glyphicon glyphicon-thumbs-down icon-thumbs-down \" aria-hidden=\"true\"></span>")
    end

  end
  

end
