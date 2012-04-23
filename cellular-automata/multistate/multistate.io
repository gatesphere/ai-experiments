#!/usr/bin/env io

// Experiment in multi-state cellular automata
// Wolfram style


// pretty-printing stuff
List asString = method("[" .. self join(",") .. "]")
true asString = "X"
false asString = "-"


// Cell implementation
Cell := Object clone do(
  states ::= list
  //lneighbor ::= nil
  //rneighbor ::= nil
  behavior ::= nil
  
  init := method(
    self states = list
    //self lneighbor = nil
    //self rneighbor = nil
    self behavior = nil
    self
  )
  
  getState := method(n,
    self states at(n)
  )
  
  iterate := method(oldworld,
    //swriteln("iterating")
    self behavior call(oldworld)
  )

  asString := method(
    self states asString
  )
  
  generateStates := method(n,
    l := list setSize(n)
    n repeat(i, l atPut(i, Random flip))
    self setStates(l)
  )
  
  /*
  setNeighbors := method(l, r,
    self setLneighbor(l) setRneighbor(r)
  )
  */
  
  new := method(n, b,
    self clone setBehavior(b) generateStates(n)
  )
)

// World implementation
World := Object clone do(
  currentWorld ::= list
  oldWorld ::= list
  
  clone := method(self)
  
  /*
  assignNeighbors := method(
    self currentWorld foreach(i, cell,
      l := i - 1
      if(l < 0, l = self currentWorld size - 1)
      r := i + 1
      if(r > self currentWorld size - 1, 0)
      cell setNeighbors(self currentWorld at(l), self currentWorld at(r))
    )
    self
  )
  */
  
  copyIntoOldWorld := method(
    self currentWorld foreach(i, cell,
      oldWorld atPut(i, cell states clone)
    )
    self
  )
  
  initialize := method(n, s, b,
    n repeat(
      self currentWorld append(Cell new(s, b))
    )
    self oldWorld setSize(self currentWorld size)
    //self currentWorld assignNeighbors
    self
  )
  
  iterate := method(
    self copyIntoOldWorld
    self currentWorld foreach(i, cell,
      l := i - 1
      if(l < 0; l = self currentWorld size - 1)
      r := i + 1
      if(r > self currentWorld size - 1, r = 0)
      cell iterate(list(self oldWorld at(l), self oldWorld at(r)))
    )
    self
  )
  
  display := method(
    writeln(self currentWorld join(" "))
    self
  )
  
  displayState := method(n,
    writeln("State #{n}: " interpolate .. self currentWorld map(cell, cell states at(n)) join)
    self
  )
)


// behavior - just a sample rule
behavior := block(oldworld,
  parent := call sender
  
  state_0_l := oldworld at(0) at(0)
  state_0_r := oldworld at(1) at(0)
  
  state_1_l := oldworld at(0) at(1)
  state_1_r := oldworld at(1) at(1)
  
  state_0_me := parent states at(0)
  state_1_me := parent states at(1)
  
  // state 0: true if the following, false else
  // 0: X--
  // 1: --X
  new_state_0 := false
  if(state_0_me not and state_1_me not,
    if(state_0_r not and state_1_l not,
      if(state_0_l and state_1_r,
        new_state_0 = false
      )
    )
  )
  
  // state 1: false if the following, true else
  // 0: XXX
  // 1: X--
  new_state_1 := true
  if(state_1_me not and state_0_me,
    if(state_0_l and state_0_r,
      if(state_1_l and state_1_r not,
        new_state_1 := false
      )
    )
  )
  
  //writeln("setting state to: [" .. new_state_0 .. "," .. new_state_1 .. "]")
  parent setStates(list(new_state_0, new_state_1))
)

// do some stuff
World initialize(25, 2, behavior)
20 repeat(i,
  writeln("Generation #{i}:" interpolate)
  World display displayState(0) displayState(1) iterate
)
