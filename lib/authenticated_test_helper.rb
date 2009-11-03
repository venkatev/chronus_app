module AuthenticatedTestHelper
  # Sets the current sessions in the session from the sessions fixtures.
  def login_as(sessions)
    @request.session[:sessions_id] = sessions ? (sessions.is_a?(Sessions) ? sessions.id : sessions(sessions).id) : nil
  end

  def authorize_as(sessions)
    @request.env["HTTP_AUTHORIZATION"] = sessions ? ActionController::HttpAuthentication::Basic.encode_credentials(sessions(sessions).login, 'monkey') : nil
  end
  
end
