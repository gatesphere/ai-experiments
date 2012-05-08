#!/usr/bin/env io

// Post Tag Machine
// Jacob Peck
// 20120508

halt := "H"

TagMachine := Object clone do(
  m ::= 0
  rules ::= Map clone
  data ::= list
  generation ::= 0
  
  clone := method(self)
  
  with := method(m, p, d,
    self setM(m) setData(d) addRules(p)
  )
  
  addRules := method(rule_list,
    rule_list foreach(r,
      self rules atPut(r first, r second)
    )
    self
  )
  
  display := method(
    writeln("[#{generation}]: #{data join}" interpolate)
    self
  )
  
  iterate := method(
    word := self data first
    if(word == halt, return self)
    self setGeneration(self generation + 1)
    self m repeat(self data removeFirst)
    self setData(self data append(self rules at(word)) flatten)
    self
  )
)

TagMachine with(2, list(list("a", list("c","c","b","a",halt)),
                        list("b", list("c","c","a")),
                        list("c", list("c","c"))),
                        list("b","a","a"))

TagMachine display
5 repeat(TagMachine iterate display)
