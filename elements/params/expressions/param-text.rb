@dic.add_rule( [2,"obj_is_param_label"], [:param,:label], lambda { |obj,args,nxt|

   attrs = {}
   
   t = obj[:text] || obj.name
   if t.is_a?(String)
     attrs[:text] = "\"" + (obj[:text] || obj[:name] || "") + "\""
   elsif t.is_a?(Hash)
     attrs[:text] = t
   end
        
   [{ :tag => :object,
      :object => :Text,
      :id => "param_#{convert_data_name obj[:name]}" || "name_unknown",
      :items => [{:tag => :property_e,:name=>"tag", :value => "'left'"}],
      :attrs => attrs
   }]
   # ну а хендлеров нам добрые люди добавят.. засим далее
})
