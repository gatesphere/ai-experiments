#!/usr/bin/env io

// Random Boolean Network
// (Kauffman NK-style nets)

// Jacob Peck
// 20120407

// List anyOne
List anyOne := method(
  sortBy(
    block(x, y, 
      x uniqueId asNumber * Random value < y uniqueId asNumber * Random value
    )
  ) at(0)
)

// ID Generator
Accumulator := Object clone do(
  value ::= 0
  clone := method(self)
  get := method(val := self value; self setValue(val + 1); val)
)

// negator
fn_not := block(x, x not)

// boolean functions
fn_and := block(x, y, x and y)
fn_or := block(x, y, x or y)
fn_nand := block(x, y, fn_and call(x, y) not)
fn_xor := block(x, y, (x and (y not)) or ((x not) and y))
fn_xnor := block(x, y, fn_xor call(x, y) not)
function_list := list(fn_and, fn_or, fn_nand, fn_xor, fn_xnor)

// a gene
Gene := Object clone do(
  edges ::= list // list of other genes (as an index number)
  neg ::= list // whether or not to negate a gene state
  state ::= false // initial state
  function ::= nil // behavior function
  id ::= 0
  
  init := method(
    self edges = list
    self state = false
  )
  
  with := method(state, function,
    self clone setState(state) setFunction(function) setId(Accumulator get)
  )
  
  addEdge := method(edge,
    negate := Random flip
    self edges append(edge)
    self neg append(negate)
    self
  )
  
  apply_fn := method(inputs,
    self function call(inputs)
  )
  
  update := method(oldworld,
    vals := list
    self edges foreach(i, e, 
      s := oldworld at(e)
      if(self neg at(i),
        vals append(fn_not call(s))
        ,
        vals append(s)
      )
    )
    self setState(self apply_fn(vals))
  )
  
  asString := method(if(self state, "X", "-"))
)

// a function chain
Function := Object clone do(
  chain ::= list // functions
  init := method(self chain = list)
  
  generateFunction := method(k,
    f := self clone
    k repeat(f chain append(function_list anyOne))
    self
  )
  
  call := method(inputs,
    i := 0
    x := inputs at(i)
    i = i + 1
    y := inputs at(i)
    i = i + 1
    f := 0
    while(f < self chain size,
      val := self chain call(x, y)
      x = val
      y = inputs at(i)
      i = i + 1
      f = f + 1
    )
    x
  )
)

World := Object clone do(
  genes := list
  clone := method(self)
  gen := 0
  
  generate := method(n, k,
    n repeat(
      s := Random flip
      g := Gene with(Random flip, Function generateFunction(k))
      self genes append(g)
      k repeat(g addEdge(Random value(n - 1) round))
    )
    self
  )
  
  iterate := method(
    self gen = gen + 1
    oldgenes := list
    self genes foreach(g, oldgenes append(g state))
    self genes foreach(g, g update(oldgenes))
    self
  )
  
  draw := method(
    write("gen " .. self gen .. ": ")
    self genes foreach(g, write(g))
    writeln
    self
  )
)

run := method(times, n, k,
  World generate(n, k)
  times repeat(World draw iterate)
)

run(100, 100, 2)
