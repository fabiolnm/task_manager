require "test_helper"

describe TaskListsController do
  let(:task_list) { task_lists :one }

  it "gets index" do
    get :index
    assert_response :success
    assigns(:task_lists).wont_be_nil
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates task_list" do
    lambda {
      post :create, task_list: { name: 'A simple task' }
    }.must_change ->{ TaskList.count }

    assert_redirected_to task_list_path assigns :task_list
  end

  it "validates new task_list" do
    lambda {
      post :create, task_list: { name: '' }
    }.wont_change ->{ TaskList.count }

    assert_template :new
  end

  it "shows task_list" do
    get :show, id: task_list
    assert_response :success
  end

  it "creates nested tasks" do
    lambda {
      put :update, id: task_list, task_list: {
        tasks_attributes: [
          { description: 'Finish Engage challenge' }
        ]
      }
    }.must_change ->{ Task.count }

    assert_redirected_to task_list
  end

  it "validates nested tasks" do
    lambda {
      put :update, id: task_list, task_list: {
        tasks_attributes: [
          { description: '' }
        ]
      }
    }.wont_change ->{ Task.count }

    assert_template :show
    assert_select '.has-error label',
      "#{Task.human_attribute_name :description} #{error_message :blank}"
  end

  it "closes open task" do
    task = tasks :open_task
    raise 'task must be open to avoid false positive' if task.closed_at

    post :change_task_status, id: task, task: { action: 'close' }


    assert_redirected_to task.task_list

    task.reload.closed_at.wont_be_nil
  end

  it "gets edit" do
    get :edit, id: task_list
    assert_response :success
  end

  it "updates task_list" do
    put :update, id: task_list, task_list: { name: 'A hard task' }
    assert_redirected_to task_list_path assigns :task_list
  end

  it "validates existing task_list" do
    put :update, id: task_list, task_list: { name: '' }
    assert_template :edit
  end

  it "destroys task_list" do
    lambda {
      delete :destroy, id: task_list
    }.must_change ->{ TaskList.count }, -1

    assert_redirected_to :task_lists
  end
end
