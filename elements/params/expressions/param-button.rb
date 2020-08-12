$das_button_counter=0

@dic.add_rule( [2,"obj_is_param_btn"], [:param,:button], lambda { |obj,args,nxt|

   attrs = {}
   
   attrs[:text] = "\"" + (obj[:text] || obj[:name] || "") + "\""
   #attrs[:gui_panel] ||= "left"
  
   id = "btn_"
   if obj[:name]
     id = "#{id}#{convert_data_name obj[:name]}"
   end
   $das_button_counter=$das_button_counter+1
   id = "#{id}_#{$das_button_counter}"
   
   [{ :tag => :object,
      :object => :Button,
      :id => id,
      #:items => [{:property_e=>1,:name=>"tag", :value => "'left'"}],
      :attrs => attrs
   }]
   # ну а хендлеров нам добрые люди добавят.. засим далее
})
