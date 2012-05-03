#!/usr/bin/env io

// Lambda calculus
// Jacob Peck
// 20120502


squareBrackets := method(self apply(call argAt(0)))
curlyBrackets := method(
  if(call argCount == 1,
    Lambda with(nil, Lambda expand(call argAt(0)))
    ,
    Lambda with(call argAt(0), Lambda expand(call argAt(1)))
  )
)

Lambda := Object clone do(
  arg ::= nil
  map ::= nil
  
  init := method(
    self arg = nil
    self map = nil
  )
  
  with := method(arg, map,
    self clone setArg(arg) setMap(map)
  )
  
  asCode := method(
    if(arg != nil,
      "{#{arg}, #{map asCode}}" interpolate
      ,
      self asString
    )
  )
  
  asString := method(
    if(arg != nil,
      "(\\#{arg}.#{map})" interpolate
      ,
      "#{map}" interpolate
    )
  )
  
  expand := method(message,
    m := nil
    ex := try(m = message doInContext(Lobby))
    if(ex != nil,
      m = Lambda with(nil, 
        (message name .. message next) asMutable removeSeq(" ") replaceMap(Map clone atPut("squareBrackets(", "[") atPut(")", "]"))
      )
    )
    //writeln("expanded " .. message .. " to " .. m .. " exception: " .. ex)
    m
  )
    
  apply := method(lambda,
    // tbd
    writeln(self .. " applying " .. lambda)
    lambda
  )
)


t := {x, {y, x}}
f := {x, {y, y}}

zero := {s, {z, z}}
one := {s, {z, s[z]}}
two := {s, {z, s[s[z]]}}
three := {s, {z, s[s[s[z]]]}}

succ := {w, {y, {x, y[w[y][x]]}}}

writeln("succ asString: " .. succ asString)
writeln("succ asCode: " .. succ asCode)

writeln("attempting to add: 2+3 == two[succ][three]")
writeln(two[succ][three])
writeln

writeln("attempting to multiply: 2*2 == two[two]")
writeln(two[two])
writeln