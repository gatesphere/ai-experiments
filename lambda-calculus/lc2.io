// Lambda Calculus
// Jake Peck
// 20120503

curlyBrackets := getSlot("list")
squareBrackets := method(SymbolList with(call evalArgs))

List asString := method(
  "{ ".. self join(", ") .. " }"
)

List rewrite := method(a, b,
  /*
  writeln("a: " .. a)
  writeln("b: " .. b)
  writeln("self: " .. self)
  writeln("self first: " .. self first .. " " .. self first == a)
  writeln("self second: " .. self second)
  */
  //writeln("operating on uniqueId: " .. self uniqueId)
  if(self first == a, self atPut(0, b))
  if(self second isKindOf(List),
    self second rewrite(a,b)
    ,
    if(self second == a, self atPut(1, b))
  )
  self
)

List copy := method(
  retval := list
  self foreach(i, 
    if(i isKindOf(List), retval append(i copy), retval append(i))
  )
  retval
)

List applyLambda := method(lambda,
  sym := self first
  new_lambda := self second copy
  new_lambda rewrite(sym, lambda)
  new_lambda
)

SymbolList := List clone do(
  asString := method(
    "[ " .. self join(", ") .. " ]"
  )
  
  with := method(args,
    self clone appendList(args)
  )
  
  appendList := method(list,
    list foreach(i, self append(i))
  )
  
  copy := method(
    self with(self)
  )
  
  /*
  applyLambda := method(lambda,
    writeln("SymbolList applying lambda")
    self
  )
  
  rewrite := method(a, b,
    writeln("SymbolList rewriting lambda: (#{a} to #{b})" interpolate)
    retval := self copy 
    retval foreach(i, x, 
      writeln(i)
      writeln(x)
      if(x == a, 
        writeln(x == a)
        retval atPut(i, b)
        ,
        continue
      )
    )
    retval
  )
  */
)

// tests
one := {:s, {:z, [:s, :z] } }
two := {:s, {:z, [:s, [:s, :z] ] } }
succ := {:w, {:y, {:x, [:y, [:w, :y, :x] ] } } }
t := {:a, {:b, [:a]}}
f := {:a, {:b, [:b]}}


writeln("one: " .. one)
writeln("two: " .. two)
two rewrite(:s, :a) rewrite(:z, :b)
writeln("two, rewritten: " .. two)
writeln("succ: " .. succ)

/*
writeln("id: one: " .. one uniqueId)
writeln("id: one second: " .. one second uniqueId)
writeln("id: one second second: " .. one second second uniqueId)
writeln("id: one second second second: " .. one second second second uniqueId)
*/

writeln("one applyLambda(succ): " .. one applyLambda(succ))
writeln("one: " .. one)
writeln("one applyLambda(succ) applyLambda(two): " .. one applyLambda(succ) applyLambda(two))
