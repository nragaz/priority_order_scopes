class CreateWorkQueues < ActiveRecord::Migration
  def change
    create_table :work_queues do |t|
      t.datetime :started_at
      t.string :job

      t.timestamps
    end
  end
end
