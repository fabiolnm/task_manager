class TaskListsController < ApplicationController
  before_action :set_new_task_and_task_list, only: [:index, :show]
  before_action :set_task_list, only: [:show, :edit, :update, :destroy]

  helper_method :task_list_delete_confirmation_message

  # GET /task_lists
  def index
  end

  # GET /task_lists/1
  def show
    render :index
  end

  # GET /task_lists/1/edit
  def edit
  end

  # POST /task_lists
  def create
    @new_task_list = TaskList.new task_list_params

    if @new_task_list.save
      redirect_to @new_task_list, notice: t(:success)
    else
      @task_lists = TaskList.all
      render :index
    end
  end

  # PATCH/PUT /task_lists/1
  def update
    if @task_list.update(task_list_params)
      redirect_to @task_list, notice: t(:success)
    else
      set_new_task_and_task_list

      if @task_list.errors['tasks.description'].present?
        @task_error = @task_list.errors.full_messages.first
        render :index
      else
        render :edit
      end
    end
  end

  def change_task_status
    task = Task.find params[:id]

    case params[:task_action]
    when 'close'
      task.update closed_at: Time.current
    when 'reopen'
      task.update closed_at: nil
    end

    redirect_to task.task_list
  end

  def delete_task
    task = Task.find params[:id]

    task.destroy

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

  def task_list_delete_confirmation_message(task_list)
    tasks_count = task_list.tasks.count
    if tasks_count == 0
      t :confirm_list_without_tasks_deletion,
        scope: :actions, name: task_list.name
    else
      t :confirm_list_with_tasks_deletion,
        scope: :actions, name: task_list.name, tasks: task_list.tasks.count
    end
  end

  def set_new_task_and_task_list
    @new_task_list  = TaskList.new
    @task_lists     = TaskList.all
  end
end
