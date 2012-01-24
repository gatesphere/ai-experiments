// Codelet (Hofstadter)
// Jacob Peck
// 20111031 (Happy Halloween)

Codelet := Object clone do(
  // state
  code ::= nil; // to take the form of block(list(other,codelets,to,work,on), somethingtodohere)
  coderack ::= nil; // reference to a single coderack
  cytoplasm ::= nil; // reference to the cytoplasm
  data ::= nil; // data contained by the codelet?
  weight ::= 1; // the weighting of the codelet (how many entries it has in the coderack)
  
  // constructor (internal)
  init := method(
    code = nil;
    coderack = nil;
    cytoplasm = nil;
    data = nil;
    weight = 1;
  );
  
  // constructor (external)
  with := method(rack, plasm, value, instructions, priority,
    self clone setCoderack(rack) setCytoplasm(plasm) setData(value) setCode(instructions) setWeight(priority)
  );
  
  // work method -- calls the code with the parameter others, a list of other codelets
  work := method(others,
    self code call(others)
  )
)


// example of a "code" value:
// use of "call sender" instead of "self" is due to Io's scoping
/*
 * code := block(others,
 *   me := call sender;
 *   me setData(me data .. others first data)
 * )
 */
// this example assumes that "data" is a string of some sort, and
// concatenates whatever data the first element of the list "others"
// is carrying to the end of this Codelet's data.

// to instantiate a new Codelet:
/*
 * codeletX := Codelet with(coderack, cytoplasm, data, code, weight)
 */
// where "coderack" is a reference to a coderack,
// "cytoplasm" is a reference to a cytoplasm,
// "data" is a reference to some data
// "code" is a block, as explained above
// and "weight" is the weighting of the codelet
