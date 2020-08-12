@dic.add_rule( [1,"obj_is_param"], [:param], lambda { |obj,args,nxt|

   attrs = {}
   
   if obj[:values]
     attrs[:values] = obj[:values] 
   end
   
   if obj[:min]
     attrs[:min] = obj[:min] 
   end   
   
   if obj[:step]
     attrs[:step] = obj[:step]
   end

   if obj[:max]
     attrs[:max] = obj[:max] 
   end      
    
   if obj[:value]
     attrs[:value] = obj[:value] # todo будет обновление value на ownvalue или как-то так
   end
   
   if obj[:sliding]
     attrs[:enableSliding] = obj[:sliding] 
   end         
   
   if obj[:combo]
     attrs[:comboEnabled] = obj[:combo] 
   end   
   
   attrs[:text] = "\"" + (obj[:text] || obj[:name] || "") + "\""
        
   r = [{ :tag => :object,
      :object => :Param,
      :id => "param_#{convert_data_name obj[:name]}" || "name_unknown",
      :items => [{:tag => :property_e,:name=>"val", :value => "values ? values[value] : value"}],
      :attrs => attrs
   }]
   
})
