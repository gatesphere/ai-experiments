#!/usr/bin/env io

// simulation of the distance-vector approach to shortest-path routing

Interface := Object clone do(
  head ::= nil
  tail ::= nil
  weight ::= 0
  
  init := method(
    self head = nil
    self tail = nil
    self weight = 0
  )
  
  with := method(h, t, w,
    self clone setHead(h) setTail(t) setWeight(w)
  )
  
  otherEnd := method(a,
    if(self head == a, return self tail, return self head)
  )
)

Node := Object clone do(
  name ::= nil
  routingTable ::= nil
  interfaces ::= nil
  unsent ::= nil
  unprocessed ::= nil
  
  init := method(
    self name = nil
    self routingTable = Map clone
    self interfaces = list()
    self unsent ::= nil
    self unprocessed ::= list
  )
  
  with := method(name,
    self clone setName(name)
  )
  
  addInterface := method(inter,
    self interfaces append(inter)
  )
  
  addConnection := method(node, weight,
    i := Interface with(self, node, weight)
    self interfaces append(i)
    node addInterface(i)
    self
  )
  
  initialEntries := method(
    self interfaces foreach(inter,
      self routingTable atPut(inter otherEnd(self) name, list(inter weight, inter otherEnd(self) name))
    )
    self routingTable atPut(self name, list(0, self name))
  )
  
  receive := method(x,
    self unprocessed append(x)
  )
  
  processReceived := method(
    if(self unprocessed size == 0, return self)
    self unprocessed foreach(dtable,
      from := dtable first
      basedist := self getDistance(from)
      vector := dtable rest
      vector foreach(entry,
        dest := entry first
        if(dest == self name, continue)
        mydist := self getDistance(dest)
        if(mydist == "*", mydist = Number constants inf)
        newdist := basedist + entry second
        //writeln(self name .. " to " .. dest .. " through " .. from .. " -> mydist: " .. mydist .. " newdist: " .. newdist)
        if(newdist < mydist,
          //writeln("Found shorter route from " .. self name .. " to " .. dest .. ": " .. newdist .. " vs " .. mydist)
          self routingTable atPut(dest, list(newdist, from))
        )
      )
    )
    self unprocessed = list()
    self
  )
  
  prepareDVector := method(
    self unsent = list(self name)
    self routingTable keys foreach(dest,
      self unsent append(list(dest,self routingTable at(dest) first))
    )
    self
  )
  
  sendDVector := method(
    self interfaces foreach(i,
      i otherEnd(self) receive(self unsent)
    )
    self unsent = nil
    self
  )
  
  getDistance := method(node,
    d := self routingTable at(node)
    if(d == nil, "*", d at(0))
  )
)

Clock := Object clone do(
  tickCount := 0
  nodes := list
  
  clone := method(self)
  
  addNode := method(node,
    self nodes appendIfAbsent(node)
    self
  )
  
  tick := method(
    if(self tickCount isEven,
      self nodes foreach(n,
        n processReceived
        n prepareDVector
      )
      ,
      self nodes foreach(n,
        n sendDVector
      )
    )
    self tickCount = self tickCount + 1
    self
  )
  
  globalTable := method(
    out := "      "
    self nodes foreach(node,
      out = out .. node name .. "   "
    )
    writeln(out)
    self nodes foreach(node,
      out := node name .. "     "
      self nodes foreach(node2,
        out = out .. node getDistance(node2 name) .. "   "
      )
      writeln(out)
    )
    writeln
  )
)

// network example
/*
      3         6
  A--------C-------F
  |        |
 8|       1|
  |   2    |    2
  D--------E-------B
  
*/

A := Node with("A")
B := Node with("B")
C := Node with("C")
D := Node with("D")
E := Node with("E")
F := Node with("F")

A addConnection(C,3) addConnection(D,8)
C addConnection(F,6) addConnection(E,1)
D addConnection(E,2)
E addConnection(B,2)

A initialEntries
B initialEntries
C initialEntries
D initialEntries
E initialEntries
F initialEntries

Clock addNode(A) addNode(B) addNode(C) addNode(D) addNode(E) addNode(F)

3 repeat(
  Clock tick tick globalTable
)
