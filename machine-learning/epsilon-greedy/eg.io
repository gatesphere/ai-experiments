#!/usr/bin/env io

// Epsilon-greedy example
// Jacob Peck
// 20120704 (Holy crap, great day for science)
// based upon this: http://stevehanov.ca/blog/index.php?id=132

List anyOne := method( self shuffle first )
List shuffle := method(
  self sortBy(
    block(x, y, 
      (x uniqueId asNumber * Random value) < (y uniqueId asNumner * Random value)
    )
  )
)

Choice := Object clone do(
  name ::= nil
  selected ::= 0
  viewed ::= 0
  
  init := method(
    self name = nil
    self selected = 0
    self viewed = 0
  )
  
  pick := method(
    self setSelected(self selected + 1)
  )
  
  view := method(
    self setViewed(self viewed + 1)
  )
  
  value := method(
    self selected / self viewed
  )
  
  asString := method(
    "#{self name}: #{self selected}/#{self viewed} = #{self value}" interpolate
  )
)

choices := list(
  Choice clone setName("red"),
  Choice clone setName("green"),
  Choice clone setName("blue")
)

Audience := Object clone do(
  preference := "red"
  pref_rate := .3
  non_rate := .2
  
  pick := method(c,
    chk := 0
    if(c name == self preference,
      chk = self pref_rate
      ,
      chk = self non_rate
    )
    Random value <= chk
  )
)

EpsilonGreedy := Object clone do(
  exploration_factor := .10
  
  play := method(
    c := choices first
    if(Random value <= self exploration_factor,
      // random
      c = choices anyOne
      ,
      // highest chance of returns
      choices foreach(i,
        if(i value > c value, c = i)
      )
    )
    c view
    if(Audience pick(c), c pick)
  )
  
  run_trials := method(n,
    n repeat(self play)
  )
  
  asString := method(
    s := "World as it stands:\n"
    choices foreach(i,
      s = s .. i .. "\n"
    )
    s asMutable strip
  )
)

writeln(EpsilonGreedy)
10 repeat(
  EpsilonGreedy run_trials(1000)
  writeln(EpsilonGreedy)
)
