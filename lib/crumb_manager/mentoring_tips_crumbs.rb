module CrumbManager::MentoringTipsCrumbs
  # No crumb options
  def mentoring_tips_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Mentoring Tips")
  end
end