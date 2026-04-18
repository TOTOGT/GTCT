/-
Copyright (c) 2026 Pablo Nogueira Grossi — G6 LLC. All rights reserved.
Released under the MIT License. See the LICENSE file in the project root.
Authors: Pablo Nogueira Grossi
-/

-- GCTC.Operators.Chain  (UPDATED 2026-04-18)
-- G = U ∘ F ∘ K ∘ C  (the full operator chain)
--
-- This module assembles the four primitive operators into the G-chain,
-- defines the g-series regime taxonomy, and states the Spiral Return
-- theorem (T1) from the GTCT working paper.
--
-- AXLE proof obligations:
--   (a) Gronwall-type contraction on the OUTER basin  [gronwall_outer]
--   (b) Asymmetric inner-basin boundary r_star ≈ 0.8  [r_star, inner_basin]
--   (c) Spiral-return theorem T1                      [spiral_return_exists]
--   (d) Poincaré-Collatz conjecture                   [poincare_collatz]
--
-- CHANGES FROM THE PREVIOUS VERSION (2026-04-18):
--   • The symmetric stability radius ε₀ = 1/3 has been **removed**. The dm³
--     numerics (FINDINGS.md; reproduced 2026-04-18) show the claim is false
--     on the inner side: r(0) = 0.667 collapses, r(0) = 2.5 remains stable.
--   • Replaced with an asymmetric-basin formulation: a named constant
--     `r_star : ℝ` (empirically ≈ 0.8) for the inner boundary, and an
--     explicit statement that the outer basin has no finite radius.
--   • The `gronwall_outer` theorem (formerly `gronwall_bound`) now has the
--     correct hypothesis  μ_max + 3ε ≤ -μ_bound  (the old hypothesis
--     μ_max + 3ε < 0 was insufficient and the original statement was false).
--   • `SpiralReturn.not_fixed` was moved out of the structure and into the
--     theorem hypothesis, because for chains with a single fixed point the
--     old formulation was false.

import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import GCTC.Operators.Compress
import GCTC.Operators.Threshold
import GCTC.Operators.Fold
import GCTC.Operators.Unfold

namespace GCTC

-- ---------------------------------------------------------------------------
-- 1.  The G-chain
-- ---------------------------------------------------------------------------

/-- Bundle of all four operators acting on a common type X. -/
structure GChain (X : Type*) [MetricSpace X] [SeminormedAddCommGroup X] where
  C : Compressor X
  K : Thresholder X
  F : Folder    X
  U : Unfolder  X

/-- One application of G = U ∘ F ∘ K ∘ C. -/
def GChain.apply {X : Type*} [MetricSpace X] [SeminormedAddCommGroup X]
    (G : GChain X) (x : X) : X :=
  G.U.apply (G.F.apply (G.K.apply (G.C.apply x)))

/-- G iterated n times (via Nat.iterate convention: iter 0 x = x,
    iter (n+1) x = G.apply (iter n x)). -/
def GChain.iter {X : Type*} [MetricSpace X] [SeminormedAddCommGroup X]
    (G : GChain X) (n : ℕ) (x : X) : X :=
  Nat.iterate G.apply n x

-- ---------------------------------------------------------------------------
-- 2.  g-series regime taxonomy
-- ---------------------------------------------------------------------------

/-- The five dynamical regimes of the GTCT g-series.
    Labels are mnemonic: g⁰ (zero), g² (two), g⁶ (six),
    g33 (stability threshold), g64 (circuit saturation). -/
inductive GSeries : Type
  | g0  : GSeries   -- quiescent / initialised
  | g2  : GSeries   -- nascent oscillation
  | g6  : GSeries   -- stable micro-cycle
  | g33 : GSeries   -- stability threshold  (≥ 33 cycles)
  | g64 : GSeries   -- circuit saturation   (= 64 cycles)
  deriving Repr, DecidableEq

/-- Numeric cycle count associated with each regime. -/
def GSeries.cycles : GSeries → ℕ
  | .g0  => 0
  | .g2  => 2
  | .g6  => 6
  | .g33 => 33
  | .g64 => 64

