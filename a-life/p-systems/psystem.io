// Membrane computing/P-System example
// Jacob Peck
// 20120430

Environment := Object clone do(
  clone := method(self)  
  symbols := list
  membranes := list
)

Membrane := Object clone do(
  symbols := list
  membranes := list
  rules := list
  parent := nil
  
  init := method(
    self symbols = list
    self membranes = list
    self rules = list
    self parent = nil
  )
)

Rule := Object clone do(
  requirements ::= list
  output ::= list
  output_mode ::= :here // or :out or :in
  priority ::= 1 // higher priorities are chosen first 
  init := method(
    self requirements = list
    self output = list
    self output_mode = :here
    self priority = 1
  )
  with := method(req, out, mode, pri, 
    self clone setRequirements(req) setOutput(out) setOutput_mode(mode) setPriority(pri)
  )
)

DeltaSymbol := :delta

// example problem: generate square numbers
membrane_3 := Membrane clone
membrane_3 symbols = list(:a, :c)
membrane_3 rules = list(Rule with(list(:a), list(:a, :b), :here, 1),
                        Rule with(list(:a), list(:b, DeltaSymbol), :here, 1),
                        Rule with(list(:c), list(:c, :c), :here, 1))

membrane_2 := Membrane clone
membrane_2 rules = list(Rule with(list(:b), list(:d), :here, 1),
                        Rule with(list(:d), list(:d, :e), :here, 1),
                        Rule with(list(:c, :c), list(:c), :here, 2),
                        Rule with(list(:c), list(DeltaSymbol), :here, 1))
membrane_2 membranes append(membrane_3)
membrane_3 parent = membrane_2

membrane_1 := Membrane clone
membrane_1 rules = list(Rule with(list(:e), list(:e), :out, 1))
membrane_1 membranes append(membrane_2)
membrane_2 parent = membrane_1

env := Environment
env membranes append(membrane_1)                        
membrane_1 parent = env

