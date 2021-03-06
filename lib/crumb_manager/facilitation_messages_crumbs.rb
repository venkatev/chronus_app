module CrumbManager::FacilitationMessagesCrumbs
  # No crumb options
  def facilitation_messages_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Facilitate Mentoring Connections")
  end

  # No crumb options
  def facilitation_messages_new_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Facilitate Mentoring Connections", facilitation_messages_path)
    add_crumb("New message")
  end

  # ==== Params
  #   crumb_options[:facilitation_message]
  #
  def facilitation_messages_edit_crumbs(crumb_options)
    facilitation_message = crumb_options[:facilitation_message]
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Facilitate Mentoring Connections", facilitation_messages_path)
    add_crumb(facilitation_message.subject, facilitation_message_path(facilitation_message))
    add_crumb "Edit message"
  end

  # ==== Params
  #   crumb_options[:facilitation_message]
  #
  def facilitation_messages_show_crumbs(crumb_options)
    facilitation_message = crumb_options[:facilitation_message]
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Facilitate Mentoring Connections", facilitation_messages_path)
    add_crumb(facilitation_message.subject)
  end
end
