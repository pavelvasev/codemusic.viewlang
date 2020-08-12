$das_cb_counter=0
@dic.add_rule( [2,"obj_is_param_checkbox"], [:param,:checkbox], lambda { |obj,args,nxt|

   attrs = {}
   
   attrs[:text] = "\"" + (obj[:text] || obj[:name] || "") + "\""
   #attrs[:gui_panel] ||= "left"
  
   id = "param_"
   if obj[:name]
     id = "param_#{convert_data_name obj[:name]}"
   else
      $das_cb_counter=$das_cb_counter+1
      id = "ckeckbox_#{$das_cb_counter}"
   end

   if obj[:value]
     attrs[:value] = obj[:value]
   end
   
   [{ :tag => :object,
      :object => :CheckBoxParam,
      :id => id,
      :items => [{:tag => :property_e,:name=>"val", :value => "value"}],
      :attrs => attrs
   }]
   # ну а хендлеров нам добрые люди добавят.. засим далее
})
