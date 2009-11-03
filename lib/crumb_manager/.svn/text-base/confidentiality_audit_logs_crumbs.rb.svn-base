module CrumbManager::ConfidentialityAuditLogsCrumbs
  # No crumb options
  def new_audit_log_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Mentoring Connections", groups_path)
    add_crumb("Enter a reason to view confidential area")
  end

  def audit_logs_index_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)

    add_crumb("Confidentiality audit logs")
  end
end
