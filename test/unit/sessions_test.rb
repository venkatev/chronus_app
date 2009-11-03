require File.dirname(__FILE__) + '/../test_helper'

class SessionsTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :sessions

  def test_should_create_sessions
    assert_difference 'Sessions.count' do
      sessions = create_sessions
      assert !sessions.new_record?, "#{sessions.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    sessions = create_sessions
    sessions.reload
    assert_not_nil sessions.activation_code
  end

  def test_should_create_and_start_in_pending_state
    sessions = create_sessions
    sessions.reload
    assert sessions.pending?
  end


  def test_should_require_login
    assert_no_difference 'Sessions.count' do
      u = create_sessions(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Sessions.count' do
      u = create_sessions(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Sessions.count' do
      u = create_sessions(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Sessions.count' do
      u = create_sessions(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    sessions(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal sessions(:quentin), Sessions.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    sessions(:quentin).update_attributes(:login => 'quentin2')
    assert_equal sessions(:quentin), Sessions.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_sessions
    assert_equal sessions(:quentin), Sessions.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    sessions(:quentin).remember_me
    assert_not_nil sessions(:quentin).remember_token
    assert_not_nil sessions(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    sessions(:quentin).remember_me
    assert_not_nil sessions(:quentin).remember_token
    sessions(:quentin).forget_me
    assert_nil sessions(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    sessions(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil sessions(:quentin).remember_token
    assert_not_nil sessions(:quentin).remember_token_expires_at
    assert sessions(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    sessions(:quentin).remember_me_until time
    assert_not_nil sessions(:quentin).remember_token
    assert_not_nil sessions(:quentin).remember_token_expires_at
    assert_equal sessions(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    sessions(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil sessions(:quentin).remember_token
    assert_not_nil sessions(:quentin).remember_token_expires_at
    assert sessions(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_sessions
    sessions = create_sessions(:password => nil, :password_confirmation => nil)
    assert sessions.passive?
    sessions.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    sessions.register!
    assert sessions.pending?
  end

  def test_should_suspend_sessions
    sessions(:quentin).suspend!
    assert sessions(:quentin).suspended?
  end

  def test_suspended_sessions_should_not_authenticate
    sessions(:quentin).suspend!
    assert_not_equal sessions(:quentin), Sessions.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_sessions_to_active_state
    sessions(:quentin).suspend!
    assert sessions(:quentin).suspended?
    sessions(:quentin).unsuspend!
    assert sessions(:quentin).active?
  end

  def test_should_unsuspend_sessions_with_nil_activation_code_and_activated_at_to_passive_state
    sessions(:quentin).suspend!
    Sessions.update_all :activation_code => nil, :activated_at => nil
    assert sessions(:quentin).suspended?
    sessions(:quentin).reload.unsuspend!
    assert sessions(:quentin).passive?
  end

  def test_should_unsuspend_sessions_with_activation_code_and_nil_activated_at_to_pending_state
    sessions(:quentin).suspend!
    Sessions.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert sessions(:quentin).suspended?
    sessions(:quentin).reload.unsuspend!
    assert sessions(:quentin).pending?
  end

  def test_should_delete_sessions
    assert_nil sessions(:quentin).deleted_at
    sessions(:quentin).delete!
    assert_not_nil sessions(:quentin).deleted_at
    assert sessions(:quentin).deleted?
  end

protected
  def create_sessions(options = {})
    record = Sessions.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
