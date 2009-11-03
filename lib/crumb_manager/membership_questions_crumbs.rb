module CrumbManager::MembershipQuestionsCrumbs
  # No crumb options
  def membership_questions_index_crumbs(crumb_options)    
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Customize #{crumb_options[:form_name]}")
  end
end
