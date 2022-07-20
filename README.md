# Line Interpreter
A tree walking interpreter for a simple grammar, from Appel's Modern Compiler Implementation in ML.

![screenshot](meta/straight_line_program.png)

## Usage
Install dependencies via opam:
```bash
opam install utop
cd line_interpret
utop 
```
Now you can run the line interpreter by executing `#use "line_interpret.ml;;` and `interp prog;;` in utop.   

## Grammar

![screenshot](meta/grammar.png) 

## TODO
- Currently the programs to be interpreted have to be constructed manually into the grammar rules above; in the near future, this construction will happen automatically. 
- Test directory of line programs.
- Dune build file.

