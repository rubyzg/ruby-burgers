require "minitest/mock"
require "stubs/ldap"
require "test_helper"

class SessionsControllerTest < ActionController::TestCase

  setup do
    @user = User.find_by(id: 1)
  end

  test "destroy session" do
    get :destroy, {}, session_params
    assert_redirected_to root_path
    assert_includes flash[:notice], "User #{@user.name} has just signed out"
    refute flash[:error]
  end

  private

  def session_params
    # current_user is @user
    { user_id: @user.id }
  end

end
