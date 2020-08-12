def deploy_property_new( obj_result, name, value )
   q = obj_result[0]
   STDERR.puts "depl new.. name=#{name} q=#{q} value=#{value}"
   q[:items] ||= []
   q[:items].push( {:tag => :property_e,:name=>name, :value => value } )
   obj_result
end

@dic.add_rule( [3,"guitag_panel"], [nil,:gui_panel], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   deploy_property_new( r, :tag, "'#{obj[:gui_panel]}'" )
})

@dic.add_rule( [3,"guitext"], [nil,:gui_text], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   STDERR.puts "guitext finished. gonna deploy property"
   deploy_property( r, :text, obj[:gui_text] )
})

@dic.add_rule( [3,"guiwidth"], [nil,:gui_width], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   deploy_property( r, :width, obj[:gui_width] )
})

@dic.add_rule( [3,"guiheight"], [nil,:gui_height], lambda { |obj,args,nxt|
   r = @edic.call( obj,args, nxt )
   deploy_property( r, :height, obj[:gui_height] )
})

################# default
@dic.add_rule( [5,"guitag-default"], [:param], lambda { |obj,args,nxt|
   obj[:gui_panel] ||= "left"
   r = @edic.call( obj,args, nxt )
#   deploy_property_new( r, :tag, "'#{obj[:gui_panel]}'" )
})