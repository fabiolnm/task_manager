class Task < ActiveRecord::Base
  belongs_to :task_list

  validates :task_list, :description, presence: true

  default_scope { order created_at: :asc }

  def change_status_action
    closed_at ? :reopen : :close
  end
end
