-- SPDX-License-Identifier: MIT
-- ============================================================================
/-
  Principia Orthogona · Book 4 · Chapter 12 · DEVELOPMENT FILE

  THE LOG-DERIVATIVE FORM OF THE FUNCTIONAL EQUATION.

  Target — currently `sorry`-ed as `Zlog_add_Zlog_one_sub` in
  `book4/ZetaReflection.lean`:

      ζ'/ζ(s) + ζ'/ζ(1−s) = log π − ½ψ(s/2) − ½ψ((1−s)/2)

  This file is NOT the audited file.  It exists to be compiled and edited until
  it carries no `sorry`, at which point the proof moves into `ZetaReflection.lean`
  in place of the admitted statement and this file is retired to evidence.
  Keeping the two apart means the audited file's `#print axioms` expectation
  (12 declarations, sorryAx on the one) does not move while this is in flight.

  THE ROUTE, in four steps.  Nothing here is deep; the work is entirely in
  finding which library lemma does each step.

    Λ(s) = Gammaℝ(s)·ζ(s)          with Gammaℝ(s) = π^(−s/2)·Γ(s/2)

    [1]  logDeriv Gammaℝ s = −½·log π + ½·ψ(s/2)
         The π-power contributes a constant; the Γ contributes ψ(s/2) with a
         factor ½ from the chain rule.  `HasDerivAt.logDeriv_Gamma` does the
         second half in one line.

    [2]  logDeriv Λ s = logDeriv Gammaℝ s + logDeriv ζ s
         `logDeriv_fun_mul`, needing both factors nonzero and differentiable
         at s.  Differentiability of Gammaℝ comes from `differentiable_Gammaℝ_inv`
         by inverting, which avoids Γ's own differentiability API entirely.

    [3]  logDeriv Λ s + logDeriv Λ (1−s) = 0
         THE ONLY STEP WITH ANY CONTENT.  Λ(1−s) = Λ(s) holds as a function
         identity, so differentiating gives −Λ'(1−s) = Λ'(s); dividing by
         Λ(s) = Λ(1−s) turns that into the sum above.  The minus sign is the
         whole reflection, and it is `deriv_comp_const_sub` that supplies it.

    [4]  Substitute [1] and [2] into [3] and read off.  The two −½·log π
         contributions add to −log π, which moves to the other side as the
         +log π of the gamma-factor defect.

  WHY THE FOUR HYPOTHESES ARE EXACTLY RIGHT — worth recording, because they
  look like four and are doing the work of six.

    hΓ  : ∀ n : ℕ, s ≠ -(2 * n)        gives Gammaℝ s ≠ 0        (Gammaℝ_eq_zero_iff)
    hΓ' : ∀ n : ℕ, (1 - s) ≠ -(2 * n)  gives Gammaℝ (1-s) ≠ 0
    hζ  : riemannZeta s ≠ 0
    hζ' : riemannZeta (1 - s) ≠ 0

  At n = 0 the first gives s ≠ 0, and the second gives 1 − s ≠ 0, i.e. s ≠ 1.
  Those are precisely the two points where ζ and Λ are not differentiable, so
  the differentiability side conditions are already contained in the hypotheses
  as stated and do not have to be added.  Dropping any one of the four leaves a
  statement that either asserts an equality of junk values or divides by zero.

  ROUTE TRAPS, recorded 2026-08-30 and still binding:
    · Go via `completedRiemannZeta_one_sub` (Λ(1−s) = Λ(s)), NOT
      `riemannZeta_one_sub` — the latter is the asymmetric form carrying
      cos(πs/2), and converting it costs Legendre duplication and Euler
      reflection on top of everything below.
    · Mathlib encodes Γ's poles as ZEROS, so `Gammaℝ s ≠ 0` is not free.  That
      is what hΓ and hΓ' are for.

  STATUS OF THIS FILE — read before trusting a line of it.
  FIRST RUN 2026-09-08 under Lean v4.32.0 / Mathlib v4.32.0: two errors, both
  tactic hygiene at the end of a proof, both fixed below and noted where.  The
  mathematics went through untouched — every library lemma named in the route
  resolved, `deriv_comp_const_sub` took the arity written here, and step [3], the
  reflection and the only step with content, elaborated with no `sorry`.  Three
  `sorry`s remain and are deliberate: [1], [2], and Λ s ≠ 0.  The fixes have NOT
  yet been re-run; do that before quoting a clean compile:

      cd ~/Desktop/geometry && bash tools/leancheck.sh ~/Desktop/GTCT/book4/ZetaFELogDeriv.lean

  LIBRARY FACTS THIS LEANS ON — all confirmed present, 2026-09-08:
    Complex.Gammaℝ_def, Complex.Gammaℝ_eq_zero_iff, Complex.differentiable_Gammaℝ_inv
    Complex.digamma_def, HasDerivAt.logDeriv_Gamma
    completedRiemannZeta_one_sub, riemannZeta_def_of_ne_zero
    differentiableAt_riemannZeta, riemannZeta_ne_zero_of_one_le_re
    logDeriv_apply, logDeriv_fun_mul, logDeriv_comp, logDeriv_const
