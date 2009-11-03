module CrumbManager::GroupsCrumbs
  # No crumb options
  def groups_show_crumbs
    add_crumb("Home", program_root_path)
    add_crumb("Mentoring Area")
  end

  # No crumb options
  def groups_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Mentoring Connections")
  end
end
