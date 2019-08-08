class StaticPagesController < ApplicationController
  before_action :set_search
  def home 
    @top_high_salary_works = Work.where(["status = ? and process_status = ?", true, false]).order(salary: :desc).first(2)
    @top_recent_works = Work.where(["status = ? and process_status = ?", true, false]).order(dateline: :asc).first(4)

    if params[:q].present?
      @q = Work.where(["status = ? and process_status = ?", true, false]).search(params[:q])
      @works = @q.result(distinct: true).page(params[:page]).per 7
    else
      @works = Work.where(["status = ? and process_status = ?", true, false]).all.page(params[:page]).per 7
    end
  end

  def help
  end

end
