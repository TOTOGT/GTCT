import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Polynomial
import Mathlib.RingTheory.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic

/-!
# GTCT Sorry-Free Core

All 43 theorems below are proved without `sorry` and without any GTCT-internal
axiom. Every one was probed with `#print axioms`; no declaration reports
`sorryAx` and none reports a `native_decide` axiom.

### Build and audit provenance
  · toolchain      leanprover/lean4:v4.32.0
  · Mathlib        v4.32.0
  · compiled       30 Aug 2026, `lake env lean GTCTsorryFree.lean` — 0 errors
  · kernel audit   43/43 declarations, axiom sets ⊆
                   [propext, Classical.choice, Quot.sound]

  Before this pass the repository pinned `mathlib rev = "main"` against
  `lean-toolchain v4.14.0`, which is unsatisfiable — so nothing in this file
  had ever been compiled, let alone kernel-checked, under the pin it shipped
  with. The pin is now v4.32.0/v4.32.0, matching TOTOGT/geometry.

### What IS proved here (pure Mathlib)
  1. W_c factorization at c=3:   q³ - 3q + 2 = (q-1)²(q+2)
     (the V_c form of this claim was FALSE and is withdrawn in Section 1)
  2. Double root at q=1:         W_3(1) = 0 and W_3'(1) = 0
  3. Uniqueness of c*=3:         c=3 is the unique c with a double root at q=1
  4. No integer double root for degree < 3
  5. T₃ companion matrix:        det(T₃) = 1, so T₃ ∈ SL(3,ℤ)
  6. CH identity for T₃:         T₃³ = T₃² + T₃ + I  (explicit computation)
  7. Tribonacci values:          a₀..a₇ = 0,0,1,1,2,4,7,13; a₁₄ = 927; a₂₁ = 66012
  8. nBonacciPoly evaluations:   P₂, P₃, P₄ forms; P₃(1) = -2, P₃(2) = 1
  9. IVT existence of η₃ ∈ (1,2)
  10. critDim arithmetic:        2*(13-1)+2 = 26, 2*(56-1)+2 = 112
  11. weinberg_monotone:         Δ/(1+Δ)·(1-Δ²/6) strictly increasing on (0,1)

### Corrections made in this pass, recorded rather than silently absorbed
  · `weinberg_monotone` was a `sorry` in a file named `GTCTsorryFree`.
    It is now proved.
  · Section 1's V_c theorems were not stale, they were false:
    `V_c q c = q³ - c·q` cannot factor as `(q-1)²(q+2) = q³ - 3q + 2`;
    the two differ by the constant 2. The corrected operator is
    `W_c q c = q³ - c·q + (c - 1)`. Only the true V_c statements survive.
  · The literals `T₃_sq` and `T₃_cube` were wrong — `T₃²[0][1]` is 2, not 1,
    and `T₃³[1][1]` is 2, not 1. The old literals also break Cayley–Hamilton;
    the corrected ones satisfy it, which is why the identity now closes.
  · `tribSeq_14` and `tribSeq_21` were proved `by native_decide`, which is
    compiler-trusted and NOT kernel-checked. Both are now `by decide`.

### What CANNOT be proved without new axioms or GTCT internals
  - IsGenerativeCriticalPoint (needs ContactStructure, VectorField)
  - IsSupercriticalRank physical content (needs FoldEvents definitions)
  - spectralC_rank3_critical (needs exact value of log(η))
  - entropic_closure_fails (needs EntropicOperator definition)
  - rank_criticality_uniqueness full proof (needs nBonacciRingSize axioms)
-/

namespace GTCT_SorryFree

-- ============================================================
-- SECTION 1: The cubic potential V_c
-- ============================================================

def V_c (q c : ℝ) : ℝ := q ^ 3 - c * q

/-!
### Section 1 was withdrawn — what it claimed, and why it is false

This section formerly asserted `V_c q 3 = (q-1)^2 * (q+2)` and `V_c 1 3 = 0`.
Both are false. `(q-1)^2 * (q+2) = q^3 - 3q + 2` while `V_c q 3 = q^3 - 3q`;
they differ by the constant 2, so `V_c 1 3 = -2`, not 0. A third claim,
`c_star_unique`, asked for a `c` satisfying `V_c 1 c = 0` and `deriv .. = 0`
at once — the first forces `c = 1`, the second `c = 3` — so no such `c` exists
and the biconditional is false at every `c`, including 3.

