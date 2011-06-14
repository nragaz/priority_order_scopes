module PriorityOrderScopes
  extend ActiveSupport::Concern
  
  module ClassMethods
    # Include PriorityOrderScopes and call 'priority_order_scopes' with a column
    # name (and optional direction) to create `priority_order`, `next` and
    # `previous` scopes.
    #
    # `next and `previous` require a record to start from. They will use the
    # current scope if passed as part of a chain (or if a default scope with 
    # an order clause is defined), or default to the priority order.
    #
    # You can also call instance.next or instance.previous directly. This will
    # always use the default scope or the priority order.
    def priority_order_scopes(col, dir=:asc)
      @priority_order_column = col
      @priority_order_direction = dir
      
      class << self
        define_method :priority_order do
          reorder("#{table_name}.#{@priority_order_column} #{@priority_order_direction}")
        end
        
        define_method :next do |current|
          return unless current
          
          # use the current scope's order clause, if any, or the priority order
          order = scoped.order_clauses[0] || priority_order.order_clauses[0]
          # turn ["last_name DESC, first_name", "id"] into "last_name"
          order = order.split(", ")[0]
          operator = order =~ /desc/i ? '<' : '>'
          order_column = order.split(" ")[0].split(".").last
          
          where(
            "#{table_name}.#{order_column} #{operator} ?",
            current.send(order_column)
          ).
          limit(1)
        end
        
        define_method :previous do |current|
          return unless current
          
          # use the current scope's order clause, if any, or the priority order
          order = scoped.order_clauses[0] || priority_order.order_clauses[0]
          # turn ["last_name DESC, first_name", "id"] into "last_name"
          order = order.split(", ")[0]
          
          operator = order =~ /desc/i ? '>' : '<'
          order_column = order.split(" ")[0].split(".").last
          
          where(
            "#{table_name}.#{order_column} #{operator} ?",
            current.send(order_column)
          ).
          reverse_order.
          limit(1)
        end
      end
      
      define_method :next do
        self.class.priority_order.next(self).first
      end
      
      define_method :previous do
        self.class.priority_order.previous(self).first
      end
    end
  end
end
