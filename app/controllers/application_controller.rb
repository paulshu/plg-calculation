class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_admin!
    if current_user.role != "admin"
      flash[:alert] = "您的权限不足"
      redirect_to root_path
    end
  end
  
end
