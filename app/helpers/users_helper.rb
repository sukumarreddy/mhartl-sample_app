module UsersHelper

  # Listing 7.13 - Returns the Gravatar (see gravatar.com) for the given user
  def gravatar_for(user, options = { size: 50 }) # size added in Listing 7.29
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) # downcase since MD5 is case-sensitive (emails are not)
    
    # Listing 7.29 + Exercise 7.1
    #gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}" # apparently mhartl registered 'example@railstutorial.org' on gravatar.com?
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"

    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
