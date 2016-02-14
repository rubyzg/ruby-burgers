require "minitest/mock"
require "stubs/ldap"
require "test_helper"

class LdapLoginLogoutTest < ActionDispatch::IntegrationTest

  test "happy path" do
    assert_successful_login
    assert_successful_logout
  end

  test "fail with invalid_credentials due to wrong email and password" do
    visit_login_page
    login_with_ldap_stub(email: "wrong@promdm.net", password: "wrongpass")
    follow_redirect_and_assert_failure
    assert_includes flash[:error], "Authentication failed: #{I18n.t :invalid_credentials}"
  end

  test "fail with invalid_credentials due to wrong password" do
    visit_login_page
    login_with_ldap_stub(email: "zm@promdm.net", password: "wrongpass")
    follow_redirect_and_assert_failure
    assert_includes flash[:error], "Authentication failed: #{I18n.t :invalid_credentials}"
  end

  test "fail with missing_credentials" do
    visit_login_page
    login_with_ldap_stub(email: "zm@promdm.net", password: "")
    follow_redirect_and_assert_failure
    assert_includes flash[:error], "Authentication failed: #{I18n.t :missing_credentials}"
  end

  private

  def assert_successful_login
    visit_login_page
    login_with_ldap_stub(email: "zm@promdm.net", password: "correctpass")
    assert_redirected_to root_path
    assert_includes flash[:notice], "User signed in as Dummy User"
    refute flash[:error]
  end

  def assert_successful_logout
    get sign_out_path
    assert_redirected_to root_path
    assert_includes flash[:notice], "User Dummy User has just signed out"
    refute flash[:error]
  end

  def visit_login_page
    https!
    get "/"
    assert_equal 200, status
  end

  def login_with_ldap_stub(email:, password:)
    Net::LDAP.stub :new, Stubs::Ldap.new do
      post "/auth/ldap/callback", mail: email, password: password
    end
  end

  def follow_redirect_and_assert_failure
    follow_redirect!
    assert_equal 302, status
    assert_equal "/auth/failure", path
    refute flash[:notice]
  end
end
