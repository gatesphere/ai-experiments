#!/usr/bin/env io

// Stack machine
// Jacob Peck
// 20120518

ErrorState := Object clone do(
  clone := method(self)
  nextState := method(self)
  asString := method("{error}")
)

HaltState := Object clone do(
  clone := method(self)
  nextState := method(self)
  asString := method("{halt}")
)

ReadState := Object clone do(
  name ::= nil
  source ::= nil
  lookup ::= nil
  init := method(
    self name = nil
    self source = nil
    self lookup = nil
  )
  nextState := method(a, self lookup call(a))
  asString := method("(" .. name .. ")")
)

WriteState := Object clone do(
  name ::= nil
  destination ::= nil
  output ::= nil
  nextState ::= nil
  init := method(
    self name = nil
    self destination = nil
    self output = nil
    self nextState = nil
  )
  asString := method("[" .. name .. "]")
)


Stack := List clone do(
  push := method(x, self prepend(x))
  pushList := method(x, x foreach(i, self append(i)))
  pop := method(self removeFirst)
  peek := method(self first)
  asString := method(self join(","))
)


StackMachine := Object clone do(
  stacks ::= nil
  state ::= nil
  
  init := method(
    self stacks = nil
    self state = nil
  )
  
  doSomething := method(
    if(self state isKindOf(ReadState),
      // read stuff
      self state = self state nextState(self state source pop)
      ,
      if(self state isKindOf(WriteState),
        // write stuff
        self state destination push(self state output)
        self state = self state nextState
        ,
        if(self state isKindOf(HaltState),
          // halt
          self state = self state nextState
          ,
          // error state
          self state = self state nextState
        )
      )
    )
    self
  )
  
  display := method(
    writeln(self asString)
    self
  )
  
  asString := method(
    printrep := "<state: " .. state .. "\n"
    stacks foreach(i, x, printrep = printrep .. i .. ": " .. x .. "\n")
    printrep .. ">"
  )
)

// create a machine
// counts the number of 1s, stores them on stack 2
stack1 := Stack clone
stack2 := Stack clone

stack1 pushList(list(0,0,0,0,1,1,1,1,0,0,0,0,1,0,1,0,0,1))

read1 := ReadState clone do(
  name = "read1"
  source = stack1
  lookup = block(x,
    x switch(
      0, read1,
      1, write12,
      nil, HaltState,
      x, ErrorState
    )
  )
)

write12 := WriteState clone do(
  name = "write12"
  destination = stack2
  output = 1
  nextState = read1
)

sm := StackMachine clone do(
  stacks = list(stack1, stack2)
  state = read1
)

// run it
run := method(
  sm display
  while(sm state != HaltState and sm state != ErrorState,
    sm doSomething display
  )
)

run