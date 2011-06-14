class WorkQueue < ActiveRecord::Base
  include PriorityOrderScopes
  
  priority_order_scopes 'started_at'
end
