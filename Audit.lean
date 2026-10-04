import JSP301

/- A malformed square certificate is rejected, rather than accepted vacuously. -/
example : JSP301.checkBlock 1 [8] = false := by decide +kernel

/- Independently restated using literal Mathlib primality and divisibility. -/
theorem literal_existence : ∃ n : ℕ, 0 < n ∧
    (∀ p : ℕ, p.Prime → p ∣ n → p ^ 2 ∣ n) ∧
    (∀ p : ℕ, p.Prime → p ∣ n + 1 → p ^ 2 ∣ n + 1) ∧
    (¬ ∃ r : ℕ, r ^ 2 = n) ∧ (¬ ∃ r : ℕ, r ^ 2 = n + 1) := by
  refine ⟨12167, ?_⟩
  simpa only [JSP301.Counterexample, JSP301.Powerful, JSP301.Square, pow_two]
    using JSP301.golomb_counterexample

theorem literal_minimality (n : ℕ) (hn : 0 < n)
    (hl : ∀ p : ℕ, p.Prime → p ∣ n → p ^ 2 ∣ n)
    (hr : ∀ p : ℕ, p.Prime → p ∣ n + 1 → p ^ 2 ∣ n + 1)
    (hsl : ¬ ∃ r : ℕ, r ^ 2 = n) (hsr : ¬ ∃ r : ℕ, r ^ 2 = n + 1) :
    12167 ≤ n := by
  apply JSP301.counterexample_lower_bound n
  simpa only [JSP301.Counterexample, JSP301.Powerful, JSP301.Square, pow_two]
    using And.intro hn (And.intro hl (And.intro hr (And.intro hsl hsr)))

#check JSP301.golomb_counterexample
#check JSP301.no_counterexample_below
#check JSP301.least_counterexample
#check JSP301.original_question_disproved
#print axioms literal_existence
#print axioms literal_minimality
#print axioms JSP301.excludes_sound
#print axioms JSP301.primeWitnesses_sound
#print axioms JSP301.checkBlock_sound
#print axioms JSP301.block_checked
#print axioms JSP301.block_length
#print axioms JSP301.powerful_square_cube
#print axioms JSP301.golomb_counterexample
#print axioms JSP301.no_counterexample_below
#print axioms JSP301.counterexample_lower_bound
#print axioms JSP301.least_counterexample
#print axioms JSP301.original_question_disproved