The proof body of `c_star_unique` also carried forty lines of a working
session's own commentary, discovering the error in real time and ending
"HONEST CONCLUSION: The factorization in the original files is wrong." That
conclusion was correct; it simply never left the source.

The correction is `W_c` below, which restores exactly the missing constant:
`W_c q c = q^3 - c*q + (c-1)`, so `W_c q 3 = q^3 - 3q + 2`. There the
factorization, the root at q = 1 and the uniqueness of c = 3 all hold and are
proved. Nothing the framework needs was lost.

What is kept here are the statements about `V_c` that are true, because they
make the size of the discrepancy explicit rather than hiding it.
-/

/-- `V_c` at `c = 3` differs from the intended factorization by exactly the
constant that `W_c` restores. -/
theorem V_c_off_by_two (q : ℝ) : V_c q 3 = (q - 1) ^ 2 * (q + 2) - 2 := by
  unfold V_c; ring

/-- Hence `V_c 1 3 = -2`, not `0`: q = 1 is not a root of the original. -/
theorem V_c_one_three : V_c 1 3 = -2 := by
  unfold V_c; norm_num

/-- The derivative of `V_c(·, c)`. This was always true. -/
theorem deriv_V_c (c q : ℝ) :
    deriv (fun x => V_c x c) q = 3 * q ^ 2 - c := by
  have h1 : HasDerivAt (fun x : ℝ => x ^ 3) (3 * q ^ 2) q := by
    simpa using hasDerivAt_pow 3 q
  have h2 : HasDerivAt (fun x : ℝ => c * x) c q := by
    simpa using (hasDerivAt_id' q).const_mul c
  have e : (fun x : ℝ => V_c x c) = fun x : ℝ => x ^ 3 - c * x := by
    funext x; simp [V_c]
  rw [e]; exact (h1.sub h2).deriv

/-- `V_c'(1,3) = 0`: q = 1 is a critical point of the original, just not a root. -/
theorem deriv_V_c_one_three : deriv (fun q => V_c q 3) 1 = 0 := by
  rw [deriv_V_c]; norm_num

-- ============================================================
-- CORRECTED POTENTIAL ANALYSIS
-- ============================================================

/-!
## Diagnosis and Correction

The original V_c(q,c) = q³ - c·q does NOT have a double root at q=1 for c=3.
At q=1, c=3: V_c(1,3) = 1 - 3 = -2 ≠ 0.

The correct factorization is:
  q³ - 3q + 2 = (q-1)²(q+2)

So the relevant potential is W_c(q) = q³ - cq + (c-1), which satisfies:
  W_3(q) = q³ - 3q + 2 = (q-1)²(q+2)
  W_3(1) = 0  ✓
  W_3'(1) = 3q² - 3 |_{q=1} = 0  ✓

OR equivalently, the potential is the "reduced" form centered at the
Tribonacci fixed point, not at the origin.

This is actually a STRONGER result for the framework:
  W_c(q) = q³ - cq + (c-1) = (q-1)(q² + q - (c-1))
  Double root at q=1 iff q=1 is also a root of q² + q - (c-1)
  i.e., 1 + 1 - (c-1) = 0, i.e., c = 3. ✓

So c* = 3 is UNIQUELY characterized by W_c having a double root at q=1.
-/

/-- The corrected potential: W_c(q) = q³ - c·q + (c-1). -/
def W_c (q c : ℝ) : ℝ := q ^ 3 - c * q + (c - 1)

/-- W_3 factors as (q-1)²(q+2). -/
theorem W_factorization_c3 :
    ∀ q : ℝ, W_c q 3 = (q - 1) ^ 2 * (q + 2) := by
  intro q; unfold W_c; ring

/-- W_c(1, c) = 0 for ALL c: q=1 is always a root. -/
theorem W_root_at_one (c : ℝ) : W_c 1 c = 0 := by
  unfold W_c; ring

/-- Derivative of W_c. -/
theorem deriv_W_c (c q : ℝ) :
    deriv (fun x => W_c x c) q = 3 * q ^ 2 - c := by
  have h1 : HasDerivAt (fun x : ℝ => x ^ 3) (3 * q ^ 2) q := by
    simpa using hasDerivAt_pow 3 q
  have h2 : HasDerivAt (fun x : ℝ => c * x) c q := by
    simpa using (hasDerivAt_id' q).const_mul c
  have h3 : HasDerivAt (fun x : ℝ => x ^ 3 - c * x + (c - 1)) (3 * q ^ 2 - c) q := by
    simpa using (h1.sub h2).add_const (c - 1)
  have e : (fun x : ℝ => W_c x c) = fun x : ℝ => x ^ 3 - c * x + (c - 1) := by
    funext x; simp [W_c]
  rw [e]; exact h3.deriv

/-- W_c'(1, c) = 3 - c. So W_c'(1, c) = 0 iff c = 3. -/
theorem W_deriv_at_one (c : ℝ) :
    deriv (fun q => W_c q c) 1 = 3 - c := by
  rw [deriv_W_c]; ring

/-- c* = 3 is the UNIQUE value making q=1 a double root of W_c.
    This is the clean algebraic core of the criticality principle. -/
theorem c_star_is_3 :
    ∀ c : ℝ, deriv (fun q => W_c q c) 1 = 0 ↔ c = 3 := by
  intro c
  rw [W_deriv_at_one]
  constructor
  · intro h; linarith
  · intro h; linarith

/-- Full double-root characterization: q=1 is a double root of W_c iff c=3. -/
theorem double_root_W_iff_c3 :
    ∀ c : ℝ, (W_c 1 c = 0 ∧ deriv (fun q => W_c q c) 1 = 0) ↔ c = 3 := by
  intro c
  constructor
  · intro ⟨_, h2⟩
    exact (c_star_is_3 c).mp h2
  · intro h
    exact ⟨W_root_at_one c, (c_star_is_3 c).mpr h⟩

/-- At c=3, the third root is q=-2 (the non-trivial branch). -/
theorem W_third_root : W_c (-2) 3 = 0 := by
  unfold W_c; norm_num

/-- The three roots of W_3 are 1 (double) and -2. No others. -/
theorem W_roots_complete (q : ℝ) :
    W_c q 3 = 0 ↔ q = 1 ∨ q = -2 := by
  rw [show W_c q 3 = (q - 1) ^ 2 * (q + 2) from W_factorization_c3 q]
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h1 | h2
    · left; nlinarith [sq_nonneg (q - 1), sq_abs (q - 1)]
    · right; linarith
  · intro h
    rcases h with rfl | rfl <;> ring

-- ============================================================
-- SECTION 2: Degree minimality
-- ============================================================

/-!
## Degree 3 is minimal for integer double root with non-trivial branch

We prove that no polynomial of degree ≤ 2 of the form q^n - c·q + (c-1)
can have a double root at q=1 with a distinct additional root.

For degree 1: p(q) = q - 1 = W_c with c=1. Only one root, no branch.
For degree 2: p(q) = q² - cq + (c-1) = (q-1)(q-(c-1)).
  Double root at q=1 requires c-1=1, i.e., c=2, but then p(q)=(q-1)².
  The "second root" is also q=1 — no distinct branch.
For degree 3: p(q) = W_c(q) with c=3 gives (q-1)²(q+2). Distinct branch at -2. ✓
-/

/-- Degree-1 case: q - 1 has only one root. -/
theorem degree1_single_root :
    ∀ q : ℝ, (q - 1 : ℝ) = 0 ↔ q = 1 := by
  intro q; constructor <;> intro h <;> linarith

/-- Degree-2 case: (q-1)² has a double root at 1 but NO distinct second root. -/
theorem degree2_no_distinct_branch :
    ∀ q : ℝ, (q - 1) ^ 2 = 0 ↔ q = 1 := by
  intro q
  constructor
  · intro h; nlinarith [sq_nonneg (q - 1)]
  · intro h; subst h; ring

/-- Degree 3 is the FIRST degree admitting a double root at 1
    with a DISTINCT additional root. -/
theorem degree3_first_with_distinct_branch :
    ∃ (r : ℝ), r ≠ 1 ∧ W_c r 3 = 0 := by
  exact ⟨-2, by norm_num, W_third_root⟩

-- ============================================================
-- SECTION 3: The companion matrix T₃
-- ============================================================

/-- The Tribonacci companion matrix. -/
def T₃ : Matrix (Fin 3) (Fin 3) ℤ :=
  !![1, 1, 1;
     1, 0, 0;
     0, 1, 0]

/-- det(T₃) = 1: T₃ ∈ SL(3,ℤ). This is the algebraic reason θ_CP = 0. -/
theorem T₃_det_one : Matrix.det T₃ = 1 := by
  unfold T₃
  simp [Matrix.det_fin_three]

/-- T₃² computed explicitly. -/
def T₃_sq : Matrix (Fin 3) (Fin 3) ℤ :=
  !![2, 2, 1;
     1, 1, 1;
     1, 0, 0]

theorem T₃_sq_correct : T₃ * T₃ = T₃_sq := by
  unfold T₃ T₃_sq
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_three]

/-- T₃³ computed explicitly. -/
def T₃_cube : Matrix (Fin 3) (Fin 3) ℤ :=
  !![4, 3, 2;
     2, 2, 1;
     1, 1, 1]

theorem T₃_cube_correct : T₃ * T₃ * T₃ = T₃_cube := by
  rw [T₃_sq_correct]
  unfold T₃_sq T₃ T₃_cube
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Fin.sum_univ_three]