/-- The g-series is ordered by cycle count. -/
instance : LE GSeries where
  le a b := a.cycles ≤ b.cycles

instance : DecidableRel ((· ≤ ·) : GSeries → GSeries → Prop) :=
  fun a b => (inferInstance : Decidable (a.cycles ≤ b.cycles))

/-- g³³ stability index: cycles for g33 is 33, by definition. -/
theorem g33_stability_index : GSeries.cycles .g33 = 33 := rfl

-- ---------------------------------------------------------------------------
-- 3.  Asymmetric-basin geometry (replaces the symmetric ε₀ claim)
-- ---------------------------------------------------------------------------

/-- **Inner-basin boundary** for the dm³ radial coordinate.
    Empirical value ≈ 0.8 from the DOP853 stability sweep; trajectories
    with `r(0) < r_star` collapse (`z → -∞` in finite time) due to the
    exponential amplification of the `e^{-z}` coupling in the ODE.
    See `FINDINGS.md` for the sweep data and `Chain_updated.lean` header
    for the rationale for replacing ε₀ = 1/3. -/
noncomputable def r_star : ℝ := 0.8

lemma r_star_lt_one : r_star < 1 := by
  unfold r_star; norm_num

lemma r_star_pos : 0 < r_star := by
  unfold r_star; norm_num

/-- **Linearised outer-basin decay rate.**
    Eigenvalue of the linearisation of the dm³ radial flow at r = 1:
    dr̃/dt = -2 · r̃ + O(e^{-z}). -/
noncomputable def μ_outer : ℝ := -2

lemma μ_outer_neg : μ_outer < 0 := by
  unfold μ_outer; norm_num

/-- **Inner basin is bounded.** For the dm³ toy system, any initial radius
    `r₀ < r_star` yields a finite-time collapse (not a convergence to the
    helical limit set). Formally: the radial coordinate `r` is not the only
    obstruction — once `z` becomes negative, the `e^{-z}` coupling dominates.
    This is the **correction** to the symmetric `|r - 1| < 1/3` Gronwall claim.

    The full dynamical proof requires the dm³ ODE; stated here as an axiomatic
    witness for the GCTC framework. -/
axiom inner_basin_is_asymmetric :
  ∀ (r₀ : ℝ), r₀ < r_star → ∃ (T : ℝ), 0 < T ∧
    ∀ (z : ℝ → ℝ), (∀ t, 0 ≤ t → z t < 0) →
    ¬ (∀ t, 0 ≤ t → t < T → True)  -- placeholder: "trajectory does not survive on [0, T)"
    -- TODO(AXLE): replace with a real statement about the dm³ flow once the
    -- ODE is formalised; currently a dependency boundary.

/-- **Outer basin has no finite radius.** For every M > 0, some initial
    radius r₀ > M still yields convergence to r = 1. (Empirically tested up
    to r₀ = 2.5; no visible basin boundary on the outer side.) -/
axiom outer_basin_unbounded :
  ∀ (M : ℝ), ∃ (r₀ : ℝ), M < r₀ ∧
    -- "trajectory starting at r₀ converges exponentially to r = 1"
    True
    -- TODO(AXLE): tie this to the dm³ flow formalisation.

-- ---------------------------------------------------------------------------
-- 4.  Gronwall-type outer-basin bound  (AXLE obligation (a))
-- ---------------------------------------------------------------------------

/-- **Outer-basin exponential contraction (Gronwall form).**

    If the transverse-perturbation rate `μ_max + 3ε` is at most `-μ_bound`
    with `μ_bound > 0`, then `exp((μ_max + 3ε)·t) ≤ exp(-μ_bound·t)` for all
    `t ≥ 0`. Take `C = 1`.

    This corrects the previous version, whose hypothesis `μ_max + 3ε < 0`
    was insufficient: for negative but larger-than-`-ε₀` rates, the bound
    fails as `t → ∞`. The corrected hypothesis is tight. -/
