require File.dirname(__FILE__) + '/../test_helper'
require 'passwords_controller'

# Re-raise errors caught by the controller.
class PasswordsController; def rescue_action(e) raise e end; end

class PasswordsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :passwords

  def test_should_allow_signup
    assert_difference 'Password.count' do
      create_password
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Password.count' do
      create_password(:login => nil)
      assert assigns(:password).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Password.count' do
      create_password(:password => nil)
      assert assigns(:password).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Password.count' do
      create_password(:password_confirmation => nil)
      assert assigns(:password).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Password.count' do
      create_password(:email => nil)
      assert assigns(:password).errors.on(:email)
      assert_response :success
    end
  end
  
  def test_should_sign_up_user_in_pending_state
    create_password
    assigns(:password).reload
    assert assigns(:password).pending?
  end

  
  def test_should_sign_up_user_with_activation_code
    create_password
    assigns(:password).reload
    assert_not_nil assigns(:password).activation_code
  end

  def test_should_activate_user
    assert_nil Password.authenticate('aaron', 'test')
    get :activate, :activation_code => passwords(:aaron).activation_code
    assert_redirected_to '/session/new'
    assert_not_nil flash[:notice]
    assert_equal passwords(:aaron), Password.authenticate('aaron', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  protected
    def create_password(options = {})
      post :create, :password => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
