import "../presets"

Item {

  id: sm
  
  property var stateManager

  Button {
    property var tag: "top"
    text:  "Программа"
    visible: sm.visible
    onClicked: proc.open();
  }
  
  GuiGenerator {
    id: guigen
    stateManager: sm.stateManager
  }

SimpleDialog {
  id: proc
  
  title: "Скрипты программы"
  
  property var extrasManager
  property var tag: "other"

  // это собственно значение списка добавок
  property var value: ""
  
  property bool maycompute: true
  onValueChanged: { 
    if (maycompute) {
      tep.text = value;
      compute( value );
    }
  }
  
  height: main.height+40
  width: main.width+40
  
  Column {
    id: main
    
    TextEdit {
      width: 600
      height: 200
      id: tep
    }
    
    Row {
         spacing: 3
         
         Button {
           text: "ПРИМЕНИТЬ"
           onClicked: {
             doapply();
           }
         }
         
         Text {
           id: svstatus
           text: "status"
         }
    } //row
  }



  ParamUrlHashing {
    name: scopeNameCalc.globalName
    target: proc
  }

  ScopeCalculator {
    id: scopeNameCalc
    name: "script1"
  }
  
  function doapply() {
    proc.maycompute = false;
    proc.value = tep.text;
    proc.compute( tep.text );
    proc.maycompute = true;
  }
  
  property var initedengine
  function getengine() {
    if (initedengine) 
      (initedengine.cleanup || []).forEach( function(item) { item() } );
    var engine = {};
    engine.cleanup = [];  
    initedengine = engine;
    return engine;
  }
 
  function compute( code )
  { 
    var engine = getengine();
    guigen.initengine( engine );
    
    eval( code );
  }

}


}