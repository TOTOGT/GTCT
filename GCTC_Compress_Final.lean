-- GCTC.Operators.Compress
-- C : X → Y  (compression / information reduction)
-- Models the first phase of the G-chain: reducing a rich input to a
-- compressed representation that preserves essential structure.
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Analysis.Normed.Group.Basic

namespace GCTC

/-- A compression operator on a normed group X. -/
structure Compressor (X : Type*) [SeminormedAddCommGroup X] where
  apply    : X → X
  ratio    : ℝ
  ratio_lt : ratio < 1
  ratio_nn : 0 ≤ ratio
  lipschitz : ∀ x y : X, ‖apply x - apply y‖ ≤ ratio * ‖x - y‖

namespace Compressor

/-- A compressor is Lipschitz with constant `ratio`.
    Core proof: `lipschitzWith_iff_dist_le_mul` reduces the goal to exactly
    the norm bound we have, since `dist = ‖· - ·‖` in a seminormed group. -/
theorem isLipschitz {X : Type*} [SeminormedAddCommGroup X]
    (C : Compressor X) : LipschitzWith ⟨C.ratio, C.ratio_nn⟩ C.apply := by
  rw [lipschitzWith_iff_dist_le_mul]
  intro x y
  simp only [dist_eq_norm]
  exact C.lipschitz x y

/-- Continuity follows immediately from the Lipschitz bound. -/
theorem isContinuous {X : Type*} [SeminormedAddCommGroup X]
    (C : Compressor X) : Continuous C.apply :=
  C.isLipschitz.continuous

/-- Sequential composition of two compressors.
    The product ratio is still < 1 when both ratios are < 1. -/
def comp {X : Type*} [SeminormedAddCommGroup X]
    (C₁ C₂ : Compressor X) : Compressor X where
  apply    := C₁.apply ∘ C₂.apply
  ratio    := C₁.ratio * C₂.ratio
  ratio_lt := mul_lt_one_of_nonneg_of_lt_one_left
                C₁.ratio_nn C₁.ratio_lt (le_of_lt C₂.ratio_lt)
  ratio_nn := mul_nonneg C₁.ratio_nn C₂.ratio_nn
  lipschitz := fun x y =>
    calc ‖C₁.apply (C₂.apply x) - C₁.apply (C₂.apply y)‖
        ≤ C₁.ratio * ‖C₂.apply x - C₂.apply y‖ := C₁.lipschitz _ _
      _ ≤ C₁.ratio * (C₂.ratio * ‖x - y‖) :=
          mul_le_mul_of_nonneg_left (C₂.lipschitz x y) C₁.ratio_nn
      _ = C₁.ratio * C₂.ratio * ‖x - y‖ := by ring

/-- Iterated compression: ‖Cⁿ(x) - Cⁿ(y)‖ ≤ ratio^n · ‖x - y‖.
    Proved by induction using the Lipschitz bound at each step. -/
theorem iterate_bound {X : Type*} [SeminormedAddCommGroup X]
    (C : Compressor X) (n : ℕ) (x y : X) :
    ‖C.apply^[n] x - C.apply^[n] y‖ ≤ C.ratio ^ n * ‖x - y‖ := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp only [Function.iterate_succ', Function.comp]
    calc ‖C.apply (C.apply^[n] x) - C.apply (C.apply^[n] y)‖
        ≤ C.ratio * ‖C.apply^[n] x - C.apply^[n] y‖ := C.lipschitz _ _
      _ ≤ C.ratio * (C.ratio ^ n * ‖x - y‖) :=
          mul_le_mul_of_nonneg_left ih C.ratio_nn
      _ = C.ratio ^ (n + 1) * ‖x - y‖ := by ring

/-- The orbit of any point under iteration is Cauchy.
    This is the key step toward the fixed-point theorem for complete spaces. -/
theorem iterate_cauchySeq {X : Type*} [SeminormedAddCommGroup X]
    (C : Compressor X) (x : X) :
    CauchySeq (fun n => C.apply^[n] x) := by
  apply cauchySeq_of_le_geometric C.ratio C.ratio_nn C.ratio_lt
  intro n
  rw [dist_eq_norm]
  exact C.iterate_bound n x (C.apply x)

/-- In a complete space, every compressor has a unique fixed point. -/
theorem hasUniqueFixedPoint {X : Type*} [SeminormedAddCommGroup X]
    [CompleteSpace X] (C : Compressor X) :
    ∃! x : X, C.apply x = x :=
  C.isLipschitz.hasFixedPoint
    (by constructor; exact C.ratio_nn; exact le_of_lt C.ratio_lt)

end Compressor

end GCTC
