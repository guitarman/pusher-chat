module ApplicationHelper
  def sign_in
    unless session[:user_id]
      rand_id = rand(User.count)
      session[:user_id] = rand_id
    end
  end

  def current_user
    @current_user ||= User.current(session[:user_id])
  end
end
