module CrumbManager::MentorRequestsCrumbs
  # ==== Params
  #   crumb_options[:is_request_manager_view_of_all_requests]
  #
  def mentor_requests_index_crumbs(crumb_options)
    if crumb_options[:is_request_manager_view_of_all_requests]
      add_crumb("Manage", manage_program_path)
    else
      add_crumb("Home", program_root_path)
    end

    add_crumb "Mentor Requests"
  end
end
