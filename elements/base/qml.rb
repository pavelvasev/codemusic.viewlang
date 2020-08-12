# получается что эта штука.. добавляет return и прокидывает ее на уровень pass2
@edic.add_rule( "func", [:func], lambda { |obj,args,nxt|
  r = obj.dup
  r[:items] = @edic.get_data( args )
  if r[:items][-1] && r[:items][-1] !~ /return/
    r[:items][-1] = [{:tag => :expression, :expression => "return /* generated by 1-basis/epass */ ", :items => [r[:items][-1].dup]}]
  end
  r
})
    
@edic.add_rule( "prop", [:property], lambda { |obj,args,nxt|
  v  = @edic.get_data( args )
  [{:tag => :property, :name => obj[:name], :value => v}]
})

@edic.add_rule( "prop_e", [:property_e], lambda { |obj,args,nxt|
  v  = @edic.get_data( args )
  [{:tag => :property_e, :name => obj[:name], :value => v}]
})

@edic.add_rule( "prop_set", [:property_set], lambda { |obj,args,nxt|
  v  = @edic.get_data( args )
  [{:tag => :property_set, :name => obj[:name], :value => v}]
})

@edic.add_rule( "prop_set_e", [:property_set_e], lambda { |obj,args,nxt|
  v  = @edic.get_data( args )
  [{:tag => :property_set_e, :name => obj[:name], :value => v}]
})

# $edic_objects_autoid 
@edic.add_rule( "object", [:object], lambda { |obj,args,nxt|
  r = obj.dup
  #STDERR.puts "herewe"
  r[:object] = obj[:type] if obj[:type]
  #STDERR.puts "r[:object] = #{r[:object]}"
  r[:items]  = @edic.get_data( args )
  #STDERR.puts "herewe returns: #{r}"
  r[:ocomment] = "object generated by :object epass rule"
  [r]
})

@edic.add_rule( "array-expression", [:array_expression], lambda { |obj,args,nxt|
  v  = @edic.get_data( args )
  [{:tag => :array_expression, :items => v}]
})