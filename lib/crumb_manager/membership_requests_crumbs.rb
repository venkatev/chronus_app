module CrumbManager::MembershipRequestsCrumbs
  # ==== Params
  #   crumb_options[:filter]
  #   crumb_options[:user]
  #
  def membership_requests_index_crumbs(crumb_options)
    user = crumb_options[:user]
    return if user.is_governing_committee_member_only?

    if user.is_admin?
      add_crumb("Manage", manage_program_path)
      add_crumb("#{crumb_options[:list].capitalize} Membership requests", membership_requests_path(:list => crumb_options[:list]))

      # Set crumbs depending on the view
      if crumb_options[:filter] == RoleConstants::STUDENTS_NAME
        add_crumb("From #{_Mentees}")
    elsif crumb_options[:filter] == RoleConstants::MENTORS_NAME
        add_crumb("From #{_Mentors}")
      else
        add_crumb("All")
      end
    elsif user.is_governing_committee_member?
      add_crumb("Home", program_root_path)
      add_crumb("Membership requests")
    end
  end
end
