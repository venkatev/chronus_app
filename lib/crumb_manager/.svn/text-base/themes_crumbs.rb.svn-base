module CrumbManager::ThemesCrumbs
  # No crumb options
  def themes_new_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Customize Appearance", themes_path)
    add_crumb("Add theme")
  end

  def themes_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Customize Appearance")
  end

  def themes_edit_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Customize Appearance", themes_path)
    add_crumb("Edit theme")
  end
end
