---
Title: Tom's proof primer
...

# Tom's proof primer

The idea of this document is to describe some of the common proof techniques 
that you'll encounter in computer science. I've also included some common 
transformations that you'll use.

# Proof techniques

A mathematical proof is shows that a statement is logically true. This means
that you need to make a logical argument why the statement is true. You need
to show that a claim is true for *all* cases, not just a few examples. This is
why you can't just plug a few examples into these statements and then claim 
the statement is true. 

Testing with real numbers into statements can give you intuition about how the
problem works though! It's very helpful if you get stuck and don't know how
to progress, but specific examples are not part of a formal proof.

## Equivalence

These are very common in math textbooks where you are asked to show that one
thing is equal to another thing: $A = B$. The way you solve these is by showing
that you can convert $A$ to $B$ or $B$ to $A$ through algebraic manipulations.
Here's a simple example where we prove Bayes rule: $P(A|B) = \frac{P(B|A) P(A)}{P(B)}$.

\begin{align*}
  P(A|B) & = \frac{P(B|A) P(A)}{P(B)} \\
  P(A|B) P(B) & = P(B|A) P(A) && \text{multiply both sides by } P(B) \\
  P(A,B) &= P(B,A) && \text{using the rule that } P(A | B) P(B) = P(A,B) \\
  P(A,B) &= P(A,B) && \text{logical and is commutative}
\end{align*}

Note that I've included justifications for the algebraic rules used at every
step. This is good practice so the reader of your proof can follow it more
easily.

## Induction

Proof by induction is used alot for proving running time of algorithms or for
sequences. A proof by induction consists of two parts:

1. Showing that the statement holds for the base case. 
2. Proving that, if we assume the statement holds for the $n$th case, then it
   also holds true for the $(n+1)$th case.

This proof works because you have proven that given a particular input size,
the proof still holds if you increase the input by one. Because you've shown
the base case holds you can use that as the $n$th case and use that to start
a sequence of true statements.

Proving part 1 is usually quite easy. Step 2 is often harder because you need
to show that the $(n+1)$ case is the same form as the $n$th case.

## Contradiction

Sometimes it's hard to show that a statement is true. A proof by contradiction
works by assuming that the statement is not true, then using a number of
logical derivations, shows that you reach a logical contradiction. This proof
technique was used to for one of the most famous proofs in computer science.
Alan Turing used it to prove that a general algorithm cannot be used to solve
the halting problem.

# Useful facts/algebra rules

Equivalence: If $A = B$ and $B = C$, then $A = C$. This also works for proofs
where you have to show something like $P(A | B) P(B) = P(A,B) = P(B | A) P(A)$.

$\frac{a}{a + b} = \frac{1}{1 + b/a}$

Contrapositive: When you have a true statement, $A \implies B$, then you
can also claim $\neg B \implies \neg A$.

Converse error: $A \implies B$ and $B \implies A$ are *not* logically
equivalent!  The converse error and inverse error are common logical falacies.

Inverse error: $A \implies B$ and $\neg A \implies \neg B$ are *not*
logically equivalent!  The converse error and inverse error are common logical
falacies.

$P(A | B) \neq P(B | A)$

You can't divide a matrix or vector by another. There is the idea of the 
inverse of a matrix or vector which is roughly equivalent to division. 

There is a distributive law for matrices and vectors, i.e. $C(A + B) = CA + CB$,
if $A$, $B$, and $C$ are matrices/vectors.


