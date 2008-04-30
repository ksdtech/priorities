module ItemsHelper
  def user_rank_input(user, item)
    return "&nbsp;" if item.special?
    "<input type=\"text\" id=\"votes_#{item.id}_rank\" name=\"votes[#{item.id}][rank]\" value=\"#{item.rank_for_user(user)}\", size=\"3\" />"
  end
end


