class TaskList < ActiveRecord::Base
  validates :name, presence: true
end
