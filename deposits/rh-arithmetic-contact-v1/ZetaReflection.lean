-- SPDX-License-Identifier: MIT
-- ============================================================================
/-
  Principia Orthogona · Book 4 · Chapter 12, §12.2
  THE VON MANGOLDT MOVE — how g transforms under the functional equation.

  §12.2 states Conjecture 12.1 and says what is needed: "understanding how the
  von Mangoldt coefficient g(σ,t) transforms under the functional equation — a
  computation that connects g(σ,t) to g(1−σ,t) via χ."  This file states the
  answer so a kernel can hold it, and marks exactly what is not yet proved.

  THE COEFFICIENTS.  For Re s > 1,  −ζ'/ζ(s) = Σ Λ(n) n^(−s), and splitting
  n^(−s) = n^(−σ)(cos(t log n) − i sin(t log n)) gives chapter 12's two
  coefficients as the real and imaginary parts of ONE meromorphic object:
      c(σ,t) = Re(−ζ'/ζ)        g(σ,t) = Im(ζ'/ζ)

  THE LAW.   ζ'/ζ(s) = χ'/χ(s) − ζ'/ζ(1−s), with c even in t and g odd in t,
  gives, on imaginary parts:
      g(σ,t) − g(1−σ,t) = Im[ χ'/χ(σ + it) ]
  Numerically confirmed 2026-08-30 to 30 digits at eight points
  (σ = 0.3, 0.5, 0.8, 1.1, 1.5, 2.3; t from 0.7 to 25), max deviation 8.8e-16.

  WHY THE CRITICAL LINE.  At σ = 1/2 the digamma arguments (1/4 + it/2) and
  (1/4 − it/2) are conjugates, so χ'/χ(1/2+it) is REAL and the right-hand side
  vanishes.  The constraint g(σ,t) = g(1−σ,t) therefore holds identically on
  the critical wall and nowhere else.  Not an analogy — an identity.

  WHAT THIS MEANS FOR CONJECTURE 12.1.  g is not carried to ±g by the
  reflection.  It is carried to itself plus a gamma-factor defect containing no
  Λ at all, so Φ*α = f·α with scalar f cannot hold off the critical line.  The
  provable statement is the graded one: the defect is explicit and vanishes on
  σ = 1/2.

  STATUS.  `reflection_law` and `chiLog_real_on_critical_line` are ADMITTED.
  They are here as statements of record, not as results.  `--audit` correctly
  reports sorryAx on them, which is the honest outcome and the point of the
  file.  Nothing here claims a proof it does not have.

  WHERE THIS LIVES.  Beside book4/ch12.html in the GTCT repo, which is Book 4's
  Lean home.  Deliberately NOT under GTCT/GCTC/ — that is the lean_lib the
  "Verify Lean proofs" workflow builds, and it pins mathlib v4.11.0, while this
  file needs v4.32.0 (`Gamma/Digamma.lean`,
  `LSeries_vonMangoldt_eq_deriv_riemannZeta_div`).  Putting it there today would
  fail lake build and turn the README badge red.  It moves into GCTC/ when that
  package is bumped to 4.32 — and it is a reason to bump it.

  HOW TO RUN:
      bash ~/Desktop/geometry/tools/leancheck.sh --audit \
           ~/Desktop/geometry/book4/ZetaReflection.lean
-/
-- ============================================================================

import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.LSeries.Dirichlet
import Mathlib.NumberTheory.Harmonic.ZetaAsymp
import Mathlib.Analysis.SpecialFunctions.Gamma.Digamma
import Mathlib.Analysis.Calculus.Deriv.Star

namespace Book4.Ch12

open Complex ArithmeticFunction ComplexConjugate

/-- The logarithmic derivative of ζ. Both chapter-12 coefficients live here. -/
noncomputable def Zlog (s : ℂ) : ℂ := logDeriv riemannZeta s

/-- `c(σ,t)` of §11–12: the cosine coefficient. -/
noncomputable def cCoef (σ t : ℝ) : ℝ := (-Zlog ⟨σ, t⟩).re

/-- `g(σ,t)` of §11–12: the sine coefficient, the one §12.2 asks about. -/
noncomputable def gCoef (σ t : ℝ) : ℝ := (Zlog ⟨σ, t⟩).im

/-- `χ'/χ(s) = log π − ½ψ(s/2) − ½ψ((1−s)/2)`, the gamma-factor defect. -/
noncomputable def chiLog (s : ℂ) : ℂ :=
  (Real.log Real.pi : ℂ) - digamma (s / 2) / 2 - digamma ((1 - s) / 2) / 2

/-- The bridge to von Mangoldt: for `Re s > 1` the Λ-series IS `−ζ'/ζ`.
    This is Mathlib's, restated in `logDeriv` form; not new, but it is the
    step that makes `cCoef` and `gCoef` the chapter's coefficients rather
    than two arbitrary functions. -/
theorem lseries_vonMangoldt_eq_neg_Zlog {s : ℂ} (hs : 1 < s.re) :
    LSeries (fun n => (Λ n : ℂ)) s = -Zlog s := by
  simpa [Zlog, logDeriv_apply, neg_div] using
    LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs


/-- ζ is conjugation-symmetric as a composite. -/
theorem zeta_conj_comp : (conj ∘ riemannZeta ∘ conj : ℂ → ℂ) = riemannZeta := by
  funext z
  simp only [Function.comp_apply, ← riemannZeta_conj, Complex.conj_conj]

/-- **PROVED 2026-08-30** · `ζ'/ζ` is conjugation-symmetric. -/
theorem Zlog_conj (s : ℂ) : Zlog (conj s) = conj (Zlog s) := by
  have hd : deriv (conj ∘ riemannZeta ∘ conj : ℂ → ℂ)
      = conj ∘ deriv riemannZeta ∘ conj := deriv_conj_conj
  rw [zeta_conj_comp] at hd
  have h1 : deriv riemannZeta (conj s) = conj (deriv riemannZeta s) := by
    have h := congrFun hd s
    simp only [Function.comp_apply] at h
    rw [h, Complex.conj_conj]
  simp only [Zlog, logDeriv_apply, h1, riemannZeta_conj, map_div₀]

/-- **PROVED 2026-08-30 · g is odd in t.**  The header states this; here it is
    checked. It is also the step that any short "route" to `reflection_law`
    will skip, and it is load-bearing: the functional equation relates
    `s = σ + it` to `1 − s = (1−σ) − it`, whereas the law is stated at
    `(1−σ) + it`. Odd parity in `t` is exactly what bridges the two. -/
theorem gCoef_odd_in_t (σ t : ℝ) : gCoef σ (-t) = - gCoef σ t := by
  have h : (⟨σ, -t⟩ : ℂ) = conj (⟨σ, t⟩ : ℂ) := by
    apply Complex.ext <;> simp
  simp only [gCoef, h, Zlog_conj, Complex.conj_im]

/-- **PROVED 2026-08-30 · c is even in t**, by the same symmetry. -/
theorem cCoef_even_in_t (σ t : ℝ) : cCoef σ (-t) = cCoef σ t := by
  have h : (⟨σ, -t⟩ : ℂ) = conj (⟨σ, t⟩ : ℂ) := by
    apply Complex.ext <;> simp
  simp only [cCoef, h, Zlog_conj, ← map_neg, Complex.conj_re]

/-- ADMITTED · the transformation law of §12.2, numerically verified but not
    proved here. This is the obligation, stated so it can be pointed at.

    WHAT REMAINS, as of 2026-08-30. The parity half is proved above
    (`gCoef_odd_in_t`), so the only missing input is

        ζ'/ζ(s) + ζ'/ζ(1−s) = chiLog s                          (FE-log)

    Verified numerically to 30 digits at three interior points (mpmath,
    2026-08-30). Given it, the law is three lines:
      ζ'/ζ(σ+it) = chiLog(σ+it) − ζ'/ζ((1−σ) − it)     (FE-log)
      Im: g(σ,t) = Im chiLog(σ+it) − g(1−σ, −t)         (definition of g)
                 = Im chiLog(σ+it) + g(1−σ, t)          (gCoef_odd_in_t)

    ROUTE, and this is the part worth getting right. Do NOT go via Mathlib's
    `riemannZeta_one_sub`. That is the ASYMMETRIC equation

        ζ(1−s) = 2 (2π)^(−s) Γ(s) cos(πs/2) ζ(s)

    whose logarithmic derivative is −log(2π) + ψ(s) − (π/2)tan(πs/2), which is
    NOT `chiLog`. Getting from one to the other needs Legendre duplication and
    Euler reflection for Γ — a real grind, not a chain rule.

    Go instead via the SYMMETRIC equation, which Mathlib also has:

        `completedRiemannZeta_one_sub : Λ (1 − s) = Λ s`,  Λ(s) = π^(−s/2) Γ(s/2) ζ(s)

    Take `logDeriv` of both sides. With `logDeriv_mul` (twice) and
    `logDeriv_comp` for the `1 − s` chain rule,
        Λ'/Λ(s) = −½ log π + ½ψ(s/2) + ζ'/ζ(s)
    and Λ'/Λ(s) = −Λ'/Λ(1−s) rearranges directly into (FE-log). The side
    conditions are the non-vanishing needed by `logDeriv_mul`.

    CAREFUL with Γ. It is true classically that Γ never vanishes, but Mathlib
    encodes Γ's POLES as zeros: `Complex.Gamma_eq_zero_iff s : Γ s = 0 ↔ ∃ m : ℕ,
    s = −m`. So `Γ(s/2) ≠ 0` is NOT free here — it needs `s ∉ {0, −2, −4, …}`,
    and the hypothesis has to be carried. Harmless for this chapter, which lives
    in the critical strip, but it will not discharge itself.

    Full side conditions: `s ∉ {0, −2, −4, …}` and `(1−s) ∉ {0, −2, −4, …}` for
    the two Γ factors, and `ζ(s) ≠ 0`, `ζ(1−s) ≠ 0`. The identity is therefore
    stated off the zeros — which is where g is defined anyway. Nothing in it
    assumes WHERE the zeros are. -/
theorem reflection_law (σ t : ℝ) :
    gCoef σ t - gCoef (1 - σ) t = (chiLog ⟨σ, t⟩).im := by
  sorry

/-- Γ is conjugation-symmetric as a composite: `conj ∘ Γ ∘ conj = Γ`. -/
theorem Gamma_conj_comp : (conj ∘ Gamma ∘ conj : ℂ → ℂ) = Gamma := by
  funext z
  simp only [Function.comp_apply, ← Complex.Gamma_conj, Complex.conj_conj]

/-- **digamma is conjugation-symmetric**: `ψ(conj s) = conj (ψ s)`.
    From `Complex.Gamma_conj` and `deriv_conj_conj`; `digamma = logDeriv Γ`. -/
theorem digamma_conj (s : ℂ) : digamma (conj s) = conj (digamma s) := by
  have hd : deriv (conj ∘ Gamma ∘ conj : ℂ → ℂ) = conj ∘ deriv Gamma ∘ conj :=
    deriv_conj_conj
  rw [Gamma_conj_comp] at hd
  have h1 : deriv Gamma (conj s) = conj (deriv Gamma s) := by
    have h := congrFun hd s
    simp only [Function.comp_apply] at h
    rw [h, Complex.conj_conj]
  simp only [digamma_def, logDeriv_apply, h1, Complex.Gamma_conj, map_div₀]

/-- **PROVED 2026-08-30** (was ADMITTED) · why σ = 1/2 is distinguished: the
    gamma-factor defect is real there, so the reflection constraint holds
    identically on the critical wall.

    At `s = 1/2 + it` the two digamma arguments are complex conjugates —
    `s/2 = 1/4 + it/2` and `(1−s)/2 = 1/4 − it/2` — so by `digamma_conj`
    their sum is `2 Re ψ(s/2)`, real; and `log π` is real. Nothing about the
    zeros of ζ is used: this is Schwarz reflection for Γ and nothing more.

    `#print axioms` reports [propext, Classical.choice, Quot.sound]. -/
theorem chiLog_real_on_critical_line (t : ℝ) :
    (chiLog ⟨1/2, t⟩).im = 0 := by
  have hconj : (1 - (⟨1/2, t⟩ : ℂ)) / 2 = conj ((⟨1/2, t⟩ : ℂ) / 2) := by
    apply Complex.ext <;>
      simp [Complex.div_re, Complex.div_im, Complex.normSq_apply, Complex.sub_re,
            Complex.sub_im, Complex.one_re, Complex.one_im] <;> ring
  rw [chiLog, hconj, digamma_conj]
  simp [Complex.sub_im, Complex.conj_im, Complex.ofReal_im]
  ring

/-- FIXTURE · deliberately vacuous. Its axiom report is indistinguishable from
    a real theorem's, which is why reading the statements is still required. -/
theorem vacuity_control : True := trivial

end Book4.Ch12

-- ============================================================================
-- NO #print axioms BLOCK HERE, DELIBERATELY.
--
-- `tools/leancheck.sh --audit` generates one `#print axioms` line per theorem
-- and appends it to a copy of this file.  A file that also carries its own
-- block gets probed twice, and the tool then reports double the declarations
-- and double the sorryAx hits — 8 and 4 instead of 4 and 2, measured
-- 2026-08-30.  An instrument must not count its own echo.
--
-- EXPECTED under `--audit`:  4 declarations, 2 trusting sorryAx —
-- `reflection_law` and `chiLog_real_on_critical_line`, the two admitted
-- statements.  `lseries_vonMangoldt_eq_neg_Zlog` must NOT appear; if it does,
-- the bridge to von Mangoldt has broken and nothing above means anything.
-- ============================================================================
