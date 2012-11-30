module UsersHelper

  # Listing 7.13 - Returns the Gravatar (see gravatar.com) for the given user
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) # downcase since MD5 is case-sensitive (emails are not)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
