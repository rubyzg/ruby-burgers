# Code complete book highlights

- general thoughts about Code Complete: long but briliant

Global data
===========
Intro
-----
Most developers know that "global variables are bad".
Few know why *exactly* are they bad?

Global variables vs global data
-------------------------------
- our apps have a lot of global data:
  - database data
    (can be accessed from anywhere in the app)
  - configuration settings
  - other e.g. `Time.now`

- not all "global data" is "global variables"

- constants are global data, but not global vars

- global variables are *bad*

Why are global variables bad?
-----------------------------
1. accidental changes to global variables
  - hard to explain, personal experience

2. issues with threads
  `
  def foo(value)
    $bar = value
    puts $bar     # with threads, value of global var is uncertain
  end
  `

3. prevents code reuse
  - when e.g. copy pasting code from project to project, 2nd project needs to
    have the same global variable as the 1st project

4. modularity damaged, complexity increased
  - Programs benefit from complete decoupling between 2 modules (parts of
    programs). In that case it's easy for a developer to focus on a single
    module and understand it.
  - global data breaks modularity, prevents developer focusing on a single part
    of program

Structured programming
======================
Intro
-----
- was a huge idea in 60's-70's
- introduced by Dijkstra (think Matz for all programming languages :)

- context important for this:
  - Fortran is the king, but has no for loops
  - widespread use of `goto`s for everything

Ideas
-----
1. Programs should use only one-in, one-out program constructs.
  That means a code block should start in 1 place and end in 1 place only.

2. Programs should use *only* these 3 constructs:

  1. sequence
    - variable assignments, function calls
  2. selection / branching
    - if, case
  3. loops
    - for, while

*Implications*
- break, continue, early return, throw-catch, goto are code smells
- primarily targeted at `goto`

"Programming, the good parts"

Benefits
--------
- more program readability
- more understanding
- better programs

Relevancy today
---------------
- Fowler and Beck said multiple/early returns are fine if they help clarity
- new constructs not covered: classes, threads..

- values still relevant:
  - locality
  - imperatives: readability and understanding

Exceptions
==========
- used for passing errors and exceptional events to the code that called it
- code that does not know how to handle error returns control to some other part
  of the system

When to use exceptions
----------------------
- use to notify callers of the program about errors that should not be ignored
  Example: using nil return value in Ruby can be ignored, not the exception

- use for conditions that are truly exceptional
  Use for conditions that cannot be addressed by other coding practices. Not for
  events that are infrequent, but for events that should never occur.

When not to use exceptions
--------------------------
- exceptions weaken abstraction/encapsulation: code that calls the routine must
  know which exceptions can be thrown inside. This increases code complexity.

- if a condition can be handled locally, handle it locally

- Exceptions are part of function interface (obvious in Java).
  Make sure exceptions are at the same abstraction level as the rest of the
  code.

  Example:
  function `find_string("foo")` returns EOF (end of file) error
  it should return `StringNotFound` error
