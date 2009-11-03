require File.dirname(__FILE__) + '/../test_helper'

class PasswordTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :passwords

  def test_should_create_password
    assert_difference 'Password.count' do
      password = create_password
      assert !password.new_record?, "#{password.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    password = create_password
    password.reload
    assert_not_nil password.activation_code
  end

  def test_should_create_and_start_in_pending_state
    password = create_password
    password.reload
    assert password.pending?
  end


  def test_should_require_login
    assert_no_difference 'Password.count' do
      u = create_password(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Password.count' do
      u = create_password(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Password.count' do
      u = create_password(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Password.count' do
      u = create_password(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    passwords(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal passwords(:quentin), Password.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    passwords(:quentin).update_attributes(:login => 'quentin2')
    assert_equal passwords(:quentin), Password.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_password
    assert_equal passwords(:quentin), Password.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    passwords(:quentin).remember_me
    assert_not_nil passwords(:quentin).remember_token
    assert_not_nil passwords(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    passwords(:quentin).remember_me
    assert_not_nil passwords(:quentin).remember_token
    passwords(:quentin).forget_me
    assert_nil passwords(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    passwords(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil passwords(:quentin).remember_token
    assert_not_nil passwords(:quentin).remember_token_expires_at
    assert passwords(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    passwords(:quentin).remember_me_until time
    assert_not_nil passwords(:quentin).remember_token
    assert_not_nil passwords(:quentin).remember_token_expires_at
    assert_equal passwords(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    passwords(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil passwords(:quentin).remember_token
    assert_not_nil passwords(:quentin).remember_token_expires_at
    assert passwords(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_password
    password = create_password(:password => nil, :password_confirmation => nil)
    assert password.passive?
    password.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    password.register!
    assert password.pending?
  end

  def test_should_suspend_password
    passwords(:quentin).suspend!
    assert passwords(:quentin).suspended?
  end

  def test_suspended_password_should_not_authenticate
    passwords(:quentin).suspend!
    assert_not_equal passwords(:quentin), Password.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_password_to_active_state
    passwords(:quentin).suspend!
    assert passwords(:quentin).suspended?
    passwords(:quentin).unsuspend!
    assert passwords(:quentin).active?
  end

  def test_should_unsuspend_password_with_nil_activation_code_and_activated_at_to_passive_state
    passwords(:quentin).suspend!
    Password.update_all :activation_code => nil, :activated_at => nil
    assert passwords(:quentin).suspended?
    passwords(:quentin).reload.unsuspend!
    assert passwords(:quentin).passive?
  end

  def test_should_unsuspend_password_with_activation_code_and_nil_activated_at_to_pending_state
    passwords(:quentin).suspend!
    Password.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert passwords(:quentin).suspended?
    passwords(:quentin).reload.unsuspend!
    assert passwords(:quentin).pending?
  end

  def test_should_delete_password
    assert_nil passwords(:quentin).deleted_at
    passwords(:quentin).delete!
    assert_not_nil passwords(:quentin).deleted_at
    assert passwords(:quentin).deleted?
  end

protected
  def create_password(options = {})
    record = Password.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
