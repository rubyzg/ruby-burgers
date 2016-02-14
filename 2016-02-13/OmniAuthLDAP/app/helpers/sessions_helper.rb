module SessionsHelper

  def sign_in(user)
    reset_session
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    reset_session
  end

  def signed_in?
    current_user.present?
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try(:id)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

end
