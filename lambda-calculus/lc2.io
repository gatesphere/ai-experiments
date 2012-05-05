// Lambda Calculus
// Jake Peck
// 20120503

curlyBrackets := getSlot("list")
squareBrackets := method(SymbolList with(call evalArgs))

List asString := method(
  "{ ".. self join(", ") .. " }"
)

// destructive
List rewrite := method(a, b,
  //writeln("a: " .. a)
  //writeln("b: " .. b)
  //writeln("self: " .. self)
  //writeln("self first: " .. self first .. " " .. self first == a)
  //writeln("self second: " .. self second)
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
  //writeln("applyLambda call: " .. self .. " <= " .. lambda)
  sym := self first
  new_lambda := self second copy
  //writeln(" pre rewrite: new_lambda(" .. new_lambda type .. "): " .. new_lambda)
  new_lambda rewrite(sym, lambda)
  //writeln(" post rewrite: new_lambda(" .. new_lambda type .. "): " .. new_lambda)
  new_lambda
)

// destructive
List reduceBrackets := method(
  self foreach(i, x,
    if(x type == "SymbolList" and x size <= 1,
      self atPut(i, x first)
    )
  )
  self
)

List betaReduce := method(
  self foreach(i, x,
    writeln("  b-reduce(base): " .. x)
    //if(x type == "SymbolList",
    if(x isKindOf(List),
      self atPut(i, x betaReduce)
    )
  )
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
    self
  )
  
  prependList := method(list,
    list reverse foreach(i, self prepend(i))
    self
  )
  
  copy := method(
    SymbolList with(self)
  )
  
  reduceBrackets := method(
    if(self size <= 1, self first, self)
  )
  /*
  betaReduce := method(
    writeln("    b-reduce: " .. self)
    n := self copy
    m := nil
    writeln("    size: " .. n size)
    if(n size > 1,
      i := 0
      while(i < n size,
        x := n at(i)
        if(x isKindOf(List),
          n atPut(i, x betaReduce)
          n removeAt(i+1)
        )
        i = i + 1
      )
      if(n first isKindOf(List),
        m = n first applyLambda(n second)
        writeln("      new m: " .. m)
        if(m size > 2, writeln("going deeper...");m betaReduce)
      )
    )
    if(m == nil, m = n)
    m reduceBrackets
  )
  */
  
  betaReduce := method(depth,
    if(depth == nil, depth = 0)
    writeln("    b-reduce(" .. depth .. "): " .. self)
    n := self copy
    writeln("    size: " .. n size)
    if(n size > 1,
      // recurse down
      n foreach(i, x,
        if(x isKindOf(list),
          writeln("    n before(" .. depth .. "): " .. n)
          n atPut(i, x betaReduce(depth+1))
          writeln("    n after(" .. depth .. ") : " .. n)
        )
      )
      // apply at current level
      n foreach(i, x,
        if(x isKindOf(List) and n at(i + 1) != nil,
          q := n copy
          writeln("      SUCCESSFUL APPLICATION! " .. depth)
          m := x applyLambda(n at(i + 1))
          writeln("      n(" .. depth .. ") = " .. m)
          before := n slice(0, i - 1)
          if(i == 0, before = n slice(0,0))
          after := n slice(i + 2)
          writeln("before: " .. before)
          writeln("after: " .. after)
          y := SymbolList with(list(m)) appendList(after) prependList(before)
          writeln("y(" .. depth .. "): " .. y)
          //y := list(m)
          //x rest rest foreach(i, y append(x))
          return y reduceBrackets betaReduce
        )
      )
      // return self
      return n reduceBrackets
    )
    //n reduceBrackets
    n
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
//t := {:a, {:b, [:a]}}
//f := {:a, {:b, [:b]}}


//writeln("one: " .. one)
//writeln("two: " .. two)
two rewrite(:s, :a) rewrite(:z, :b)
//writeln("two, rewritten: " .. two)
//writeln("succ: " .. succ)

//t := {:x, {:y, [:x]}}
//f := {:x, {:y, [:y]}}

//i := {:i, [:i]}
//writeln("i: " .. i)
//writeln("i reduceBrackets: " .. i reduceBrackets)

/*
writeln("id: one: " .. one uniqueId)
writeln("id: one second: " .. one second uniqueId)
writeln("id: one second second: " .. one second second uniqueId)
writeln("id: one second second second: " .. one second second second uniqueId)
*/

//writeln("one applyLambda(succ): " .. one applyLambda(succ))
//writeln("one: " .. one)
//writeln("one applyLambda(succ) applyLambda(two): " .. one applyLambda(succ) applyLambda(two))

writeln("\n-----------------")
s2 := succ applyLambda(two)
ones2 := one applyLambda(succ) applyLambda(two)
//three := one applyLambda(succ) applyLambda(two)