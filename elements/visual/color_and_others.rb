def deploy_property( obj_result, name, value )
   q = obj_result[0]
   q[:attrs] ||= {}
   #q[:attrs][name] ||= value
   # TODO или тут ||= ?
   q[:attrs][name] = value
   obj_result
end

def deploy_property_arr( obj_result, name, value )
   q = obj_result[0]
   q[:attrs] ||= {}
   q[:attrs][name] ||= {:tag => :array_expression, :items => []}
   # это мне надо было для шейдеров; а при этом viewlang умеет работать с массивами-массивов шейдеров
#   if value.is_a?(Array)
#     q[:attrs][name][:items].concat value
#   else
     q[:attrs][name][:items].push value
#   end
   obj_result
end

def deploy_item( obj_result, item )
   q = obj_result[0]
   q[:items] ||= []
   q[:items].push item
   obj_result
end

@dic.add_rule( [3,"color"], [:vis,:color], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   STDERR.puts "color deployed"
   deploy_property( r, :color, obj[:color] )
})

@dic.add_rule( [3,"colors"], [:vis,:colors], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :colors, obj[:colors] )
})

@dic.add_rule( [3,"radius"], [:vis,:radius], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :radius, obj[:radius] )
})

@dic.add_rule( [3,"radiuses"], [:vis,:radiuses], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :radiuses, obj[:radiuses] )
})

@dic.add_rule( [3,"visible"], [:vis,:visible], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :visible, obj[:visible] )
})

@dic.add_rule( [3,"flat"], [:vis,:flat], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :flat, obj[:flat] )
})

@dic.add_rule( [3,"shine"], [:vis,:shine], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :shine, obj[:shine] )
})

@dic.add_rule( [3,"wire"], [:vis,:wire], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :wire, obj[:wire] )
})

@dic.add_rule( [3,"opacity"], [:vis,:opacity], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :opacity, obj[:opacity] )
})

@dic.add_rule( [3,"scale"], [:vis,:scale], lambda { |obj,args,nxt|
  r = @edic.call( obj,args,nxt )
  deploy_property( r, :scale, obj[:scale] )
})

$shaders_id_counter = 0
@dic.add_rule( [3,"shaderz"], [:vis,:shaderz], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   pcoef = obj[:shaderz] 
   pcoef = 5000 if pcoef.is_a?(Array) && pcoef.length==0

   code = {:tag => :object, :type => "ShaderZ", :attrs => { :pcoef => pcoef } }
   code2 = @dic.eval( code )
   code2[0][:id] ||= begin
     $shaders_id_counter=$shaders_id_counter+1
     "shader_#{$shaders_id_counter}"
   end

   STDERR.puts "shaderz deployed, code2=#{code2.inspect}"
   deploy_property_arr( r, :shader, code2[0][:id] || "id_undefined" )
   deploy_item( r, code2 )
})

@dic.add_rule( [3,"shaders"], [:vis,:shaders], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   
   # obj[:shaders] = объекты шейдеров
#   STDERR.puts "gonna embed ids to:#{ obj[:shaders].inspect}"
#   ids = obj[:shaders].map{ |o| 
#      
#      o[:id] ||= begin
#        $shaders_id_counter=$shaders_id_counter+1
#       "shader_#{$shaders_id_counter}"
#      end
#   }
   
   deploy_property_arr( r, :shader, obj[:shaders] )
#   deploy_item( r, obj[:shaders] )
})