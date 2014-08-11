class TaskListsController < ApplicationController
  before_action :set_task_list, only: [:show, :edit, :update, :destroy]

  # GET /task_lists
  def index
    @task_lists = TaskList.all
  end

  # GET /task_lists/1
  def show
  end

  # GET /task_lists/new
  def new
    @task_list = TaskList.new
  end

  # GET /task_lists/1/edit
  def edit
  end

  # POST /task_lists
  def create
    @task_list = TaskList.new(task_list_params)

    if @task_list.save
      redirect_to @task_list, notice: t(:success)
    else
      render :new
    end
  end

  # PATCH/PUT /task_lists/1
  def update
    if @task_list.update(task_list_params)
      redirect_to @task_list, notice: t(:success)
    else
      if @task_list.errors['tasks.description'].present?
        @task_error = @task_list.errors.full_messages.first
        render :show
      else
        render :edit
      end
    end
  end

  def change_task_status
    task = Task.find params[:id]
    task.update closed_at: Time.current
    redirect_to task.task_list
  end

  # DELETE /task_lists/1
  def destroy
    @task_list.destroy
    redirect_to task_lists_url, notice: t(:success)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task_list
    @task_list = TaskList.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def task_list_params
    params[:task_list].permit :name, tasks_attributes: [ :description ]
  end
end
