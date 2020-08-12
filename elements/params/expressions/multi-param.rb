$das_button_counter=0
@dic.add_rule( [2,"multi_param"], [:multi_param], lambda { |obj,args,nxt|

   pcode = obj[:items][0]
   model = obj[:items][1]
   app = @edic.eval( {:tag => :apply, :items => [ pcode, model ]} )
   
   attrs = {
     :title => "'#{obj[:name]}'",
     :width => 200
   }
   
   id="param_#{convert_data_name obj[:name]}"
   idc = "#{id}_col"
   
   [{ :tag => :object,
      :object => :GroupBox,
      :id => id,
      :items => [
        {:tag => :property_e, :name=>"val", :value => "gather()"},
        {:tag => :property_e, :name =>"tag",:value => "'left'"},
        {:tag => :func, :name => "gather", :items => ["return #{idc}.children.filter( function(i) { return i.$properties['val'] ? true : false; }).map( function(i) { return i.val } )"]},
        {:tag => :object, :object => :Column, :id => idc, :items => [app]}
      ],
      :attrs => attrs
   }]
   # ну а хендлеров нам добрые люди добавят.. засим далее
})
