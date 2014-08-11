class TaskList < ActiveRecord::Base
  validates :name, presence: true

  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks

  default_scope { order created_at: :asc }
end
