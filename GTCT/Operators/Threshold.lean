-- GCTC.Operators.Threshold
-- K : X → X  (threshold / nonlinear gate)
-- Models the second phase: applying a nonlinear cutoff that separates
-- signal from noise, or relevant from irrelevant structure.

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GCTC

/-- A threshold operator: zeroes out components below a cutoff. -/
structure Thresholder (X : Type*) where
  apply    : X → X
  /-- The threshold level. -/
  cutoff   : ℝ
  /-- Applying twice is the same as applying once (idempotent). -/
  idem     : ∀ x, apply (apply x) = apply x

/-- Soft-threshold function on ℝ: max(|x| - c, 0) · sign(x).
    (Using `c` for the cutoff; `λ` is a reserved keyword in Lean 4.) -/
noncomputable def softThreshold (c : ℝ) (x : ℝ) : ℝ :=
  if x > c then x - c
  else if x < -c then x + c
  else 0

/-- Soft threshold is odd when the cutoff is non-negative:
    softThreshold c (-x) = -softThreshold c x. -/
lemma softThreshold_neg (c : ℝ) (hc : 0 ≤ c) (x : ℝ) :
    softThreshold c (-x) = -softThreshold c x := by
  simp only [softThreshold]
  split_ifs with h1 h2 h3 h4 <;> push_neg at * <;> linarith

end GCTC
