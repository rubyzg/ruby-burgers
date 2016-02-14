class SessionsController < ApplicationController

  # omniauth form builder doesn't submit authenticity_token
  skip_before_action :verify_authenticity_token, only: [:create]

  include SessionsHelper

  def create
    unless auth && auth.valid?
      redirect_to((request.env['HTTP_REFERER'] || root_path), alert: 'Unauthorized')
      return
    end

    Rails.logger.debug "creating session for user identity provider: #{params['provider']}"
    # build user stub
    user = User.find_by(email: auth.info.email)

    sign_in(user)
    redirect_to root_path, notice: "User signed in as #{current_user}"
  end

  def auth_failure
    # if user authentication fails on the provider side,
    #   OmniAuth will catch the response and then redirect the request to the path /auth/failure,
    #   passing a corresponding error message in a params[:message]

    sign_out
    flash[:error] = "Authentication failed: #{t params[:message]}"
    redirect_to root_path
  end

  def destroy
    user_name = current_user.try(:name)
    sign_out
    redirect_to root_path, notice: "User #{user_name} has just signed out"
  end

  private

  def strategy
    request.env["omniauth.strategy"]
  end

  def auth
    request.env['omniauth.auth']
  end

end
