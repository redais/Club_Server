module MembersHelper
  def gravatar_for_member(member, options = { :size => 50 })
    gravatar_image_tag(member.email.downcase, :alt => member.last_name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
