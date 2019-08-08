class WorksController < ApplicationController
  before_action :set_search
  before_action :logged_in_company, only: [:edit, :update]
  before_action :find_work, only: [:edit, :update]
  
  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      flash.now[:success] = "Create Work successed!"
      redirect_to @work
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
    @work = Work.find(params[:id])
    Work.find(@work.id).destroy
    redirect_to works_company_path(current_company.id)
  end

  def update
    if @work.update_attributes work_params
      flash[:success] = "アプデートしました！"
      redirect_to @work
    else
      render :edit
    end
  end

  def index
    if params[:q].present?
      @q = Work.where(["status = ? and process_status = ?", true, false]).search(params[:q])
      @works = @q.result(distinct: true).page(params[:page]).per 7
    else
      @works = Work.where(["status = ? and process_status = ?", true, false]).all.page(params[:page]).per 7
    end
  end

  def show
    @work = Work.find(params[:id])
    @date_count = (@work.dateline.to_date - DateTime.now.to_date).to_i

    if logged_in_company?
      @workList = Work.find_by_sql(["select * from works where id = ? and company_id = ?", @work.id, current_company.id])
      if @workList.length == 0
        @hasWork = 0;
      else
        @hasWork = 1;
        @studentWorkStatus = StudentWorkStatus.find_by_sql(["select * from student_work_statuses where work_id = ?", @work.id])
      end
    else
      if logged_in_student? == false
        @hasJob = 2;
      else
        @joblist = StudentWorkStatus.find_by_sql(["select * from student_work_statuses where work_id = ? and student_id = ?", @work.id, current_student.id]);
        if (@joblist.length == 0)
          @hasJob = 0;
        else
          @hasjob = 1;
          @job = @joblist.first
        end
      end
    end

  end

  private

  def work_params
    params.require(:work).permit(:title, :company_id, :dateline,
                                 :salary,
                                 :tag,
                                 :work_location,
                                 :content,
                                 :status,
                                 :process_status
    )
  end

  def find_work
    @work = Work.find_by id: params[:id]
  end
end
