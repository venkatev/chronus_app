module CrumbManager::ReportsCrumbs
  # No crumb options
  def reports_executive_summary_crumbs
    unless current_user.is_governing_committee_member?
      current_user.view_management_console? ?
          add_crumb("Manage", manage_program_path) :
          add_crumb("Home", program_root_path)
      add_crumb("Executive Summary Report")
    end    
  end

  # No crumb options
  def reports_match_crumbs
    current_user.view_management_console? ?
        add_crumb("Manage", manage_program_path) :
        add_crumb("Home", program_root_path)
    add_crumb("Match Rank Report")
  end
end