-/
-- ============================================================================

import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.SpecialFunctions.Gamma.Digamma
import Mathlib.Analysis.SpecialFunctions.Gamma.Deligne
import Mathlib.Analysis.Calculus.LogDeriv

open Complex

namespace Book4.Ch12.FE

noncomputable def Zlog (s : ℂ) : ℂ := logDeriv riemannZeta s

/-- `χ'/χ(s) = log π − ½ψ(s/2) − ½ψ((1−s)/2)`, the gamma-factor defect. -/
noncomputable def chiLog (s : ℂ) : ℂ :=
  (Real.log Real.pi : ℂ) - digamma (s / 2) / 2 - digamma ((1 - s) / 2) / 2

/-! ### Step 0 · what the hypotheses actually give -/

/-- `Gammaℝ s ≠ 0` is exactly the hypothesis, read through `Gammaℝ_eq_zero_iff`. -/
theorem Gammaℝ_ne_zero_of (s : ℂ) (hΓ : ∀ n : ℕ, s ≠ -(2 * n)) :
    Gammaℝ s ≠ 0 := by
  rw [Ne, Gammaℝ_eq_zero_iff]
  push_neg
  intro n
  exact hΓ n

/-- `s ≠ 0` falls out of `hΓ` at `n = 0`.  This is the step that makes the
    four-hypothesis statement self-sufficient: nothing further has to be assumed
    to get differentiability. -/
theorem ne_zero_of (s : ℂ) (hΓ : ∀ n : ℕ, s ≠ -(2 * n)) : s ≠ 0 := by
  simpa using hΓ 0

/-- `Gammaℝ` is differentiable wherever it is nonzero, obtained by inverting the
    entire function `1/Gammaℝ` rather than through `Γ`'s own API. -/
theorem differentiableAt_Gammaℝ (s : ℂ) (h : Gammaℝ s ≠ 0) :
    DifferentiableAt ℂ Gammaℝ s := by
  have hinv : DifferentiableAt ℂ (fun z => (Gammaℝ z)⁻¹) s :=
    differentiable_Gammaℝ_inv s
  -- `Gammaℝ = ((Gammaℝ)⁻¹)⁻¹`, and the inner function is entire.
  have h2 : DifferentiableAt ℂ (fun z => ((Gammaℝ z)⁻¹)⁻¹) s :=
    hinv.inv (inv_ne_zero h)
  -- `simpa only [inv_inv]` and not bare `simpa`: an unrestricted simp set
  -- rewrote the hypothesis into a shape that no longer matched the goal.
  simpa only [inv_inv] using h2

/-! ### Step 1 · the logarithmic derivative of the archimedean factor -/

/-- **The reusable half.**  `logDeriv Gammaℝ s = −½ log π + ½ ψ(s/2)`.

    This is the piece that is worth offering to Mathlib on its own, independently
    of anything below: it is a statement about `Gammaℝ` and `digamma` alone, both
    of which are Mathlib's, and it is what one needs any time an archimedean
    factor is differentiated. -/
theorem logDeriv_Gammaℝ (s : ℂ) (hΓ : ∀ n : ℕ, s ≠ -(2 * n)) :
    logDeriv Gammaℝ s = -(Real.log Real.pi : ℂ) / 2 + digamma (s / 2) / 2 := by
  -- Gammaℝ s = π ^ (-s/2) * Γ(s/2), so the log derivative splits.
  -- (a)  logDeriv (fun z => (π : ℂ) ^ (-z/2)) s = -log π / 2
  --      via cpow_def_of_ne_zero and logDeriv of an exponential.
  -- (b)  logDeriv (fun z => Γ (z/2)) s = (1/2) * digamma (s/2)
  --      via HasDerivAt.logDeriv_Gamma with g = (· / 2), a = 1/2.
  sorry

