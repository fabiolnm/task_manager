require "test_helper"

describe TaskListsController do
  let(:task_list) { task_lists :one }

  it "gets index" do
    get :index
    assert_response :success

    assert_select "form#new_task_list"
    assert_select "ul#task_list li", count: TaskList.count
  end

  it "creates task_list" do
    lambda {
      post :create, task_list: { name: 'A simple task' }
    }.must_change ->{ TaskList.count }

    assert_redirected_to task_list_path assigns :new_task_list
  end

  it "creates task_list via xhr" do
    lambda {
      xhr :post, :create, task_list: { name: 'A simple task' }
    }.must_change ->{ TaskList.count }

    assert_redirected_via_turbolinks_to task_list_url assigns :new_task_list
  end

  it "validates new task_list" do
    lambda {
      post :create, task_list: { name: '' }
    }.wont_change ->{ TaskList.count }

    assert_template :index
  end

  it "shows task_list" do
    get :show, id: task_list
    assert_template :index
  end

  it "gets edit" do
    get :edit, id: task_list

    assert_template :index
    assert_select "#edit_task_list_#{task_list.id}"
  end

  it "updates task_list" do
    put :update, id: task_list, task_list: { name: 'A hard task' }
    assert_redirected_to task_list_path assigns :task_list
  end

  it "updates task_list via xhr" do
    xhr :put, :update, id: task_list, task_list: { name: 'A hard task' }
    assert_redirected_via_turbolinks_to task_list_url task_list
  end

  it "validates existing task_list" do
    put :update, id: task_list, task_list: { name: '' }

    assert_template :index
    assert_select "#edit_task_list_#{task_list.id}"
  end

  it "destroys task_list" do
    lambda {
      lambda {
        delete :destroy, id: task_list
      }.must_change ->{ Task.count    }, -task_list.tasks.count
    }.must_change ->{ TaskList.count  }, -1

    assert_redirected_to :task_lists
  end

  it "destroys task_list via xhr" do
    lambda {
      lambda {
        xhr :delete, :destroy, id: task_list
      }.must_change ->{ Task.count    }, -task_list.tasks.count
    }.must_change ->{ TaskList.count  }, -1

    assert_redirected_via_turbolinks_to task_lists_url
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

    assert_template :index
    assert_select '.has-error label',
      "#{Task.human_attribute_name :description} #{error_message :blank}"
  end

  it "closes open task" do
    task = tasks :open_task
    raise 'task must be open to avoid false positive' if task.closed_at

    post :change_task_status, id: task, task_action: 'close'
    assert_redirected_to task.task_list

    task.reload.closed_at.wont_be_nil
  end

  it "reopens closed task" do
    task = tasks :closed_task
    raise 'task must be closed to avoid false positive' unless task.closed_at

    post :change_task_status, id: task, task_action: 'reopen'
    assert_redirected_to task.task_list

    task.reload.closed_at.must_be_nil
  end

  it "closes open task via xhr" do
    task = tasks :open_task
    raise 'task must be open to avoid false positive' if task.closed_at

    xhr :post, :change_task_status, id: task, task_action: 'close'
    assert_redirected_via_turbolinks_to task_list_url task.task_list

    task.reload.closed_at.wont_be_nil
  end

  it "reopens closed task via xhr" do
    task = tasks :closed_task
    raise 'task must be closed to avoid false positive' unless task.closed_at

    xhr :post, :change_task_status, id: task, task_action: 'reopen'
    assert_redirected_via_turbolinks_to task_list_url task.task_list

    task.reload.closed_at.must_be_nil
  end

  it "deletes task" do
    task = tasks :closed_task

    lambda {
      delete :delete_task, id: task
    }.must_change ->{ Task.count }, -1

    assert_redirected_to task.task_list
  end
end
