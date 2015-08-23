# Why isn't Enumerable#each\_with\_object working as expected!?
## Objects and their mutation ability

**What is an object?**

It is an entity that has certain state and can have ability or abilities.

**What is immutability?**

*It is a trait of an object by which we (programmers) know whether we can change its state.*

> **Object IS NOT its STATE.**

Imagine an object. Now, that object has a certain state, a value. At a certain point in time, that state makes a part of its whole.

It also has some kind of a life cycle. It is "born", it "lives" and then it - "dies". While it lives, that object possesses identification number. That number is his *object id* (Object#object\_id). If we want to check if a some object is an object we are looking for, we call #object_id on it.

State of an object either can, or can't, be altered during its life cycle. If an objects state *can be altered*, we say that **it is mutable**. And contrary **if we can't alter its state, we label it - immutable**.

> **MUTABLE objects CAN CHANGE STATE.**

> **IMMUTABLE objects CAN'T.**

## Objects in Ruby

**Two objects with identical ID can't exist. There is only one object with its uniqe ID.**

    a = Object.new
    b = a
    c = b
    a.object_id == b.object_id # => true
    a.object_id == c.object_id # => true
    b.object_id == c.object_id # => true


## Primitives in Ruby

In Ruby, there are no *real primitives*. Since each primitive in Ruby is an object, that means it has its class and an "instance baggage" which comes with it when instantiated. It is not simply some type of value that exists for itself on a low level. For that reason Ruby has a pretty high *"abstraction penalty"*, and for the same reason, it is *a joy to work it*.

What you might call primitives in Ruby are instances of the following classes:

+ String
+ Integer
+ Float
+ Symbol
+ Boolean
+ Nil

## Variables, References, Objects, States

#### Variables

Ok, so we have an object in our program, let's say an instance of class String. How do we get to it? How do we use it repeatedly throughout our program? We, of course, *use variables*.

**Variable is a language construct, a tool, which enables us to get a hold of an object.** It is always positioned on the left hand side (LHS) of a variable assignment:

    i_point_to_string = "Variable 'i_point_to_string' stores a reference to Me. Who am I?! I'm a string object and a value you are reading now, is my state."

*Variable stores either a reference to an object, or an immediate value of an object*. What it stores depends on instance of which class it is assigned to. If it is an object with immediate value then it doesn't stores a reference, it stores its value. Otherwise, it stores a reference.
Ruby, of course, does this for a programmer.

Objects with immediate values are instances of these classes:

+ Integer
+ Float
+ Symbol
+ TrueClass
+ FalseClass
+ Nil

*None of these classes have #new method defined. They don't need it*, since their instances are present in a program by default.

#### References

**Reference is essentially an address of an object in a memory.** It is stored in a variable and points to an object assigned to a variable.

    v1 = "string object"             # creating a string object
    v2 = v1                          # passing on the reference from v1 to v2
    puts v2                          # => "string object"
    v1.object_id == v2.object_id     # => true

In example above variable 'v2', when assigned to 'v1', stores the reference to the same object 'v1' refers to.

**Objects have "has_many" relationship with references**.

#### Objects and States

**States of objects that don't have immediate values can be changed**:

    string = "Great string"          # creating string
    string_id = string.object_id     # saving its ID
    string << " lives on!"           # CHANGING state of the object
    string.object_id == string_id    # => true
                                     # same object with a different state / value

Creating new object along with its reference, using the same variable:

    s1 = "String order"              # creating a reference to first object
    s1_id = s1.object_id             # storing first objects ID
    s1 += " changed."                # creating new object with its reference,
                                     # but using the same variable.
    s1.object_id != s1_id            # => true

Creating new object with its own state:

    old = "Oh, my back hurt."        # first object
    young = old                      # second variable referencing first object
    young = "OOhh, I'm so in shape." # second variable referencing second object
    old.object_id == young.object_id # different objects, different states

## Duplicating, cloning and freezing an object

What happens when you duplicate an object? **You don't duplicate an object, you duplicate it's state.**

**Duplication** copies an objects state and creates a new object.

    s1 = "string"
    s2 = s1.dup
    s1 == s1                         # => true
    s1.object_id == s2.object_id     # => false

What happens when you freeze an object? You prevent it state from changing, ergo **making it quasi-immutable**.

It is possible to prevent alteration of an objects state with **freezing** an object.

    s1 = "string"
    s1.freeze
    s1 << " can't change state."     # => RuntimeError: can't modify frozen String

This shows us that objects state can have its state. Namely its state can be changed or it can't be changed.

**Cloning** copies an objects state and creates a new object, AND **copies a state of its state**.

    s1 = "string"
    s1.freeze

    s_clone = s1.clone
    s_dup = s1.dup

    s_clone << "!"                   # => RuntimeError: can't modify frozen String
    s_dup << "!"                     # => "string!"

So it's essentialy all about creating new object and altering their states.

## So, Are you mutable, or not?!

At the end, if we say that an object is mutable, we are saying that we can change it's state and keep his ID intact.

Immutable objects have one ID and only one state.

In Ruby, division of mutable instances of classes is as follows:

+ **mutable**: String, Array, Hash, Range
+ **immutable**: Integer, Symbol, Float, Nil, TrueClass, FalseClass
