import JSP301.Theory
import JSP301.Certificates

namespace JSP301

theorem powerful_square_cube (a b : ℕ) : Powerful (a ^ 2 * b ^ 3) := by
  intro p hp hd
  rcases hp.dvd_mul.mp hd with ha | hb
  · have hpa : p ∣ a := hp.dvd_of_dvd_pow ha
    exact dvd_mul_of_dvd_left (by simpa [pow_two] using Nat.mul_dvd_mul hpa hpa) _
  · have hpb : p ∣ b := hp.dvd_of_dvd_pow hb
    have hp2 : p * p ∣ b * b := Nat.mul_dvd_mul hpb hpb
    have hp3 : p * p ∣ b ^ 3 := by
      simpa [pow_succ, pow_two] using dvd_mul_of_dvd_left hp2 b
    exact dvd_mul_of_dvd_right hp3 _

theorem golomb_counterexample : Counterexample 12167 := by
  refine ⟨by decide, ?_, ?_, ?_, ?_⟩
  · simpa using powerful_square_cube 1 23
  · norm_num at ⊢
    convert powerful_square_cube 39 2 using 1
  · rintro ⟨r, hr⟩
    have hlo : 110 < r := by nlinarith
    have hhi : r < 111 := by nlinarith
    omega
  · rintro ⟨r, hr⟩
    have hlo : 110 < r := by nlinarith
    have hhi : r < 111 := by nlinarith
    omega

theorem no_counterexample_below (n : ℕ) (hn : n < 12167) :
    ¬ Counterexample n := by
  let b : Fin 96 := ⟨n / 128, by omega⟩
  have hi : n % 128 < (certificateBlock b.val).length := by
    rw [block_length b]
    dsimp [b]
    omega
  have h := checkBlock_sound (b.val * 128) (certificateBlock b.val)
    (block_checked b) (n % 128) hi
  have heq : b.val * 128 + n % 128 = n := by
    dsimp [b]
    omega
  simpa only [heq] using h

/-- Every positive consecutive powerful nonsquare pair starts at least at 12167. -/
theorem counterexample_lower_bound (n : ℕ) (hn : Counterexample n) :
    12167 ≤ n := by
  by_contra h
  exact no_counterexample_below n (by omega) hn

/-- Golomb's example is the least counterexample, not merely one tested pair. -/
theorem least_counterexample :
    Counterexample 12167 ∧ ∀ n : ℕ, Counterexample n → 12167 ≤ n :=
  ⟨golomb_counterexample, counterexample_lower_bound⟩

/-- This directly negates the whole universal assertion in the JSP catalog. -/
theorem original_question_disproved :
    ¬ (∀ n : ℕ, 0 < n → Powerful n → Powerful (n + 1) →
      Square n ∨ Square (n + 1)) := by
  intro h
  rcases golomb_counterexample with ⟨hp, hl, hr, hsl, hsr⟩
  rcases h 12167 hp hl hr with hsq | hsq
  · exact hsl hsq
  · exact hsr hsq

end JSP301
