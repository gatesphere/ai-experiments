// Coderack (Hofstadter)
// Jacob Peck
// 20111031 (Happy Halloween)

// reimplement List anyOne
List anyOne := method(
  sortBy(
    block(x, y, 
      x uniqueId asNumber * Random value < y uniqueId asNumber * Random value
    )
  ) at(0)
)

Coderack := Object clone do(
  codelets ::= list(); // list of codelets
  cytoplasm ::= nil; // cytoplasm reference
  
  // clone (singleton)
  clone := method(self);
  
  // constructor (internal)
  init := method(
    codelets = list();
    cytoplasm = nil;
  );
  
  // constructor (external)
  with := method(plasm, valuelist,
    self clone setCytoplasm(plasm) addCodelets(valuelist)
  );
  
  // methods
  addCodelets := method(vals,
    vals foreach(i,
      for(j,1,i weight,
        self codelets append(i)
      )
    );
    self
  );
  
  push := method(codelet,
    addCodelets(list(codelet))
  );
  
  pop := method( // grabs a random codelet, removes all other copies of it from the rack
    popval := self codelets anyOne;
    self codelets := self codelets remove(popval);
    popval
  )
)