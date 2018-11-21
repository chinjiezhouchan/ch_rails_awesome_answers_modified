class CreateDelayedJobs < ActiveRecord::Migration[5.2]
  def self.up
    create_table :delayed_jobs, force: true do |table|
      # Priority 2 is before Priority 0. 
      table.integer :priority, default: 0, null: false # Allows some jobs to jump to the front of the queue

      # `Attempts` means it tries once, then gives you a chance to fix errors, then it tries again x times.
      table.integer :attempts, default: 0, null: false # Provides for retries, but still fail eventually.
      
      # Without `handler`, the job is just a row in the database, and you don't know
      # Tells where to find the code, what kind it is.
      # Almost like a callback, except only tells where the code is.
      table.text :handler,                 null: false # YAML-encoded string of the object that will do work

      table.text :last_error                           # reason for last failure (See Note below)
      table.datetime :run_at                           # When to run. Could be Time.zone.now for immediately, or sometime in the future.
      
      # `locked_at` is important because your app might have lots of workers. Each worker picks a job off the queue, and locks that job, so that other workers can't work on it, until it finishes.
      table.datetime :locked_at                        # Set when a client is working on this object
      table.datetime :failed_at                        # Set when all retries have failed (actually, by default, the record is deleted instead)

      # `locked_by` shows who is working on it.

      table.string :locked_by                          # Who is working on this object (if locked)

      # `queue` : One worker can handle one queue, another worker can handle another queue. Helps organize jobs. Each job can be like one row in the queue. The worker will pick off one row at a time from the queue.
      table.string :queue                              # The name of the queue this job is in
      table.timestamps null: true
    end

    add_index :delayed_jobs, [:priority, :run_at], name: "delayed_jobs_priority"
  end

  def self.down
    drop_table :delayed_jobs
  end
end