/-! ### Step 2 · the completed zeta splits -/

/-- Near any `s ≠ 0`, `Λ` agrees with the product `Gammaℝ · ζ`, so its log
    derivative splits.  The equality is only needed on a neighbourhood, which is
    why `s ≠ 0` suffices. -/
theorem logDeriv_completedRiemannZeta (s : ℂ)
    (hΓ : ∀ n : ℕ, s ≠ -(2 * n)) (hζ : riemannZeta s ≠ 0) (hs1 : s ≠ 1) :
    logDeriv completedRiemannZeta s = logDeriv Gammaℝ s + Zlog s := by
  -- riemannZeta_def_of_ne_zero gives ζ z = Λ z / Gammaℝ z for z ≠ 0;
  -- rearrange to Λ = Gammaℝ * ζ on a neighbourhood of s, then logDeriv_fun_mul
  -- with Gammaℝ_ne_zero_of, hζ, differentiableAt_Gammaℝ, differentiableAt_riemannZeta.
  sorry

/-! ### Step 3 · the reflection, which is the only step with content -/

/-- `Λ(1−s) = Λ(s)` differentiated.  The minus sign from `deriv_comp_const_sub`
    is the whole of the functional equation as it acts on log derivatives. -/
theorem logDeriv_completedRiemannZeta_add_one_sub (s : ℂ)
    (hΛ : completedRiemannZeta s ≠ 0) :
    logDeriv completedRiemannZeta s + logDeriv completedRiemannZeta (1 - s) = 0 := by
  have hfun : (fun z : ℂ => completedRiemannZeta (1 - z)) = completedRiemannZeta := by
    funext z; exact completedRiemannZeta_one_sub z
  have hderiv : deriv completedRiemannZeta s = -deriv completedRiemannZeta (1 - s) := by
    have h1 : deriv (fun z : ℂ => completedRiemannZeta (1 - z)) s
        = -deriv completedRiemannZeta (1 - s) := deriv_comp_const_sub _ _ _
    rw [hfun] at h1
    exact h1
  have hval : completedRiemannZeta (1 - s) = completedRiemannZeta s :=
    completedRiemannZeta_one_sub s
  -- After the rewrites the goal is `(-a) / c + a / c = 0` with `a = deriv Λ (1-s)`
  -- and `c = Λ s`.  `field_simp` left that unsolved; collecting the numerators
  -- first turns it into `(-a + a) / c = 0`, which `simp` closes without needing
  -- `c ≠ 0` at all.
  simp only [logDeriv_apply]
  rw [hderiv, hval, div_add_div_same]
  simp

/-! ### Step 4 · assembly -/

/-- **The target.**  Off the zeros of `ζ` and the poles of the two `Γ` factors,
    the logarithmic derivative and its reflection sum to the gamma-factor
    defect. -/
theorem Zlog_add_Zlog_one_sub (s : ℂ)
    (hΓ  : ∀ n : ℕ, s ≠ -(2 * n))
    (hΓ' : ∀ n : ℕ, (1 - s) ≠ -(2 * n))
    (hζ  : riemannZeta s ≠ 0)
    (hζ' : riemannZeta (1 - s) ≠ 0) :
    Zlog s + Zlog (1 - s) = chiLog s := by
  -- s ≠ 0 from hΓ at n = 0; s ≠ 1 from hΓ' at n = 0.
  have hs0 : s ≠ 0 := ne_zero_of s hΓ
  have h1s0 : (1 - s) ≠ 0 := ne_zero_of (1 - s) hΓ'
  have hs1 : s ≠ 1 := fun h => h1s0 (by simp [h])
  have h1s1 : (1 - s) ≠ 1 := fun h => hs0 (by linear_combination -h)
  -- Λ s ≠ 0, from the product form.
  have hΛ : completedRiemannZeta s ≠ 0 := by
    sorry
  -- the three steps
  have key := logDeriv_completedRiemannZeta_add_one_sub s hΛ
  rw [logDeriv_completedRiemannZeta s hΓ hζ hs1,
      logDeriv_completedRiemannZeta (1 - s) hΓ' hζ' h1s1,
      logDeriv_Gammaℝ s hΓ, logDeriv_Gammaℝ (1 - s) hΓ'] at key
  -- key : (-logπ/2 + ψ(s/2)/2 + Zlog s) + (-logπ/2 + ψ((1-s)/2)/2 + Zlog (1-s)) = 0
  rw [chiLog]
  linear_combination key

end Book4.Ch12.FE
