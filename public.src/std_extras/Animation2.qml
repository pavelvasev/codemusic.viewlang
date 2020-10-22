Column {
  id: main
  
  property var tag: "right"
  
  Param {
    id: film_src
    text: "Шаги фильма"
    guid: "film-track"
    values: (stateManager.pstate.menu || []).map( function(m,index) { return m.title || m.id || index } )
  }

  Param {
    id: anim_p
    guid: "film-T"
    text: "Время в фильме (film-T)"
    min: mult.tmin
    max: mult.tmax
    step: mult.tstep
    onValueChanged: {
      main.anim_v_changed( value )
    }
  }
  
  ///////////////////////////////////////////////////
  
  // наполняет state1 значениями из текущего состояния,
  // которые представлены в state2 но не в state1
  // таким образом у нас выравниваются все параметры
  function fill_up( state1, state2 )
  {
  }
  
  // интерполяция 1го значения с рекурсией по массивам и хешам
  function interp1( v1, v2, r )
  {
    if (Array.isArray(v2)) {
      var res = [];
      for (var i=0; i<v2.length; i++)
        res.push( interp1( v1[i], v2[i], r ) );
      return res;
    }
    
    if (typeof(v1) == "undefined") return v2;
    if (typeof(v2) == "undefined") return v1;
    
    if (typeof(v2) == "object") {
      var res = {};
      for (k in v2)
        res[k] = interp1( v1[k], v2[k], r );
      return res;
    }
    
    if (isNaN(v1) || isNaN(v2)) {
      return r >= 0.5 ? v2 : v1;
    }
    var middle = v1 + (v2 - v1) * r;
    return middle;
  }
  
  // интерполяция между двумя состояниями
  function interp( state1, state2,r )
  {
    return interp1( state1, state2, r );
  }
  
  // вычисление состояния для мультика
  // вход: * states список состояний (кадровC)
  //       * times массив длительность перехода между кадрами
  //       * pauses массив пауз на кадре
  //       * t текущее время (в единицах временнОй разметки)
  // по большому счету эта идея times,pauses переходит просто к набору треков анимаций
  // вида f: ( state1, state2, t1, t2, t) -> state которая делает интерполяцию между кадрами но только если t1 <= t <= t2
  // и тогда можно говорить что наш мультик это набор четверок (state1, state2, t1, t2),...
  // дык можно говорить конечно, кто ж мешает..
  function multik_state( states, times, pauses, t )
  {
    var virtual_t = 0;
    
  }
  
  // по мультику представленному arr выполнить установку параметров системы
  // arr = набор четверок (state1, state2, t1, t2),...
  function apply_mult( arr, t )
  {
    for (var i=0; i<arr.length; i++) {
      var a = arr[i];
      if (a[2] <= t && t <= a[3]) {
        var ratio = (t - a[2]) / (a[3] - a[2]);
        var res = interp( a[0], a[1], ratio );
        setParams( res );
      }
    }
  }
  
  function states2mult( states ) {
    var res = [];
    var t = 0;
    for (var i=0; i<states.length-1; i++) {
      var step = 100;
      var tnext = t+step;
      res.push( [ states[i], states[i+1],t,tnext] );
      t = tnext;
    }
    res.tmin = 0;
    res.tmax = t;
    res.tstep = 1;
    return res;
  }
  
  /////////////////////////
  //property var mult: states2mult( [ as1(), as2(), as3(), as4() ] )
  property var mult: {
  
    var states = stateManager.pstate.menu[ filmsrc.value ].variants;
    
    return states2mult(states);
  }
  
  ///////////////////////// 
  
  function anim_v_changed( value ) {
    apply_mult( main.mult, value );
  }
  

  
  function as1() {
return {
  "FILE_treki_currentT/points/color": "0.97 1 0.11",
  "FILE_treki_currentT/points/radius": 8.85,
  "FILE_vrml_mnoj/extras/onoff_ShaderClipS_z": 0,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/dolya": 1,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/shag": 0,
  "FILE_treki_current/trekN": 4,
  "FILE_treki/trekN": 4,
  "T": 55,
  "FILE_treki_current/points/radius": 5.45,
  "extras/onoff_ShaderClip_z": 1,
  "extras/ShaderClip_z/p1": -16591.4398276705,
  "extras/ShaderClip_z/p2": 33180,
  "extras/onoff_ShaderClip_x": 1,
  "extras/onoff_ShaderClip_y": 1,
  "extras/ShaderClip_x/p1": -16591.4398276705,
  "extras/ShaderClip_x/p2": 33180,
  "extras/ShaderClip_y/p1": -16591.4398276705,
  "extras/ShaderClip_y/p2": 33180,
 "show_axes": 1,
  "cameraCenter": [
    0,
    0,
    0
  ],
  "cameraPos": [
    -113.45213940950974,
    5.674300063238761,
    1.4851698596795542
  ]

}
  }

  function as2() {
return {
  "show_axes": 1,
  "cameraCenter": [
    0,
    0,
    0
  ],
  "cameraPos": [
    -113.45213940950974,
    5.674300063238761,
    1.4851698596795542
  ],
  "extras/AxesNames/X": "X",
  "extras/AxesNames/Y": "Y",
  "extras/AxesNames/Z": "Fi",
  "extras/onoff_AxesNames": 1,
  "extras/onoff_EnableViewsExtras": 1,
  "extras/onoff_AutoScale": 1,
  "extras/AutoScale/masshtab": 0.003,
  "FILE_treki_currentT/points/color": "0.97 1 0.11",
  "FILE_treki_currentT/points/radius": 8.85,
  "FILE_vrml_mnoj/extras/onoff_ShaderClipS_z": 0,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/dolya": 1,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/shag": 0,
  "FILE_treki_current/trekN": 4,
  "FILE_treki/trekN": 4,
  "T": 55,
  "FILE_treki_current/points/radius": 5.45,
  "extras/onoff_ShaderClip_z": 1,
  "extras/ShaderClip_z/p1": -536.030172400508,
  "extras/ShaderClip_z/p2": 33180,
  "extras/onoff_ShaderClip_x": 1,
  "extras/onoff_ShaderClip_y": 1,
  "extras/ShaderClip_x/p1": -16591.4398276705,
  "extras/ShaderClip_x/p2": 33180,
  "extras/ShaderClip_y/p1": -16591.4398276705,
  "extras/ShaderClip_y/p2": 33180,
  "extras/onoff_SaveScene": 1
}
  }  
  
    function as3() {
return {
  "show_axes": 1,
  "cameraCenter": [
    0,
    0,
    0
  ],
  "cameraPos": [
    -113.45213940950974,
    5.674300063238761,
    1.4851698596795542
  ],
  "extras/AxesNames/X": "X",
  "extras/AxesNames/Y": "Y",
  "extras/AxesNames/Z": "Fi",
  "extras/onoff_AxesNames": 1,
  "extras/onoff_EnableViewsExtras": 1,
  "extras/onoff_AutoScale": 1,
  "extras/AutoScale/masshtab": 0.003,
  "FILE_treki_currentT/points/color": "0.97 1 0.11",
  "FILE_treki_currentT/points/radius": 8.85,
  "FILE_vrml_mnoj/extras/onoff_ShaderClipS_z": 0,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/dolya": 1,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/shag": 0,
  "FILE_treki_current/trekN": 4,
  "FILE_treki/trekN": 4,
  "T": 55,
  "FILE_treki_current/points/radius": 5.45,
  "extras/onoff_ShaderClip_z": 1,
  "extras/ShaderClip_z/p1": -536.030172400508,
  "extras/ShaderClip_z/p2": 4970,
  "extras/onoff_ShaderClip_x": 1,
  "extras/onoff_ShaderClip_y": 1,
  "extras/ShaderClip_x/p1": -16591.4398276705,
  "extras/ShaderClip_x/p2": 33180,
  "extras/ShaderClip_y/p1": -16591.4398276705,
  "extras/ShaderClip_y/p2": 33180,
  "extras/onoff_SaveScene": 1
}
}

function as4() {
return {
  "show_axes": 1,
  "cameraCenter": [
    0,
    0,
    0
  ],
  "cameraPos": [
    6.662536041843355,
    37.53744269096314,
    107.01561735105965
  ],
  "extras/AxesNames/X": "X",
  "extras/AxesNames/Y": "Y",
  "extras/AxesNames/Z": "Fi",
  "extras/onoff_AxesNames": 1,
  "extras/onoff_EnableViewsExtras": 1,
  "extras/onoff_AutoScale": 1,
  "extras/AutoScale/masshtab": 0.003,
  "FILE_treki_currentT/points/color": "0.97 1 0.11",
  "FILE_treki_currentT/points/radius": 8.85,
  "FILE_vrml_mnoj/extras/onoff_ShaderClipS_z": 0,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/dolya": 1,
  "FILE_vrml_mnoj/extras/ShaderClipS_z/shag": 0,
  "FILE_treki_current/trekN": 4,
  "FILE_treki/trekN": 4,
  "T": 55,
  "FILE_treki_current/points/radius": 5.45,
  "extras/onoff_ShaderClip_z": 1,
  "extras/ShaderClip_z/p1": -536.030172400508,
  "extras/ShaderClip_z/p2": 4970,
  "extras/onoff_ShaderClip_x": 1,
  "extras/onoff_ShaderClip_y": 1,
  "extras/ShaderClip_x/p1": -16591.4398276705,
  "extras/ShaderClip_x/p2": 33180,
  "extras/ShaderClip_y/p1": -16591.4398276705,
  "extras/ShaderClip_y/p2": 33180,
  "extras/onoff_SaveScene": 1
}
}

  ///////////////////////////////////////////////////
  
  property var stateManager: qmlEngine.rootObject.stateManager
  
  // у нас 2 способа получить параметры.. - у параметра и через state (в state пишут псевдо-параметры типа камеры)
  function getParam( name ) {
    if (stateManager.pstate.hasOwnProperty(name));
      return stateManager.pstate[name];
    return undefined;
  }
  
  // patchState эффективнее за счет массовости..
  // вероятно надо сделать аналог, который все что в параметрах выставляет через setAppValue а остальное махом..
  // хотя и это неэффективно. эффективнее freeze сделать
  function setParam(name,value ) {
      var p = {};
      p[name]=value;
      stateManager.patchState(p);
  }
  
  // todo один setTimeout при нескольких вызовах

  function setParams(hash) {
    stateManager.patchState( hash );
    // сразу же нельзя ибо там еще в эти параметры основной не пропатчился параметр анимации
    setTimeout( function() {
      stateManager.broadcastState()
    }, 10 );
  }
  
  function getParams() {
    return stateManager.pstate;
  }

}