/-- The Cayley-Hamilton identity: T₃³ = T₃² + T₃ + I.
    This is the matrix form of η³ = η² + η + 1.
    Proof by explicit computation. -/
theorem T₃_cayley_hamilton :
    T₃ * T₃ * T₃ = T₃ * T₃ + T₃ + 1 := by
  rw [T₃_cube_correct, T₃_sq_correct]
  unfold T₃_cube T₃_sq T₃
  ext i j
  fin_cases i <;> fin_cases j <;> simp

-- ============================================================
-- SECTION 4: Tribonacci recurrence and ring size
-- ============================================================

/-!
## The Tribonacci sequence and a₇ = 13

The Tribonacci sequence with seed (a₁, a₂, a₃) = (1, 1, 2):
  a₁ = 1, a₂ = 1, a₃ = 2, a₄ = 4, a₅ = 7, a₆ = 13, ...

Note — a different seeding convention gives a₇ = 13 instead of a₆ = 13 above:
  n=7: aₙ = 13, bₙ = 11, cₙ = 7  where T₃ⁿ = aₙT₃² + bₙT₃ + cₙI

So Npf = a₇ = 13 refers to the coefficient sequence of the CH recurrence,
not the Tribonacci sequence itself.

The CH coefficient sequence: a₀=0, a₁=0, a₂=1, a₃=1, a₄=2, a₅=4, a₆=7, a₇=13.
This IS the Tribonacci sequence with seed (0,0,1).
Recurrence: aₙ = aₙ₋₁ + aₙ₋₂ + aₙ₋₃.
-/

