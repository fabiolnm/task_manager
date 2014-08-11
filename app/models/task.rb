class Task < ActiveRecord::Base
  belongs_to :task_list

  validates :task_list, :description, presence: true

  def change_status_action
    closed_at ? :reopen : :close
  end
end
