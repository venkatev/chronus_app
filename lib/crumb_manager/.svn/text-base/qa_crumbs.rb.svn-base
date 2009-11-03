module CrumbManager::QaCrumbs
  include ApplicationHelper
  def qa_questions_index_crumbs(crumb_options)
    if crumb_options[:search_query].blank?
      add_crumb("Answers")
    else
      add_crumb("Answers", qa_questions_path)
      add_crumb "Search '#{crumb_options[:search_query]}'"
    end
  end

  def qa_questions_show_crumbs(crumb_options)
    qa_question = crumb_options[:qa_question]
    add_crumb("Questions", qa_questions_path())
    add_crumb(qa_question.summary.truncate(10))
  end

  def qa_questions_new_crumbs
    add_crumb("Questions", qa_questions_path)
    add_crumb('Ask a Question')
  end
end