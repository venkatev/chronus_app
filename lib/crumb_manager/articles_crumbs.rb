module CrumbManager::ArticlesCrumbs
  # ==== Params
  #   crumb_options
  #
  def articles_new_crumbs(options = {})
    add_crumb("Articles", articles_path)

    if options[:type]
      add_crumb "Write new article (pick article type)", new_article_path
      case options[:type]
      when "list"   then; add_crumb "Share books and websites"
      when "text"   then; add_crumb "New general article"
      when "media"  then; add_crumb "New media article"
      end
    else
      add_crumb "Write new article (pick article type)"
    end
  end

  def articles_show_crumbs(options = {})
    add_crumb("Articles", articles_path)
    add_crumb options[:article].title
  end
  
  def articles_edit_crumbs(options = {})
    article = options[:article]
    
    add_crumb("Articles", articles_path)
    add_crumb(article.title, article_path(article))
    add_crumb("Edit")
  end

  def article_helpful_crumbs
    add_crumb("Articles", articles_path)
    add_crumb("Articles that I marked helpful")
  end
end