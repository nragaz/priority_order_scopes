PriorityOrderScopes
===================

Flip through Active Record models in order, using next and previous scopes and instance methods.

Example
-------

    create_table "jobs" do |t|
      t.string "name"
      t.datetime "started_at"
    end
    
    class Job < ActiveRecord::Base
      include PriorityOrderScopes
      
      priority_order_scopes "started_at"
    end
    
    Job.priority_order # => Job.order("started_at")
    
    # by default, next and previous use the priority order (unless there
    # is a default_scope with an order defined)
    
    Job.next(Job.priority_order.first) # => the job that starts second
    Job.previous(Job.priority_order.first) # => nil
    Job.previous(second_job) # => Job.priority_order.first
    
    # next and previous class methods respect the current scope
    
    Job.order('name').next(Job.first) # => the job with the next name
    
    # next and previous instance methods always use priority order
    
    job = Job.priority_order.first
    job.next # => the job that starts second
    
    job = Job.order('name').first
    job.previous # => the job that starts before the first job in alpha order