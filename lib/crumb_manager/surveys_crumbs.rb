module CrumbManager::SurveysCrumbs
  # No crumb options
  def surveys_new_crumbs(crumb_options)
    survey = crumb_options[:survey]
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Surveys", surveys_path) unless survey.feedback?
    add_crumb(survey.feedback? ? "New Feedback Form" : "New Survey")
  end

  def surveys_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Surveys")
  end

  # ==== Params
  #   crumb_options[:survey]
  #
  def surveys_edit_crumbs(crumb_options)
    survey = crumb_options[:survey]
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    if survey.feedback?
      add_crumb("Feedback on #{survey.program.mentor_name.pluralize}")
    else
      add_crumb("Surveys", surveys_path)
      add_crumb survey.name
    end
  end

  def surveys_publish_crumbs(crumb_options)
    survey = crumb_options[:survey]
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Surveys", surveys_path) unless survey.feedback?
    add_crumb(survey.name, survey_survey_questions_path(survey))
    add_crumb "Publish"
  end

  def survey_edit_answers_crumbs(crumb_options)
    survey = crumb_options[:survey]
    group = crumb_options[:group]
    if survey.feedback?
      add_crumb("Home", program_root_path)
      add_crumb("Mentoring area", group_path(group))
      add_crumb("Feedback")
    end
  end
end