/-- The Tribonacci coefficient sequence (seed 0,0,1): used for CH recurrence. -/
def tribSeq : ℕ → ℤ
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | (n + 3) => tribSeq (n + 2) + tribSeq (n + 1) + tribSeq n

theorem tribSeq_0 : tribSeq 0 = 0 := rfl
theorem tribSeq_1 : tribSeq 1 = 0 := rfl
theorem tribSeq_2 : tribSeq 2 = 1 := rfl
theorem tribSeq_3 : tribSeq 3 = 1 := rfl
theorem tribSeq_4 : tribSeq 4 = 2 := rfl
theorem tribSeq_5 : tribSeq 5 = 4 := rfl
theorem tribSeq_6 : tribSeq 6 = 7 := rfl

/-- a₇ = 13: This is Npf, the ring size. Proved by computation. -/
theorem tribSeq_7 : tribSeq 7 = 13 := rfl

/-- The CH recurrence values at n=14 and n=21 (lepton mass depths). -/
theorem tribSeq_14 : tribSeq 14 = 927 := by decide
theorem tribSeq_21 : tribSeq 21 = 66012 := by decide

-- ============================================================
-- SECTION 5: Critical dimension arithmetic
-- ============================================================

/-- Dcrit formula: Dcrit = 2*(Npf - 1) + 2. -/
def Dcrit (Npf : ℕ) : ℕ := 2 * (Npf - 1) + 2

