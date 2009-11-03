module CrumbManager::ProgramsCrumbs
  # No crumb options
  def programs_edit_crumbs
    add_crumb("Manage", manage_program_path)
    add_crumb("Program Settings")
  end

  # ==== Params
  #   crumb_options[:is_admin]
  #   crumb_options[:display_role_string]
  #
  def programs_invite_users_crumbs(crumb_options)
    if crumb_options[:is_admin]
      add_crumb("Manage", manage_program_path)
      add_crumb("Governing Committee", committee_members_path) if @current_program.committee_enabled? && crumb_options[:display_role_string] == "Governing committee members"
      add_crumb("Invite #{crumb_options[:display_role_string]}")
    end
  end

  # No crumb options
  def programs_contact_admin_crumbs
    add_crumb("Home", program_root_path)
    add_crumb("Contact Program Administrator")
  end
end
