# Mathematical proof and correspondence

## The exact original proposition

For every positive integer n, if every prime divisor of n divides n to at least
the second power, and the same is true of n+1, then n or n+1 is a perfect square.
This is precisely the yes/no proposition currently recorded as JSP-000301. A
single valid counterexample disproves the whole proposition.

## Complete disproof

Take n = 12167. The exact factorizations are

\[
12167 = 23^3,\qquad 12168 = 2^3\,3^2\,13^2 = 2^3\,39^2.
\]

Every prime occurring has exponent at least two, so both numbers are powerful.
More generally, for all natural a and b, a²b³ is powerful: any prime divisor
divides a or b, and its square then divides the respective factor. The Lean
proof establishes this general fact using prime divisibility and applies it to
(a,b)=(1,23) and (39,2).

Both numbers lie strictly between 110²=12100 and 111²=12321. If r² equaled either
number, these strict inequalities would imply 110<r<111, impossible for an integer
r. Positivity and consecutiveness are immediate. Hence the universal assertion
is false. This historical counterexample is credited to Golomb (1970), as in
the organizer's source-review note.

## Complete proof that the counterexample is least

For each integer n from 0 through 12166, the supplied certificate exhibits one
of four reasons n cannot start a counterexample:

1. An integer w satisfies w²=n.
2. An integer w satisfies w²=n+1.
3. A prime w divides n but w² does not divide n.
4. A prime w divides n+1 but w² does not divide n+1.

The first two reasons contradict the required nonsquareness. The last two
contradict the required powerfulness. These implications constitute
`excludes_sound`; they apply to arbitrary n and w.

The code c=4w+t stores the witness and the case t in {0,1,2,3}. `Excludes n c`
checks the square equality in the first two cases. In the prime cases it checks
membership in a finite pool of 279 primes, together with the two divisibility
conditions. `primeWitnesses_sound` proves each pool entry is prime using
`norm_num`; the membership condition therefore proves the exact required
primality fact. `checkBlock` recursively
checks each certificate at consecutive integer inputs. `checkBlock_sound` is an
inductive proof that a checked block excludes every input in its interval.

There are 96 blocks. Block b starts at 128b and has length
min(128, 12167−128b). The first 95 have length 128, and the last has length 7.
`block_checked` and `block_length` are proved for **every** b in `Fin 96` by Lean
kernel reduction of the explicit certificate data. No assertion from the Python
generator is assumed.

For an arbitrary n<12167, choose b=floor(n/128) and i=n mod 128. Then b<96,
i is within the exact length of block b, and 128b+i=n. Applying the proved block
soundness gives that n cannot be a counterexample. Combining this exclusion with
the verified counterexample at 12167 proves `least_counterexample`.

This is a finite exhaustive proof of minimality with a proved checking algorithm,
not a statistical test. Minimality is an additional result: the original complete
disproof itself does not need an exhaustive search.

## Requirement-to-proof mapping

| Requirement | Formal evidence |
| --- | --- |
| Natural integer and positivity | `Counterexample` explicitly includes `0 < n`; `golomb_counterexample` proves it. |
| Consecutive numbers | All declarations use n and n+1 directly. |
| Powerful means every prime divisor occurs to exponent at least two | `Powerful` uses Mathlib `Nat.Prime` and literal divisibility by p². |
| Neither number is square, with every root covered | `Square` quantifies over all natural roots; `golomb_counterexample` excludes all roots by the adjacent-square interval. |
| Negation of the whole original assertion | `original_question_disproved` contradicts the assertion with the verified pair. |
| No smaller counterexample | `no_counterexample_below`, proved by complete certificate coverage, and `counterexample_lower_bound`. |
| The least value is exactly 12167 | `least_counterexample` combines the witness and the universal lower bound. |
| Independence from local predicate names | `Audit.lean` restates existence and minimality with literal primality, divisibility and squares. |

The separate Erdős #365 counting question is outside the organizer's expressly
scoped JSP-000301 record. This project makes no mathematical-discovery claim and
no claim to that separate asymptotic counting problem.
