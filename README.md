# JSP-000301: a complete disproof and the least counterexample

This repository contains an original Lean implementation by **DF-dan**, with
OpenAI Codex assistance. It proves the complete negative answer to the
[JSP-000301 catalog question](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0301-0400.md#JSP-000301):

> If two consecutive positive integers are powerful, must at least one be a perfect square?

The answer is **no**. Golomb's classical pair is 12167 and 12168. In addition to
checking that pair and directly negating the universal assertion, this project
proves that **12167 is the least starting integer for any such counterexample**.
The new implementation includes a general exclusion-certificate checker, its
soundness proof, and complete kernel-checked coverage of every integer below
12167. No imported competing proof project is used.

## Scope and attribution

The mathematical disproof is Solomon W. Golomb's: *Powerful numbers*, American
Mathematical Monthly 77(8) (1970), 848–852,
[DOI 10.2307/2317020](https://doi.org/10.2307/2317020).
The catalog's source-review note of 2026-09-13 explicitly records this disproof
and scopes JSP-000301 to the yes/no question above. This is a complete solution
to that question. The different counting question on the
[Erdős #365 page](https://www.erdosproblems.com/365) is not the target here.

The minimal value is also known; see [OEIS A227297](https://oeis.org/A227297).
This submission claims a Lean implementation, not a new mathematical discovery.
Numerous related formalizations already exist, including
[PR #187](https://github.com/TheJustinSunPrize/awards/pull/187) (finite disproof),
[PR #412](https://github.com/TheJustinSunPrize/awards/pull/412) (infinite family),
[PR #587](https://github.com/TheJustinSunPrize/awards/pull/587) (general seed and counting bounds),
and [PR #2122](https://github.com/TheJustinSunPrize/awards/pull/2122) (Pell family).
Their existing contributions remain attributed to their authors. Our additional
formalized result is **minimality**, supported by explicit exclusion certificates
for all 12167 smaller natural integers, including zero. A 2026-10-04 search of
related PR titles/bodies for minimality, smallest/least counterexample and 12166
did not find a claimed proof of this minimality result; that search is not an
exhaustive worldwide priority audit. No first-formalization or award entitlement
is asserted.

## Statements and files

- `JSP301/Theory.lean`: literal prime/divisibility definition of `Powerful`,
  square-root definition of `Square`, the original counterexample predicate,
  decidable exclusion witnesses, and a proved soundness theorem for the checker.
- `JSP301/Certificates.lean`: generated witness data for integers 0–12166 in 96
  blocks, and kernel-checked proofs of every block's validity and exact length.
- `JSP301/PrimeTable.lean`: the 279 prime witnesses used by the certificates,
  each proved prime with `norm_num`. The checker uses proved membership in this
  pool to avoid repeating expensive primality decisions.
- `JSP301.lean`: the verified Golomb pair, the complete minimality result
  `JSP301.least_counterexample`, and the direct full disproof
  `JSP301.original_question_disproved`.
- `Audit.lean`: independent restatements in literal Mathlib primality,
  divisibility and natural squares, plus axiom audits of all named proof targets.
- `MATHEMATICS.md`: complete mathematical argument and statement correspondence.

The principal strengthened theorem is:

```lean
theorem least_counterexample :
  Counterexample 12167 ∧ ∀ n : ℕ, Counterexample n → 12167 ≤ n
```

There are no additional number-theoretic assumptions. `Powerful n` means
`∀ p : ℕ, p.Prime → p ∣ n → p * p ∣ n`; squareness quantifies over every natural
root, without a bounded-root substitution. Positivity is required explicitly.

## Reproduction

The toolchain is **Lean 4.35.0-rc2**. Mathlib is pinned to
`7ef65c0feea1fb202b501b758e8920144cc0c3a2`, and all transitive dependencies are
fixed in `lake-manifest.json`. Use the selected commit supplied in the submission;
do not run `lake update`.

With Git, Python 3 and elan installed:

```sh
git clone https://github.com/DF-dan/jsp-000301-minimal.git
cd jsp-000301-minimal
# git checkout --detach <the full selected commit from the submission>
lake exe cache get
lake build --wfail
lake env lean -DwarningAsError=true Audit.lean
lake env leanchecker JSP301.Theory JSP301.Certificates JSP301
```

The computational proof uses `decide +kernel`, not native evaluation.
The Python generator is **not trusted**: it only proposes data. Every entry is
checked by Lean, and the implication from the checked data to minimality is
proved in Lean. To reproduce the data:

```sh
python scripts/generate_certificates.py
git diff --exit-code -- JSP301/Certificates.lean JSP301/PrimeTable.lean
```

Lean elaboration and its bundled kernel replay are distinct from independent
human review or an independently implemented checker. The pinned Mathlib cache
and imported dependency artifacts are trusted as imported libraries. Machine
verification does not establish organizer acceptance, priority or prize eligibility.

## License

New source in this repository is MIT licensed. Mathlib and its dependencies
retain their own licenses. Historical mathematics remains attributed above.
