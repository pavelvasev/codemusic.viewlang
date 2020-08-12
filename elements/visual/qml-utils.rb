def insert_attr_into_object( obj_result, name, value )
   q = obj_result # [0] забавно, в отличие от кода deploy_property у нас тут объект сразу норм приходит..
   q[:attrs] ||= {}
   q[:attrs][name] ||= value
   obj_result
end

def insert_item_into_object( obj_result, item ) 
  # STDERR.puts "arrived obj_r=#{obj_result}"
  q = obj_result
  q[:items] ||= []
  q[:items].push item
  obj_result
end

@dic.add_rule( [0,"insert_item_into_object"], [:insert_item_into_object], lambda { |obj,args,nxt|
  q = @edic.get_data( args )
  insert_item_into_object( q[0],q[1] )
})

@dic.add_rule( [0,"insert_attr_into_object"], [:insert_attr_into_object], lambda { |obj,args,nxt|
  q = @edic.get_data( args )
  insert_attr_into_object( q[0],q[1],q[2] )
})