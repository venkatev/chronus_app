class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  include TabConfiguration


  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  before_filter :configure_tabs

  protected
  
  # Configures tabs that need to be shown, and also selects the tab based on
  # request url and context
  def configure_tabs
    cname = params[:controller]
    aname = params[:action]

    add_tab(
      TabConstants::HOME, root_url,
      cname == 'sessions' && aname == 'new'
    )

    add_tab(
      TabConstants::ABOUT, 'dummy',
      cname == 'users' && aname == 'show'
    )

    compute_active_tab
  end

  # Returns the default tab to select.
  def default_tab
    if logged_in?
      self.all_tabs[TabConstants::HOME]
    else
      self.all_tabs[TabConstants::ABOUT]
    end
  end
end

