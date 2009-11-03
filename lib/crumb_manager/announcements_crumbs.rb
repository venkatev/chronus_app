module CrumbManager::AnnouncementsCrumbs
  # No crumb options
  def announcements_new_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Announcements", announcements_path)
    add_crumb("New Announcement")
  end

  def announcements_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Announcements")
  end

  # ==== Params
  #   crumb_options[:announcement]
  #
  def announcements_show_crumbs(crumb_options)
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Announcements", announcements_path)
    add_crumb(crumb_options[:announcement].title)
  end

  # ==== Params
  #   crumb_options[:announcement]
  #
  def announcements_edit_crumbs(crumb_options)
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Announcements", announcements_path)
    add_crumb(
      crumb_options[:announcement].title,
      announcement_path(crumb_options[:announcement]))
    add_crumb("Edit Announcement")
  end
end