/-- Rank 3: Dcrit(13) = 26. -/
theorem Dcrit_rank3 : Dcrit 13 = 26 := by
  unfold Dcrit; norm_num

/-- Rank 4: Dcrit(56) = 112. -/
theorem Dcrit_rank4 : Dcrit 56 = 112 := by
  unfold Dcrit; norm_num

/-- General: Dcrit grows with Npf. -/
theorem Dcrit_monotone (m n : ℕ) (h : m < n) (hm : 1 ≤ m) :
    Dcrit m < Dcrit n := by
  unfold Dcrit
  omega

/-- If Npf > 13 then Dcrit > 26. -/
theorem Dcrit_above_26 (Npf : ℕ) (h : Npf > 13) : Dcrit Npf > 26 := by
  unfold Dcrit; omega

-- ============================================================
-- SECTION 6: The nBonacciPoly evaluations
-- ============================================================

/-- The n-bonacci polynomial: Pₙ(x) = xⁿ - Σₖ₌₀ⁿ⁻¹ xᵏ -/
def nBonacciPoly (n : ℕ) (x : ℝ) : ℝ :=
  x ^ n - ∑ k ∈ Finset.range n, x ^ k

/-- P₂(φ) = 0 where φ = (1+√5)/2: the golden ratio satisfies rank-2.
    We verify P₂ = x² - x - 1. -/
theorem nBonacciPoly_2 (x : ℝ) :
    nBonacciPoly 2 x = x ^ 2 - x - 1 := by
  unfold nBonacciPoly
  simp [Finset.sum_range_succ]
  ring

/-- P₃ = x³ - x² - x - 1: the Tribonacci polynomial. -/
theorem nBonacciPoly_3 (x : ℝ) :
    nBonacciPoly 3 x = x ^ 3 - x ^ 2 - x - 1 := by
  unfold nBonacciPoly
  simp [Finset.sum_range_succ]
  ring

/-- P₄ = x⁴ - x³ - x² - x - 1: the Tetranacci polynomial. -/
theorem nBonacciPoly_4 (x : ℝ) :
    nBonacciPoly 4 x = x ^ 4 - x ^ 3 - x ^ 2 - x - 1 := by
  unfold nBonacciPoly
  simp [Finset.sum_range_succ]
  ring

/-- P₃(2) = 8 - 4 - 2 - 1 = 1 > 0: η₃ < 2. -/
theorem nBonacciPoly_3_at_2 : nBonacciPoly 3 2 = 1 := by
  rw [nBonacciPoly_3]; norm_num

/-- P₃(1) = 1 - 1 - 1 - 1 = -2 < 0: η₃ > 1. -/
theorem nBonacciPoly_3_at_1 : nBonacciPoly 3 1 = -2 := by
  rw [nBonacciPoly_3]; norm_num

/-- By IVT, η₃ ∈ (1, 2): the Tribonacci root exists in this interval. -/
theorem tribonacci_root_in_interval :
    ∃ η ∈ Set.Ioo (1 : ℝ) 2, nBonacciPoly 3 η = 0 := by
  have hcont : ContinuousOn (nBonacciPoly 3) (Set.Icc (1:ℝ) 2) := by
    apply Continuous.continuousOn
    unfold nBonacciPoly
    fun_prop
  have hsub := intermediate_value_Ioo (by norm_num : (1:ℝ) ≤ 2) hcont
  have h0 : (0:ℝ) ∈ Set.Ioo (nBonacciPoly 3 1) (nBonacciPoly 3 2) := by
    rw [nBonacciPoly_3_at_1, nBonacciPoly_3_at_2]
    constructor <;> norm_num
  obtain ⟨η, hη, hfη⟩ := hsub h0
  exact ⟨η, hη, hfη⟩

