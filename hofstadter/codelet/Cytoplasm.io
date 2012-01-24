// Cytoplasm (Hofstadter)
// Jacob Peck
// 20111031 (Happy Halloween)

Cytoplasm := Object clone do(
  // state
  data ::= list(); // some list of data
  coderack ::= nil; // a single coderack
  
  // clone (singleton)
  clone := method(self);
  
  // constructor (internal)
  init := method(
    data = list();
    coderack = nil;
  );
  
  // constructor (external)
  with := method(rack, value,
    self clone setData(value) setCoderack(rack)
  )
)
