require 'test_helper'

class PriorityOrderScopesTest < ActiveSupport::TestCase
  test "create scopes" do
    assert_kind_of ActiveRecord::Relation, WorkQueue.priority_order
    assert_kind_of ActiveRecord::Relation, WorkQueue.previous(WorkQueue.first)
    assert_kind_of ActiveRecord::Relation, WorkQueue.next(WorkQueue.first)
  end
  
  test "create instance methods" do
    job = WorkQueue.first
    
    assert job.respond_to?(:next)
    assert job.respond_to?(:previous)
  end
  
  test "return jobs in priority order" do
    jobs = WorkQueue.priority_order
    
    assert_equal "Job 1", jobs.first.job
    assert_equal "Job 3", jobs.last.job
  end
  
  test "return the next and previous jobs from a scope" do
    second_job = WorkQueue.find_by_job("Job 2")
    
    assert_equal "Job 1", WorkQueue.previous(second_job).first.job
    assert_equal "Job 3", WorkQueue.next(second_job).first.job
  end
  
  test "respect the current scope in next and previous" do
    second_job = WorkQueue.find_by_job("Job 2")
    scope = WorkQueue.order('job DESC')
    
    assert_equal "Job 3", scope.previous(second_job).first.try(:job)
    assert_equal "Job 1", scope.next(second_job).first.try(:job)
  end
  
  test "don't respect the current scope in priority_order" do
    scope = WorkQueue.order('started_at DESC')
    
    assert_equal "Job 3", scope.first.job, scope.to_sql
    assert_equal "Job 1", scope.priority_order.first.job
    assert_equal "Job 3", scope.priority_order.last.job
  end
  
  test "instance provides the next and previous jobs in priority order" do
    first_job = WorkQueue.find_by_job("Job 1")
    
    assert_nil first_job.previous
    assert_equal "Job 2", first_job.next.job
    
    second_job = WorkQueue.find_by_job("Job 2")
    
    assert_equal "Job 1", second_job.previous.job
    assert_equal "Job 3", second_job.next.job
    
    third_job = WorkQueue.find_by_job("Job 3")
    
    assert_nil third_job.next
    assert_equal "Job 2", third_job.previous.job
  end
end