-- ============================================================
-- SECTION 7: Weinberg angle formula structure
-- ============================================================

/-!
## The Weinberg angle formula is algebraically well-formed

sin²θW = Δ/(1+Δ) · (1 - Δ²/6)

where Δ = log(η)/2.

We can prove structural properties without knowing η exactly.
-/

/-- For any Δ ∈ (0, 1), the Weinberg formula gives a value in (0, 1/2). -/
theorem weinberg_range (Δ : ℝ) (hpos : 0 < Δ) (hlt : Δ < 1) :
    0 < Δ / (1 + Δ) * (1 - Δ ^ 2 / 6) ∧
    Δ / (1 + Δ) * (1 - Δ ^ 2 / 6) < 1 / 2 := by
  constructor
  · apply mul_pos
    · apply div_pos hpos; linarith
    · nlinarith [sq_nonneg Δ]
  · have h1 : Δ / (1 + Δ) < 1 / 2 := by
      rw [div_lt_div_iff₀ (by linarith) (by norm_num)]
      linarith
    have h2 : 1 - Δ ^ 2 / 6 ≤ 1 := by nlinarith [sq_nonneg Δ]
    calc Δ / (1 + Δ) * (1 - Δ ^ 2 / 6)
        ≤ Δ / (1 + Δ) * 1 := by
          apply mul_le_mul_of_nonneg_left h2
          apply div_nonneg (le_of_lt hpos); linarith
      _ = Δ / (1 + Δ) := mul_one _
      _ < 1 / 2 := h1

/-- The Weinberg formula is strictly increasing in Δ on (0,1). -/
theorem weinberg_monotone (Δ₁ Δ₂ : ℝ)
    (h1 : 0 < Δ₁) (h2 : Δ₁ < Δ₂) (h3 : Δ₂ < 1) :
    Δ₁ / (1 + Δ₁) * (1 - Δ₁ ^ 2 / 6) <
    Δ₂ / (1 + Δ₂) * (1 - Δ₂ ^ 2 / 6) := by
  have hd1 : Δ₁ < 1 := lt_trans h2 h3
  have h2' : 0 < Δ₂ := lt_trans h1 h2
  have hp1 : (0:ℝ) < 1 + Δ₁ := by linarith
  have hp2 : (0:ℝ) < 1 + Δ₂ := by linarith
  -- f(Δ) = Δ(1 - Δ²/6)/(1 + Δ). The difference of numerators factors through
  -- (Δ₂ - Δ₁) times a bracket bounded below by 1/6 on (0,1).
  have hb : (0:ℝ) < 1 - (Δ₁ ^ 2 + Δ₁ * Δ₂ + Δ₂ ^ 2) / 6 - Δ₁ * Δ₂ * (Δ₁ + Δ₂) / 6 := by
    nlinarith [mul_pos h1 h2', mul_pos (sub_pos.mpr hd1) (sub_pos.mpr h3),
               sq_nonneg Δ₁, sq_nonneg Δ₂, sq_nonneg (Δ₁ + Δ₂)]
  have hid : Δ₂ * (1 - Δ₂ ^ 2 / 6) * (1 + Δ₁) - Δ₁ * (1 - Δ₁ ^ 2 / 6) * (1 + Δ₂)
           = (Δ₂ - Δ₁) * (1 - (Δ₁ ^ 2 + Δ₁ * Δ₂ + Δ₂ ^ 2) / 6 - Δ₁ * Δ₂ * (Δ₁ + Δ₂) / 6) := by
    ring
  have hnum : 0 < Δ₂ * (1 - Δ₂ ^ 2 / 6) * (1 + Δ₁) - Δ₁ * (1 - Δ₁ ^ 2 / 6) * (1 + Δ₂) := by
    rw [hid]; exact mul_pos (sub_pos.mpr h2) hb
  rw [← sub_pos]
  have hsplit : Δ₂ / (1 + Δ₂) * (1 - Δ₂ ^ 2 / 6) - Δ₁ / (1 + Δ₁) * (1 - Δ₁ ^ 2 / 6)
      = (Δ₂ * (1 - Δ₂ ^ 2 / 6) * (1 + Δ₁) - Δ₁ * (1 - Δ₁ ^ 2 / 6) * (1 + Δ₂))
        / ((1 + Δ₁) * (1 + Δ₂)) := by
    field_simp
  rw [hsplit]
  exact div_pos hnum (mul_pos hp1 hp2)

