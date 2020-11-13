// Предназначение - по заданному списку групп-и-пресетов построить гуи для их вызова
Item {
  id: gen
  
  function initengine( engine ) {
    engine.createMenu = function(title) {
//      console.log("helo");
        var menu = { title: title, variants: [], gui: "combo", lid: Math.random().toString() }
        //new Object( {} );
        menu.add = function( title, params ) {
          menu.variants.push( { title: title, params: params } );
          gen.inputChanged();
//          console.log("menu.add called",JSON.stringify( gen.input ));
//          gen.input = JSON.parse( JSON.stringify( gen.input ));
        }
        menu.name = function(title) {
          menu.title = title;
        }
        gen.input.push( menu );
//        setTimeout( function() {
///           gen.input = JSON.parse( JSON.stringify( gen.input ));
//        }, 10 );
        gen.inputChanged();
        
        engine.cleanup.push( function() {
          var f = gen.input.filter(function(m) { return m.lid != menu.lid });
          gen.input = f;
        });
        return menu;
      }
  }
  
  property var input: []
  
  property var stateManager
  
  // массив вида
  // [{ title: имя категории, variants: [....]}]
  // где каждый вариант это: {значения-параметров}
  
  onInputChanged: {
//    console.log('guigen input changed!',input );
    setTimeout( function() {
//      console.log("Setting cats...");
      cats = JSON.parse( JSON.stringify(input ));
      findRootScene( gen ).refineSelf();
    },10 );
  }

  property var cats: [] //input
  //onCatsChanged: console.log("23234234");
  property var catsKeys: Object.keys( cats )
  //onCatsKeysChanged: console.log("23234234 bbb");  
  // работает и с массивами
  
  Flow {
    property var tag: "top"
    width: Math.min( totalChildrenWidth()+50, findRootScene( gen ).width - 50 )
    
    spacing: 5
    
    function totalChildrenWidth() {
      var acc=0;
      for (var i = 0; i < this.children.length; i++) {
        var child = this.children[i];
        if (child.width)
          acc = acc + child.width;
      }
      return acc;
    }
  
  Repeater {
    model: catsKeys.length
    onModelChanged: console.log("repeater pgen keys=",catsKeys );
    Row {
      spacing: 3
      
      property var cat: { var q = cats[catName] || {}; if (!Array.isArray(q.variants)) q.variants=[]; return q; }
      property var catName: catsKeys[index]
      Text {
        visible: !iscombo
        //text: "<a href='javascript:;'>" + (cat.title || "menu"+catName) + "</a>"
        text: cat.title
        y: 2
        id: txt
      }
      property var iscombo: cat.gui == "combo"
      property var isbuttons: !iscombo
      Repeater {
        model: isbuttons ? (cat.variants || []).length : 0
        
        Button {
          text: cat.variants[index].title || String(index)
          onClicked: perform( cat.variants[index] )
        }
      }
      ComboBox {
        visible: iscombo
        model: [""+(cat.title||catName)+""].concat( cat.variants.map( function(v) { return v.title } ) ); //.concat("..настроить..");
        onCurrentIndexChanged: {
          if (currentIndex > 0) {
            perform( cat.variants[ currentIndex-1 ] )
            //currentIndex = 0;
          }
        }
        width: 120
      }
    }
  }
  
  }
  
  // вызывается когда кликнули по варианту
  function perform( variant_record ) {
    //console.log("GuiGenerator: user click preset variant: ",variant_record );
    var newparams = variant_record.params;
    // var newparams = variant_record.params; // это сокращенный вариант
    delete newparams['title'];
    //console.log("patching state....",variant_record.params );
    
    var s = JSON.parse( JSON.stringify( variant_record.params ) );
    stateManager.patchState(s);
    stateManager.broadcastState();
    return;
  }
  
}