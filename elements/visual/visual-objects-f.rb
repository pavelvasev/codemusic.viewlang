@edic.add_rule( [5,"rule_vis_linesf"], [:visf,:lines], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "Lines"
   q[:attrs] ||= {}
   q[:attrs][:positions] ||= "combine_arrays( input_0, input_1, input_2, input_3, input_4, input_5 )"

  r
})

@edic.add_rule( [5,"rule_vis_crelinesf"], [:visf,:creative_lines], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "CreLines"
   q[:attrs] ||= {}
   q[:attrs][:positions] ||= "combine_arrays( input_0, input_1, input_2, input_3, input_4, input_5 )"   

  r
})


@edic.add_rule( [5,"rule_vis_pointsf"], [:visf,:points], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "Points"
   q[:attrs] ||= {}
   q[:attrs][:positions] ||= "combine_arrays( input_0, input_1, input_2 )"

  r
})

@edic.add_rule( [5,"rule_vis_pointsf"], [:visf,:creative_points], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "CrePoints"
   q[:attrs] ||= {}
   q[:attrs][:positions] ||= "combine_arrays( input_0, input_1, input_2 )"

  r
})



@edic.add_rule( [5,"rule_vis_linestripf"], [:visf,:linestrip], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "Linestrip"
   q[:attrs] ||= {}

#   q[:attrs][:positions] ||= @edic.eval( { :computing_mode => 1, :items => [{:tag => "combine_arrays", :items => ["input_0","input_1","input_2"] }]} )
   q[:attrs][:positions] ||= {:tag => :expression,:expression => "combine_arrays( input_0, input_1, input_2 )" }
   # combine_arrays это метод Scene2

  r
})

@edic.add_rule( [5,"rule_vis_linestripf"], [:visf,:cstrip], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "Cylinderstrip"
   q[:attrs] ||= {}

#   q[:attrs][:positions] ||= @edic.eval( { :computing_mode => 1, :items => [{:tag => "combine_arrays", :items => ["input_0","input_1","input_2"] }]} )
   q[:attrs][:positions] ||= {:tag => :expression, :expression => "combine_arrays( input_0, input_1, input_2 )" }
   # combine_arrays это метод Scene2

  r
})

@edic.add_rule( [5,"rule_vis_spheresf"], [:visf,:spheres], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "Spheres"
   q[:attrs] ||= {}
   q[:attrs][:positions] ||= "combine_arrays(input_0,input_1,input_2)"

   r
})

@dic.add_rule( [5,"rule_vis_trimesh"], [:visf,:mesh], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "Trimesh"
   q[:attrs] ||= {}
   q[:attrs][:positions] ||= "combine_arrays(input_0,input_1,input_2)"
   q[:attrs][:indices] ||= "combine_arrays( input_3, input_4, input_5 )"

   r
})

@edic.add_rule( [5,"rule_vis_crelinesf"], [:visf,:creative_mesh], lambda { |obj,args,nxt|

   r = @edic.call( obj,args, nxt )
   
   q = r[0]

   q[:object] = "CreativeTrimesh"
   q[:attrs] ||= {}
   
   q[:attrs][:positions] ||= "combine_arrays(input_0,input_1,input_2)"
   q[:attrs][:indices] ||= "combine_arrays( input_3, input_4, input_5 )"

   r
})