class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionHelper

  private

  def logged_in_student
    return if logged_in_student?
    flash[:danger] = "ログインをお願いします！"
    redirect_to login_path
  end

  def logged_in_company
    return if logged_in_company?
    flash[:danger] = "ログインをお願いします！"
    redirect_to login_path
  end

  def set_search
    @q= Work.where(["status = ? and process_status = ?", true, false]).search(params[:q])
  end
end
