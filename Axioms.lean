/-
  GCTC / GTCT — Axioms.lean

  The toy system of ABSTRACT.md, written down and checked.

      ṙ = r(1 - r²) + 2(r-1)e^(-z)
      θ̇ = 1
      ż = r²   - 2(r-1)²e^(-z)

  NOTE ON METHOD. Nothing here is declared with `axiom`. The system is given by
  explicit definitions and the structural facts about it are theorems, so
  `#print axioms` on anything below reports only Lean's own three. Assumptions,
  where a downstream development needs them, belong in a `structure` field — the
  house style already used by Folder, Unfolder, Thresholder and Compressor.
  STATUS. Elaborated against Mathlib v4.32.0 on lean4 v4.32.0, 29 August 2026.
  Every theorem below was probed with `#print axioms` and reports exactly
  [propext, Classical.choice, Quot.sound] — no `sorryAx`, no `native_decide`.
  Re-check with:  #print axioms GCTC.<name>
-/
import Mathlib

namespace GCTC

open Real Filter Topology

/-- Radial component of the toy field. -/
noncomputable def radialField (r z : ℝ) : ℝ := r * (1 - r ^ 2) + 2 * (r - 1) * exp (-z)

/-- Height component of the toy field. -/
noncomputable def heightField (r z : ℝ) : ℝ := r ^ 2 - 2 * (r - 1) ^ 2 * exp (-z)

/-- Angular component: θ̇ = 1, whence the period T* = 2π. -/
def angularField : ℝ := 1

/-! ### The cylinder r = 1 is invariant, at every height -/

/-- The radial field vanishes on r = 1 for every z: the coupling term carries a
factor (r-1) and dies there too. The unit cylinder is invariant. -/
theorem radialField_one (z : ℝ) : radialField 1 z = 0 := by
  unfold radialField; ring

/-- On r = 1 the height grows at exactly unit rate, for every z. -/
theorem heightField_one (z : ℝ) : heightField 1 z = 1 := by
  unfold heightField; ring

/-- With θ̇ = 1 and ż = 1 on the cycle, one turn takes 2π and lifts z by 2π:
the invariant T* = 2π. -/
theorem period_two_pi : angularField = 1 ∧ (∀ z : ℝ, heightField 1 z = angularField) := by
  refine ⟨rfl, fun z => ?_⟩
  rw [heightField_one]; rfl

/-! ### The transverse eigenvalue, and what μ_max = -2 actually says -/

/-- Derivative of the radial field in r, at fixed height z. -/
theorem hasDerivAt_radialField (z r : ℝ) :
    HasDerivAt (fun s => radialField s z) (1 - 3 * r ^ 2 + 2 * exp (-z)) r := by
  have hid : HasDerivAt (fun s : ℝ => s) 1 r := hasDerivAt_id' r
  have hcube : HasDerivAt (fun s : ℝ => s ^ 3) (3 * r ^ 2) r := by
    simpa using hasDerivAt_pow 3 r
  have h1 : HasDerivAt (fun s : ℝ => s - s ^ 3) (1 - 3 * r ^ 2) r := hid.sub hcube
  have h2 : HasDerivAt (fun s : ℝ => 2 * (s - 1) * exp (-z)) (2 * exp (-z)) r := by
    have : HasDerivAt (fun s : ℝ => (s - 1)) 1 r := by simpa using (hasDerivAt_id r).sub_const 1
    simpa [mul_comm, mul_assoc, mul_left_comm] using (this.const_mul (2 * exp (-z)))
  have e : (fun s : ℝ => radialField s z) = fun s : ℝ => s - s ^ 3 + 2 * (s - 1) * exp (-z) := by
    funext s; unfold radialField; ring
  rw [e]; exact h1.add h2

/-- The transverse eigenvalue at the cycle is `-2 + 2e^(-z)`, not `-2`. -/
theorem eigenvalue_at_one (z : ℝ) :
    HasDerivAt (fun s => radialField s z) (-2 + 2 * exp (-z)) 1 := by
  have h := hasDerivAt_radialField z 1
  have e : (1 : ℝ) - 3 * (1 : ℝ) ^ 2 + 2 * exp (-z) = -2 + 2 * exp (-z) := by ring
  rwa [e] at h

/-- **At every finite height the contraction is strictly weaker than -2.**
This is the exact form of the abstract's caveat: the e^(-z) coupling only
vanishes in the limit. -/
theorem eigenvalue_gt_neg_two (z : ℝ) : -2 < -2 + 2 * exp (-z) := by
  have := exp_pos (-z); linarith

/-- **μ_max = -2 is asymptotic, not attained.** The transverse eigenvalue tends
to -2 as z → ∞, and by `eigenvalue_gt_neg_two` never equals it. -/
theorem eigenvalue_tendsto_neg_two :
    Tendsto (fun z : ℝ => -2 + 2 * exp (-z)) atTop (𝓝 (-2)) := by
  have h : Tendsto (fun z : ℝ => exp (-z)) atTop (𝓝 0) :=
    tendsto_exp_neg_atTop_nhds_zero
  simpa using (tendsto_const_nhds.add (h.const_mul 2) : Tendsto _ atTop (𝓝 ((-2 : ℝ) + 2 * 0)))

/-- Downward, the same coupling amplifies without bound — the inner-basin
behaviour the abstract reports numerically. -/
theorem eigenvalue_tendsto_atTop :
    Tendsto (fun z : ℝ => -2 + 2 * exp (-z)) atBot atTop := by
  have h : Tendsto (fun z : ℝ => exp (-z)) atBot atTop :=
    tendsto_exp_atTop.comp tendsto_neg_atBot_atTop
  simpa using tendsto_atTop_add_const_left _ (-2 : ℝ) (h.const_mul_atTop (by norm_num : (0:ℝ) < 2))

end GCTC
