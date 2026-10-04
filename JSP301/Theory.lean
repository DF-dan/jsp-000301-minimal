import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Fintype.Fin
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import JSP301.PrimeTable

/-!
The original question is disproved by a positive consecutive pair of powerful
numbers, neither a square. The finite exclusion checker below additionally
certifies minimality, using literal primality, divisibility and squareness.
-/

namespace JSP301

def Powerful (n : ℕ) : Prop := ∀ p : ℕ, p.Prime → p ∣ n → p * p ∣ n

def Square (n : ℕ) : Prop := ∃ r : ℕ, r * r = n

def Counterexample (n : ℕ) : Prop :=
  0 < n ∧ Powerful n ∧ Powerful (n + 1) ∧ ¬ Square n ∧ ¬ Square (n + 1)

/- A code stores a square root or prime witness, and which integer it excludes. -/
def Excludes (n code : ℕ) : Prop :=
  let w := code / 4
  match code % 4 with
  | 0 => w * w = n
  | 1 => w * w = n + 1
  | 2 => w ∈ primeWitnesses ∧ w ∣ n ∧ ¬ w * w ∣ n
  | _ => w ∈ primeWitnesses ∧ w ∣ n + 1 ∧ ¬ w * w ∣ n + 1

instance (n code : ℕ) : Decidable (Excludes n code) := by
  unfold Excludes
  split <;> infer_instance

theorem excludes_sound (n code : ℕ) (h : Excludes n code) :
    ¬ Counterexample n := by
  intro hn
  have hmod : code % 4 < 4 := Nat.mod_lt _ (by decide)
  interval_cases hc : code % 4
  · simp only [Excludes, hc] at h
    exact hn.2.2.2.1 ⟨code / 4, h⟩
  · simp only [Excludes, hc] at h
    exact hn.2.2.2.2 ⟨code / 4, h⟩
  · simp only [Excludes, hc] at h
    exact h.2.2 (hn.2.1 _ (primeWitnesses_sound _ h.1) h.2.1)
  · simp only [Excludes, hc] at h
    exact h.2.2 (hn.2.2.1 _ (primeWitnesses_sound _ h.1) h.2.1)

def checkBlock : ℕ → List ℕ → Bool
  | _, [] => true
  | n, code :: rest => decide (Excludes n code) && checkBlock (n + 1) rest

theorem checkBlock_sound (start : ℕ) (codes : List ℕ)
    (h : checkBlock start codes = true) :
    ∀ i : ℕ, i < codes.length → ¬ Counterexample (start + i) := by
  induction codes generalizing start with
  | nil => simp
  | cons code rest ih =>
    simp only [checkBlock, Bool.and_eq_true, decide_eq_true_eq] at h
    intro i hi
    cases i with
    | zero => simpa using excludes_sound start code h.1
    | succ i =>
      have hi' : i < rest.length := by simpa using hi
      simpa [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
        ih (start + 1) h.2 i hi'

end JSP301
