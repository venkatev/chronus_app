module CrumbManager::TopicsCrumbs
  # ==== Params
  #   crumb_options[:forum]
  #
  def topics_new_crumbs(crumb_options)
    add_crumb(crumb_options[:forum].name, forum_path(crumb_options[:forum]))
    add_crumb("New Topic")    
  end

  # ==== Params
  #   crumb_options[:forum]
  #   crumb_options[:topic]
  #
  def topics_show_crumbs(crumb_options)
    forum = crumb_options[:topic].forum
    add_crumb(forum.name, forum_path(forum))
    add_crumb(crumb_options[:topic].title)
  end
end
