// Lambda Calculus
// Jake Peck
// 20120503

curlyBrackets := getSlot("list")
squareBrackets := method(SymbolList with(call evalArgs))

List asString := method(
  "{".. self join(", ") .. "}"
)

List rewrite := method(a, b,
  /*
  writeln("a: " .. a)
  writeln("b: " .. b)
  writeln("self: " .. self)
  writeln("self first: " .. self first .. " " .. self first == a)
  writeln("self second: " .. self second)
  */
  if(self first == a, self atPut(0, b); writeln("replacing..."))
  if(self second isKindOf(List),
    self second rewrite(a,b)
    ,
    if(self second == a, self atPut(1, b))
  )
  self
)

List applyLambda := method(lambda,
  sym := self first
  new_lambda := self second
  new_lambda rewrite(sym, lambda)
  new_lambda
)

SymbolList := List clone do(
  asString := method(
    "[" .. self join .. "]"
  )
  
  with := method(args,
    self clone appendList(args)
  )
  
  appendList := method(list,
    list foreach(i, self append(i))
  )
)
