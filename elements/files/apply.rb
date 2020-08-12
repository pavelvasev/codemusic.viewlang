# получается что эта штука.. добавляет return и прокидывает ее на уровень pass2
$singletone_catcher_counter=0
@edic.add_rule( "apply", [:apply], lambda { |obj,args,nxt|

  codum = obj[:items][0]
  datum = obj[:items][1]
  
  datum2 = { :tag => :group, :computing_mode => 1, :items => [datum] }
  datum_computed = @edic.eval( datum2, args )
  
  # добавим методов, которые будут действовать в коде (указанном в первом аргументе apply)
  sf = $singletone_catcher_counter
  @edic.add_rule( "value-of-apply",[:apply_value], lambda { |obj2,args2,nxt2|
#    [{ :expression => "datum[ index ]" }]
    [{ :tag => :expression, :expression => "modelData", :singletone_flag => sf }]
  })
  
  @edic.add_rule( "index-of-apply",[:apply_index], lambda { |obj2,args2,nxt2|
    [{ :tag => :expression, :expression => "index", :singletone_flag => sf }]
  })
  
#  STDERR.puts "gonna patch codum=#{codum.inspect}"
  codum[:singletone_catcher] = $singletone_catcher_counter
  $singletone_catcher_counter=$singletone_catcher_counter+1
  
  codum_computed = @edic.eval( codum,args )
  
  # специальный кряк чтобы оно уж не разворачивало нам того чего не надо потом в генераторе
  # ну кстати, так-то это проблема генератора жож - туду, перейти на генератор
  # и там собственно подправить.. генерацию объекта например
  codum_computed[0].delete(:unwind_if_in_property) if codum_computed.is_a?(Array) && codum_computed[0].is_a?(Hash)
  
  [{ :tag => :object, :object => "Repeater", :items => codum_computed, :attrs => { :model => datum_computed } }]
})

=begin
 Внутри repeater-а тоже могут быть объекты кандидаты в синглтоны. Но мы должны оставлять их внутри репитера,
 если они зависят от index или value внутри себя.
 Для этого мы назначаем первый объект кода "ловушкой зависимых синглтонов".
 Отмечаем его особой меткой.
 Затем index и value правила отмечаем тоже особой меткой, которая говорит - ежели кто использует эти выражения,
 и окажется синглтоном, то должен уезжать в объект-ловушку (а не на верхний уровень синглонов проекта).
 Это конечно все обрабатывается в singletone-plaza.
=end