theorem gronwall_outer
    (μ_max ε μ_bound : ℝ) (hμ_bound : 0 < μ_bound)
    (hμ : μ_max + 3 * ε ≤ -μ_bound) :
    ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ, 0 ≤ t →
      Real.exp ((μ_max + 3 * ε) * t) ≤ C * Real.exp (-μ_bound * t) := by
  refine ⟨1, one_pos, ?_⟩
  intro t ht
  rw [one_mul]
  apply Real.exp_le_exp.mpr
  have : (μ_max + 3 * ε) * t ≤ -μ_bound * t := by
    have := mul_le_mul_of_nonneg_right hμ ht
    simpa using this
  exact this

/-- **Linearised dm³ rate specialises to μ = -2.**
    Taking `μ_max = -2`, `ε = 0`, `μ_bound = 2` recovers the asymptotic
    decay rate observed in the overview plot (slope = -2 on log|r(t) - 1|). -/
example : ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ, 0 ≤ t →
    Real.exp ((-2 + 3 * 0) * t) ≤ C * Real.exp (-2 * t) :=
  gronwall_outer (-2) 0 2 (by norm_num) (by norm_num)

-- ---------------------------------------------------------------------------
-- 5.  Spiral return / Theorem T1
-- ---------------------------------------------------------------------------

/-- A spiral return datum: the seed x₀, the g⁶⁴-iterate x₆₄, and the return
    point x₀' after one full circuit. Note that `not_fixed` has been moved
    out of this structure (compared to the previous version) and into the
    theorem hypothesis, since for strictly contracting chains starting at
    the fixed point the old version was vacuously false. -/
structure SpiralReturn (X : Type*) [MetricSpace X] [SeminormedAddCommGroup X]
    (G : GChain X) where
  x₀  : X
  x64 : X
  x₀' : X
  /-- x₆₄ = G^{64}(x₀). -/
  iter_eq  : x64 = GChain.iter G 64 x₀
  /-- x₀' = G^{64}(x₆₄) (second circuit). -/
  return_eq : x₀' = GChain.iter G 64 x64

/-- **Theorem T1 (Spiral Return).** For any GChain for which there exists
    a seed outside the immediate contracting neighbourhood of an attractor
    (witnessed by `h_nontrivial`), a SpiralReturn datum with a non-trivial
    circuit exists.

    The previous formulation `∀ G, ∃ _, True` was too strong — it was false
    for chains whose unique fixed point was chosen as `x₀`. -/
theorem spiral_return_exists
    {X : Type*} [MetricSpace X] [SeminormedAddCommGroup X]
    (G : GChain X)
    (x₀ : X)
    (h_nontrivial : GChain.iter G 64 x₀ ≠ x₀) :
    ∃ sr : SpiralReturn X G, sr.x₀' ≠ sr.x₀ := by
  -- Proof strategy: let x₆₄ = G^{64}(x₀), x₀' = G^{64}(x₆₄) = G^{128}(x₀).
  -- By h_nontrivial and a suitable injectivity / expansion property of G,
  -- x₀' ≠ x₀. Formalising the second step requires the full dynamics of G;
  -- left as sorry pending AXLE integration.
  sorry

-- ---------------------------------------------------------------------------
-- 6.  Poincaré-Collatz conjecture (AXLE obligation (d))
-- ---------------------------------------------------------------------------

/-- **Eventual entry into the g³³ stability window.**
    Reformulated as an "eventually Cauchy with tolerance `r_star` on the
    outer side": every G-orbit has consecutive iterates within `r_star`
    of each other after at least `cycles(g33) = 33` steps.

    The previous version used `ε₀ = 1/3`; we now use `r_star` (the
    asymmetric inner-basin boundary) as the natural tolerance. -/
theorem poincare_collatz
    {X : Type*} [MetricSpace X] [SeminormedAddCommGroup X]
    (G : GChain X) (x : X) :
    ∃ n : ℕ, n ≥ GSeries.cycles .g33 ∧
      dist (GChain.iter G n x) (GChain.iter G (n + 1) x) < r_star := by
  sorry

end GCTC
