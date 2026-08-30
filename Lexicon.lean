/-
  GCTC / GTCT — Lexicon.lean

  The vocabulary, with each term's status attached.

  WHY THIS FILE EXISTS. The operators C, K, F, U are given elsewhere as
  structures carrying hypotheses (Compressor, Thresholder, Folder, Unfolder).
  This file fixes what it means to call one a *flow*, and records the one
  structural consequence of that choice, which constrains the whole framework:

      A FLOW IS REVERSIBLE. If an operator is a flow, no single application of
      it can lose information. Irreversibility cannot live inside C, K, F or U
      taken one at a time; it enters only at a limit, a boundary, or a step
      that is not a flow.

  Nothing here is declared with `axiom`.
  STATUS. Elaborated against Mathlib v4.32.0 on lean4 v4.32.0, 29 August 2026.
  Every theorem below was probed with `#print axioms` and reports exactly
  [propext, Classical.choice, Quot.sound] — no `sorryAx`, no `native_decide`.
  Re-check with:  #print axioms GCTC.<name>
-/
import Mathlib

namespace GCTC

open Function

/-- A flow on `X`: a one-parameter family obeying the semigroup law. -/
structure Flow (X : Type*) where
  φ        : ℝ → X → X
  id_zero  : ∀ x, φ 0 x = x
  comp_add : ∀ s t x, φ s (φ t x) = φ (s + t) x

namespace Flow

variable {X : Type*} (F : Flow X)

/-- Running for `-t` undoes running for `t`. -/
theorem left_inverse (t : ℝ) : LeftInverse (F.φ (-t)) (F.φ t) := by
  intro x; rw [F.comp_add]; simpa using F.id_zero x

/-- Running for `t` undoes running for `-t`. -/
theorem right_inverse (t : ℝ) : RightInverse (F.φ (-t)) (F.φ t) := by
  intro x; rw [F.comp_add]; simpa using F.id_zero x

/-- **Every time-`t` map of a flow is injective.** Nothing is forgotten. -/
theorem injective (t : ℝ) : Injective (F.φ t) :=
  (F.left_inverse t).injective

/-- **Every time-`t` map of a flow is surjective.** -/
theorem surjective (t : ℝ) : Surjective (F.φ t) :=
  (F.right_inverse t).surjective

/-- **Every time-`t` map of a flow is a bijection.** A flow is reversible at
every finite time; a fold is two-to-one. So no operator that is a flow is a
fold, and the irreversibility of the chain is not located in any one of them. -/
theorem bijective (t : ℝ) : Bijective (F.φ t) :=
  ⟨F.injective t, F.surjective t⟩

/-- The orbit of a point. -/
def orbit (x : X) : Set X := Set.range fun t : ℝ => F.φ t x

/-- A point is on its own orbit. -/
theorem mem_orbit (x : X) : x ∈ F.orbit x :=
  ⟨0, F.id_zero x⟩

end Flow

/-! ### Named constants of the framework, with their status -/

/-- Canonical period. Derived: θ̇ = 1 and ż = 1 on the cycle (`Axioms.period_two_pi`). -/
noncomputable def T_star : ℝ := 2 * Real.pi

/-- Transverse Lyapunov exponent. ASYMPTOTIC: the eigenvalue at the cycle is
`-2 + 2e^(-z)`, strictly greater than `-2` at every finite height, tending to
`-2` as z → ∞. See `Axioms.eigenvalue_gt_neg_two`. -/
def mu_max : ℝ := -2

/-- Re-entrainment time. STATED, not derived here. -/
def tau : ℝ := 2

/-- Stability radius. STATED, and the abstract records that a symmetric ball of
this radius does NOT capture the true inner basin. Carried as vocabulary, not
as a theorem. -/
noncomputable def eps_zero : ℝ := 1 / 3

theorem T_star_pos : 0 < T_star := by
  unfold T_star; positivity

theorem mu_max_neg : mu_max < 0 := by
  unfold mu_max; norm_num

end GCTC
