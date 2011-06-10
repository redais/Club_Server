module ClubsHelper
  
  #
  def gravatar_for_club(club, options = { :size => 50 })
    gravatar_image_tag(club.login.downcase, :alt => club.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  
  


  # Use this to wrap view elements that the club can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   Club)  do link_to('List all clubs', clubs_path) end %> |
  # <%= if_authorized?(:edit,    @club) do link_to('Edit this club', edit_club_path) end %> |
  # <%= if_authorized?(:destroy, @club) do link_to 'Destroy', @club, :confirm => 'Are you sure?', :method => :delete end %> 
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to club's page ('clubs/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * :content_text => 'Content text in place of club.login', escaped with
  #   the standard h() function.
  # * :content_method => :club_instance_method_to_call_for_content_text
  # * :title_method => :club_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  #
  # Examples:
  #   link_to_club @club
  #   # => <a href="/clubs/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, :class => :vcard do
  #    (link_to_club club, :class => 'fn n', :title_method => :login, :content_method => :name) +
  #          ': ' + (content_tag :span, club.email, :class => 'email')
  #   end
  #   # => <span class="vcard"><a href="/clubs/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_club @club, :content_text => 'Your club page'
  #   # => <a href="/clubs/3" title="barmy" class="nickname">Your club page</a>
  #
  def link_to_club(club, options={})
    raise "Invalid club" unless club
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= club.send(options.delete(:content_method))
    options[:title] ||= club.send(options.delete(:title_method))
    link_to h(content_text), club_path(club), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address 
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current club's page (using link_to_club) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_club(options={})
    if current_club
      link_to_club current_club, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_club
      [:content_method, :title_method].each{|opt| options.delete(opt)} 
      link_to_login_with_IP content_text, options
    end
  end

end
