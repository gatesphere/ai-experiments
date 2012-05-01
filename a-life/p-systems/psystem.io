// Membrane computing/P-System example
// Jacob Peck
// 20120430

List anyOne := method(
  self shuffle first
)

List shuffle := method(
  self sortBy(block(x, y, x uniqueId asNumber * Random value < y uniqueId asNumber * Random value))
)

Environment := Object clone do(
  clone := method(self)  
  symbols := list
  skin := nil
  membranes := list
  staging_area := list
  
  print_status := method(
    writeln("symbols: " .. self symbols)
    writeln("membranes: " .. self membranes)
  )
  
  print_world := method(
    writeln("----------------------------------------------")
    self print_status
    writeln
    self membranes foreach(m,
      m print_status
      writeln
    )
  )
  
  tick := method(
    self membranes foreach(m, m stage1)
    self membranes foreach(m, m stage2)
    self staging_area foreach(s, self symbols append(s))
    self staging_area removeAll
  )
  
  asString := method("Environment")
)

Membrane := Object clone do(
  symbols := list
  membranes := list
  rules := list
  parent := nil
  staging_area := list
  
  init := method(
    self symbols = list
    self membranes = list
    self rules = list
    self parent = nil
    self staging_area = list
  )
  
  print_status := method(
    writeln("symbols: " .. self symbols)
    writeln("membranes: " .. self membranes)
    writeln("parent: " .. self parent)
    writeln("staging area: " .. self staging_area)
  )
  
  rule_is_applicable := method(rule,
    counts := Map clone
    rule requirements foreach(s,
      if(counts at(s asString) == nil,
        counts atPut(s asString, 1)
        ,
        counts atPut(s asString, counts at(s asString) + 1)
      )
    )
    s_counts := Map clone
    self symbols foreach(s asString,
      if(s_counts at(s asString) == nil,
        s_counts atPut(s asString, 1)
        ,
        s_counts atPut(s asString, s_counts at(s asString) + 1)
      )
    )
    
    counts keys foreach(s,
      req := counts at(s)
      has := s_counts at(s)
      if(has == nil or has < req, return false)
    )
    return true
  )
  
  apply_rule := method(rule,
    if(self rule_is_applicable(rule),
      rule requirements foreach(s,
        self symbols removeAt(self symbols indexOf(s)) // remove the first occurance of each symbol
      )
      rule output_mode switch(
        :here, rule output foreach(s, self staging_area append(s)),
        :out, rule output foreach(s, self parent staging_area append(s)),
        :in, rule output foreach(s, self membranes anyOne staging_area append(s))
      )
    )
  )
  
  dissolve := method(
    self symbols foreach(s, self parent symbols append(s))
    self membranes foreach(m, 
      m parent = self parent
      self parent membranes append(m)
    )
    Environment membranes remove(self)
  )
  
  stage1 := method(
    rule_ranks := Map clone
    self rules foreach(r,
      if(rule_ranks at(r priority asString) == nil,
        rule_ranks atPut(r priority asString, list(r))
        ,
        rule_ranks atPut(r priority asString, rule_ranks at(r priority asString) append(r))
      )
    )
    rule_ranks keys sort reverse foreach(p,
      rs := rule_ranks at(p) shuffle
      rs foreach(rule,
        while(self rule_is_applicable(rule),
          self apply_rule(rule)
        )
      )
    )
  )
  
  stage2 := method(
    self staging_area foreach(s, self symbols append(s))
    self staging_area removeAll
    if(self symbols contains(DeltaSymbol),
      self symbols remove(DeltaSymbol)
      self dissolve
    )
  )
  
  asString := method(
    "membrane " .. self uniqueId
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
env membranes append(membrane_1, membrane_2, membrane_3)
env skin = membrane_1
membrane_1 parent = env

loop(
  env print_world
  File standardInput readLine
  env tick
)
