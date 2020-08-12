@dic.add_rule( [1,"get_param"], [:getparam], lambda { |obj,args,nxt|

   [{ :tag => :expression, :expression => "param_#{convert_data_name obj[:name]}.val" }]

})
