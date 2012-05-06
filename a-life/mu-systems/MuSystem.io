#!/usr/bin/env io

// Mu-Systems
// Extended L-systems, which are able to match on strings of symbols
//   with priority based rules
// Jacob Peck
// 20120506

MuSystem := Object clone do(
  // state
  data ::= ""
  rules ::= list()
  generation ::= 0
  pos := 0
  
  // constructor
  init := method(
    data = ""
    rules = list()
    generation = 0
  )
  
  // methods
  age := method(self generation)
  
  addRule := method(string, rule, priority,
    newRule := list(priority, string, rule)
    newRulesList := list()
    self rules foreach(i,
      if(i first != string,
        newRulesList append(i)
      )
    );
    newRulesList append(newRule)
    self setRules(newRulesList)
  )
  
  iterate := method(
    newdata := ""
    if(self data size == 0,
      Exception raise("MuSystem: no initial data")
    )
    if(self rules size == 0,
      Exception raise("MuSystem: no rewrite rules defined")
    )
    self pos = 0
    while(self pos < self data size,
      newdata = newdata .. self applyRule(pos)
      pos = pos + 1
    )
    self setData(newdata asMutable strip)
    self setGeneration(self generation + 1)
  )
  
  applyRule := method(
    possibleRules := self rules select(x, x second beginsWithSeq(self data at(pos) asCharacter))
    possibleRules := possibleRules sortBy(block(x, y, x first > y first))
    //writeln(possibleRules)
    possibleRules foreach(r,
      s := r second
      sz := s size
      o := r third
      if(self data exSlice(self pos, self pos+sz) == s,
        self pos = self pos + sz - 1
        return o
      )
    )
    self data at(self pos) asCharacter
  )
  
  display := method(
    writeln("[" .. self age .. "] " .. self data)
    self
  )
)

writeln("(ab, a, 2) (a, b, 1) (b, c, 1) (c, ab, 1) a")
musys := MuSystem clone addRule("ab", "a", 2) addRule("a", "b", 1) addRule("b", "c", 1) addRule("c", "ab", 1) setData("a")
10 repeat(musys display iterate)
musys display

writeln("\n(ab, a, 1) (a, b, 2) (b, c, 1) (c, ab, 1) a")
musys = MuSystem clone addRule("ab", "a", 1) addRule("a", "b", 2) addRule("b", "c", 1) addRule("c", "ab", 1) setData("a")
10 repeat(musys display iterate)
musys display
