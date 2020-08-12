@dic.add_rule( [1,"obj_is_param_files"], [:param_files], lambda { |obj,args,nxt|

   attrs = {}
   
   if obj[:files] || obj[:values]
     attrs[:values] = obj[:files] || obj[:values]
   end

   attrs[:text] = "\"" + (obj[:text] || obj[:name] || "") + "\""
   attrs[:multiple] = true
        
   # https://github.com/pavelvasev/viewlang/blob/master/code/qml/DataParam.qml
   # Отличие от FileSelect в том, что DataParam может принимать и давать редактировать список URL
   # а FileSelect это только про локальные файлы
   [{ :tag => :object,
      :object => :DataParam,
      :id => "param_#{convert_data_name obj[:name]}" || "name_unknown",
      :items => [{:tag => :property_e, :name=>"val", :value => "files"}],
      :attrs => attrs
   }]
})
