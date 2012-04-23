#!/usr/bin/env io

// perceptron - learns a linearly separable two argument binary function (or, and, fallacy)
// Jacob Peck

Neuron := Object clone do(
  inputs := list // list of lists
  bias := 0.5
  learning_rate := 0.1
  
  weights := list(Random value(-1.0, 1.0), Random value(-1.0, 1.0))
  
  init := method(
    self inputs = list
  )
  
  output := method( // activation function
    out := 0
    self inputs foreach(i,
      xi := i first
      wi := i second
      out = out + (xi * wi)
    )
    if(out > bias, return 1, return 0)
  )
  
  addInput := method(in, weight,
    self inputs append(list(in, weight))
  )
  
  clearInputs := method(
    self inputs = list
  )

  train := method(training_set,
    loop(
      error_count := 0
      training_set foreach(j,
        // test
        self clearInputs
        x1 := j first first
        x2 := j first second
        dj := j second
        write("(" .. x1 .. "," .. x2 .. ")," .. dj .. " -> ")
        w1 := self weights first
        w2 := self weights second
        self addInput(x1, w1)
        self addInput(x2, w2)
        yj := self output
        write(yj .. " :: weights -> ")
        // adjust weights
        delta := dj - yj
        w1n := w1 + ((self learning_rate * delta) * x1)
        w2n := w2 + ((self learning_rate * delta) * x2)
        self weights = list(w1n, w2n)
        writeln(w1n .. ", " .. w2n)
        if(delta != 0, error_count = error_count + 1)
      )
      writeln("errors this iteration: " .. error_count)
      writeln
      if(error_count == 0, break)
    )
  )
)

// linearly separable -> these will work
or_training_set := list(list(list(0, 0), 0), list(list(0, 1), 1), list(list(1, 0), 1), list(list(1, 1), 1))
and_training_set := list(list(list(0, 0), 0), list(list(0, 1), 0), list(list(1, 0), 0), list(list(1, 1), 1))

// silly and ridiculous: tautology (won't work) and fallacy (works)
tautology_training_set := list(list(list(0, 0), 1), list(list(0, 1), 1), list(list(1, 0), 1), list(list(1, 1), 1))
fallacy_training_set := list(list(list(0, 0), 0), list(list(0, 1), 0), list(list(1, 0), 0), list(list(1, 1), 0))

// not linearly separable -> these will fail
nand_training_set := list(list(list(0, 0), 1), list(list(0, 1), 1), list(list(1, 0), 1), list(list(1, 1), 0))
xor_training_set := list(list(list(0, 0), 0), list(list(0, 1), 1), list(list(1, 0), 1), list(list(1, 1), 0)) 
xnor_training_set := list(list(list(0, 0), 1), list(list(0, 1), 0), list(list(1, 0), 0), list(list(1, 1), 1)) 

training_set := or_training_set // set this to change the target

perceptron := Neuron clone

writeln(perceptron weights .. "\n")

perceptron train(training_set)
