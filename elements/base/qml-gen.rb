@ruby_object_counter=0
@dic.add_rule( [5,"object_id"], [:object], lambda { |obj,args,nxt|
  if obj[:id].nil?
    obj[:id] = "obj_#{@ruby_object_counter}"
    @ruby_object_counter=@ruby_object_counter+1
  end
  @dic.call( obj,args,nxt )
} )

# исправляет некоторые неполадки парсера qmlweb
def fix_prop( val )
  val = val.to_s
  if val =~ /^\s*function/
    val = "{\nvar q=#{val};\nreturn q;\n}"
  elsif val == ""
    val = "undefined"
  end
  val
end

def fix_name( name )
  if name.is_a?(Array)
    return name.join("")
  end
  name
end

@dic.add_rule( [1,"unwind_if_in_property"],[nil,:unwind_if_in_property,:id], lambda { |obj,args,nxt|
  #:unwind_if_in_property
  objcode = @dic.call( obj,args,nxt ) #eval( robj, :padding => args[:padding] )
  [ "#{obj[:id]}.output /* .output placed by 1-basis/pass2 */", {:extra_object_code => objcode} ]
})

@dic.add_rule( "object", [:object], lambda { |obj,args,nxt|
   mypadding = args[:padding] || 0 # короче чето не работает передача аргументов детям, надо разбираться мне лень

   codum = []
   
   codum << "#{obj[:object]} {"
   codum << "    // #{obj[:ocomment]}" if obj[:ocomment]
   codum << "    id: #{obj[:id]}"
  
   (obj[:attrs] || {}).each do |key,value|
     atv=@dic.eval( value )
     STDERR.puts "attr key=#{key} atv=#{atv}"
     val,extra = unwind_helper(atv)
     codum << "    #{key}: #{fix_prop val.join(' ')}"
     codum << "    " + extra.join("\n    ") if extra.length > 0
   end
   
   codum << "    " + @dic.get_data( args.merge({:padding=>mypadding+1}) ).join("\n").split("\n").join("\n    ")
   codum << "    " + (obj[:subitems] || []).join("\n    ") if obj[:subitems]
   codum << "}"
 
   # раньше аттрибуты вычислялись так @dic.eval( @edic.eval(*) ) но теперь это вычисление вытащено на внешний рассчет
   # с тем чтобы некоторые аттрибуты вдруг функциями стали
   # todo padding.. а для этого надо уметь понимать какой parent и какой мой padding.. хз короче
   
   mypadstr = " "*(mypadding*4)
   codum = codum.map { |rec|
     rec.split("\n").map{ |line| "#{mypadstr}#{line}" }
   }

   #[codum.join("\n")]
   codum
})

#extra_attrs это надо для aspect:vars
@dic.add_rule( "object_new_prop", [:property], lambda { |obj,args,nxt|
#  if obj[:value]
    codum = "property var #{obj[:name]}: #{fix_prop @dic.eval( @edic.eval(obj[:value]) ).join(' ')}"
#  else
#    codum = "property var #{obj[:name]}"
#  end
})

def unwind_helper( datum )
  return datum if !datum.is_a?(Array)
  portion1 = []
  portion2 = []
  for d in datum
    if d.is_a?(Hash) && d[:extra_object_code]
      portion2.push( d[:extra_object_code] )
    else
      portion1.push d
    end
  end
  [portion1,portion2]
end

# вариант когда edic уже отработал, и надо просто уже dic-ом просчитать и все
@dic.add_rule( "object_new_prop_e", [:property_e], lambda { |obj,args,nxt|
#  STDERR.puts "EEE obj[:value]=#{obj[:value]}"
#  STDERR.puts "EEEN obj[:name]=#{obj[:name].inspect}"
  val,extra = unwind_helper( @dic.eval( obj[:value] ) )

  ["property var #{fix_name obj[:name]}: #{fix_prop val.join(' ')}",extra]
})

#extra_attrs это надо для aspect:vars
@dic.add_rule( "object_set_prop", [:property_set], lambda { |obj,args,nxt|
#  if obj[:value]
    codum = "#{fix_name obj[:name]}: #{fix_prop @dic.eval( @edic.eval(obj[:value]) ).join(' ')}"
#  else
#    codum = "property var #{obj[:name]}"
#  end
})

@dic.add_rule( "object_set_prop_e", [:property_set_e], lambda { |obj,args,nxt|
#  if obj[:value]
    codum = "#{obj[:name]}: #{fix_prop @dic.eval( obj[:value] ).join(' ')}"
#  else
#    codum = "property var #{obj[:name]}"
#  end
})

@dic.add_rule( "expression", [:expression], lambda { |obj,args,nxt|
  codum = []
  codum << [ obj[:expression] ]
  d = @dic.get_data( args )
#  puts "getting datum for obj=#{obj}"
#  puts "datum extracted.. d=#{d}"

  val,extra = unwind_helper( d )

  if val.length > 0
    codum << "("
    codum << val.join(",")
    codum << ")"
  end
#  puts "this codum=#{codum}"
  res = [ codum.join(" ") ]
  
  # добавка для обработки extra ..
  if extra.length > 0
    res.push( {:extra_object_code => extra} )
  end
  res
})


@dic.add_rule( "func", [:func], lambda { |obj,args,nxt|
  codum = []
  codum << "function #{obj[:name]}#{obj[:args] || '()'}"
  codum << "{"
  #d = @dic.get_data( args )
  d = @dic.get_data( args ) # если делать тут вычисление @edic... то появляются кавычки..
  lines,extra = unwind_helper(d)
  @dic.ppp "func items",d
  if lines[-1] && lines[-1] !~ /return/
    lines[-1] = "return /* generated by 1-basis/pass2/qmlgen */ #{lines[-1]};"
  end
  codum.concat( lines.map {|line| "    #{line}"} )
  codum << "}"
  codum << extra
  
#  @dic.eval( {:padding=>4},codum )
#  mypadstr="    "
#  codum = codum.map { |rec|
#     rec.split("\n").map{ |line| "#{mypadstr}#{line}" }
#   }
  [ codum.join("\n") ]
#  codum
})

@dic.add_rule( [2,"afunc"],[:afunc], lambda{ |obj,args,nxt|
  obj[:tag] = :func
  ["{ return "+@dic.call( obj,args,nxt ).join("") + "}"]
})

# это уже есть, см array-hash.rb

#@dic.add_rule( "array",[:array], lambda{ |obj,args,nxt|
#  ["["+@dic.call( obj,args,nxt ).join(",")+"]"]
#})