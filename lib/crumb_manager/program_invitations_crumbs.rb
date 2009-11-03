module CrumbManager::ProgramInvitationsCrumbs
  # No crumb options
  def program_invitations_index_crumbs(opts)
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    role_str = case opts[:filter]
    when RoleConstants::MENTOR_NAME
      _mentors
    when RoleConstants::STUDENT_NAME
      _mentees
    when RoleConstants::ADMIN_NAME
      "administrators"
    end
    add_crumb("Pending #{role_str} invitations")
  end
end
