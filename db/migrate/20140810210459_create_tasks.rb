class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :task_list, index: true

      t.text :description
      t.datetime :closed_at

      t.timestamps
    end
  end
end
