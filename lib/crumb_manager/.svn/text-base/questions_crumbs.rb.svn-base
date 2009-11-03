module CrumbManager::QuestionsCrumbs
  # ==== Params
  #   crumb_options[:role_string]
  #
  def questions_index_crumbs(crumb_options)
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb "Customize #{crumb_options[:role_string]} Form"
  end
end