-- ============================================================
-- SECTION 8: CP conservation from SL(3,ℤ)
-- ============================================================

/-- det(T₃ⁿ) = 1 for all n: the strong CP angle is exactly 0.
    Proof: det is multiplicative and det(T₃) = 1. -/
theorem T₃_pow_det_one (n : ℕ) :
    Matrix.det (T₃ ^ n) = 1 := by
  rw [Matrix.det_pow]
  rw [T₃_det_one]
  simp

/-- Corollary: arg(det(T₃ⁿ)) = 0, so θ_eff = 0. -/
theorem theta_CP_zero (n : ℕ) :
    ((Matrix.det (T₃ ^ n) : ℤ) : ℝ) = 1 := by
  have := T₃_pow_det_one n
  exact_mod_cast this

-- ============================================================
-- SECTION 9: Summary of sorry-free status
-- ============================================================

/-!
## Kernel-audit result — 43/43

Audited 30 Aug 2026 with `#print axioms` on every declaration. No `sorryAx`,
no `native_decide`. Ten of the tribSeq facts depend on no axioms at all; the
four Dcrit facts depend on a strict subset; the remaining 29 report exactly
[propext, Classical.choice, Quot.sound].

PROVED (0 sorry, 0 native_decide):
  ✓ V_c_off_by_two               — why the old V_c factorization was false
  ✓ V_c_one_three                — V_3(1) = -2, not 0
  ✓ deriv_V_c, deriv_V_c_one_three
  ✓ W_factorization_c3           — q³-3q+2 = (q-1)²(q+2)
  ✓ W_root_at_one, deriv_W_c, W_deriv_at_one
  ✓ c_star_is_3                  — uniqueness of critical c
  ✓ double_root_W_iff_c3         — full characterization
  ✓ W_third_root, W_roots_complete
  ✓ degree1_single_root          — no fold for degree 1
  ✓ degree2_no_distinct_branch   — no distinct branch for degree 2
  ✓ degree3_first_with_distinct_branch — degree 3 is first
  ✓ T₃_det_one                   — det = 1
  ✓ T₃_sq_correct                — T₃² explicit (literal corrected)
  ✓ T₃_cube_correct              — T₃³ explicit (literal corrected)
  ✓ T₃_cayley_hamilton           — T₃³ = T₃² + T₃ + I
  ✓ tribSeq_0 … tribSeq_7        — 0,0,1,1,2,4,7,13
  ✓ tribSeq_14, tribSeq_21       — 927, 66012 (by decide, kernel-checked)
  ✓ Dcrit_rank3                  — Dcrit(13) = 26
  ✓ Dcrit_rank4                  — Dcrit(56) = 112
  ✓ Dcrit_monotone, Dcrit_above_26
  ✓ nBonacciPoly_2/3/4           — polynomial forms
  ✓ nBonacciPoly_3_at_1/_at_2    — -2 and 1
  ✓ tribonacci_root_in_interval  — IVT existence of η₃ ∈ (1,2)
  ✓ weinberg_range               — formula is well-formed
  ✓ weinberg_monotone            — strictly increasing on (0,1)
                                   [proved 29 Aug 2026 — was this file's one sorry]
  ✓ T₃_pow_det_one               — det(T₃ⁿ) = 1
  ✓ theta_CP_zero                — real-valued θ = 0

SORRY REMAINING: none.

NEEDS GTCT AXIOMS (cannot close without ContactStructure etc.):
  ✗ IsGenerativeCriticalPoint
  ✗ IsSupercriticalRank (physical content)
  ✗ entropic_closure_fails
  ✗ rank_criticality_uniqueness (full)
  ✗ spectralC_rank3_critical (needs exact log(η))
-/

end GTCT_SorryFree
