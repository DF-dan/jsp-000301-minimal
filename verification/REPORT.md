# Local verification passed

Date: 2026-10-04. Scope: the complete negative answer to the exact JSP-000301
catalog question, plus a proof that 12167 is the least counterexample.

The mathematical argument and requirement correspondence are in
`MATHEMATICS.md`. The catalog's 2026-09-13 source-review note explicitly states
this yes/no question and credits Golomb's counterexample; the different Erdős
#365 counting problem is outside that expressly scoped record.

## Results actually obtained

1. `lake build --wfail` succeeded for the whole library, including the complete
   original disproof, all 12167 exclusions, and the universal minimality theorem.
2. `lake env lean -DwarningAsError=true Audit.lean` succeeded. Both independent
   restatements use literal Mathlib primality, divisibility and natural squares.
   The malformed certificate negative control was rejected as expected.
3. All 13 axiom audits in `axioms.txt` report only `propext`, `Classical.choice`
   and `Quot.sound`. There are no unproved replacement assumptions or native
   evaluation axioms in the audited dependency closures.
4. `lake env leanchecker --verbose JSP301` succeeded with exit code 0 and
   replayed the four project modules: `JSP301`, `JSP301.Theory`,
   `JSP301.PrimeTable`, `JSP301.Certificates`. Raw output is in
   `kernel-replay.txt`.
5. All nine actual dependency Git revisions match the committed manifest.
   `dependencies.json` records the expected and observed public revisions.

The source files checked here are identified by SHA-256 in `source-hashes.json`.
The award submission additionally pins the full Git commit containing those
files and this record.

## Explicit conclusions and limits

- **Statement correspondence: yes.** The positivity, consecutive integers,
  literal powerfulness and unrestricted squareness match the original catalog
  proposition; the independent audit bridges also passed.
- **Actual Lean checking: passed.** The whole selected source snapshot built,
  both bridges compiled, all named target audits passed, and kernel replay passed.
- **Complete solution: yes for the specified JSP-000301 question.** The verified
  positive counterexample directly refutes the entire universal assertion; no
  missing general case is replaced by an assumption. The stronger minimality
  theorem covers every natural starting integer, using complete finite coverage
  only for the necessary interval below 12167.
- **Lean proof completeness: meets the stated mathematical requirements.**
  Acceptance, priority and prize eligibility are for the organizers to decide.

This is contributor-controlled machine verification, not independent human or
organizer certification. Lean's bundled checker uses Lean's own kernel, not an
independently implemented checker. Imported pinned dependency cache artifacts
are trusted; a complete dependency rebuild and external checker were not run.
The prime pool is proved with `norm_num`, the exclusion data are checked with
`decide +kernel`, and the Python generator supplies no trusted proof step.

Historical disproof and minimal value are known. The formal implementation and
the added minimality certificate checker are the submitted work. Related earlier
finite and infinite-family formalizations are disclosed in `README.md`; no
worldwide-first or award entitlement is claimed.
