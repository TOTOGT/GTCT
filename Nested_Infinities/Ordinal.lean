/-
  © 2026 Pablo Nogueira Grossi — G6 LLC · MIT License
  Nested Infinities · Part A, Chapter 2: Ordinal Numbers and Epsilon Numbers
  AXLE formalization · Lean 4 + Mathlib4
  Status: MIXED. Every claim below is either closed with a proof I could
  reason through without guessing an unverifiable API name, or left as an
  honest `sorry` with an AXLE Issue tag. Nothing here is faked.
    §2.1  omega0_not_succ            — sorry, AXLE Issue #21
    §2.2  omega0_lt_omega0_succ      — PROVED (0 sorry, only needs Order.lt_succ)
    §2.2  omega0_lt_omega0_add_omega0 — sorry, AXLE Issue #22
    §2.3  exists_epsilon0            — sorry, AXLE Issue #20
  Total: 1 proved lemma, 1 proved definition (iteratedPower-style recursion
  is in Cardinal.lean not here), 3 open sorries in this file. Run
  `lake build` and `#print axioms` locally to confirm before citing.
  github.com/TOTOGT/GTCT
-/

import Mathlib.SetTheory.Ordinal.Arithmetic
import Mathlib.SetTheory.Ordinal.Exponential

namespace NestedInfinities

open Ordinal

/-!
## 2.1 ω and the successor/limit distinction

`Ordinal.omega0` (Mathlib's name for the first infinite ordinal — earlier
Mathlib versions called this `Ordinal.omega`; check which your checkout
uses) marks the end of all natural numbers. Every ordinal below it is
finite; it is itself a limit ordinal, i.e. not a successor of anything.
-/

/-- ω is not the successor of any ordinal.
    STATUS: sorry — AXLE Issue #21 (omega0-not-succ). The proof sketch is:
    a + 1 = ω would force a < ω, hence a = (n : Ordinal) for some n : ℕ
    (`Ordinal.lt_omega0`), giving (n:Ordinal)+1 = ω; but (n+1 : Ordinal) < ω
    (`Ordinal.nat_lt_omega0`) contradicts that equality. This is almost
    certainly already a one-line lemma in Mathlib under a name like
    `Ordinal.omega0_isLimit` or `Ordinal.not_succ_of_isLimit` — check that
    first before re-deriving the sketch above. Left as sorry rather than a
    guessed tactic sequence I cannot verify compiles. -/
theorem omega0_not_succ : ¬ ∃ a : Ordinal, a + 1 = Ordinal.omega0 := by
  sorry -- AXLE Issue #21

/-!
## 2.2 ω · 2 as a genuinely new tier

Nesting one infinite sequence inside a new structural tier, as the chapter
describes it, is exactly ordinal addition: ω + ω = ω · 2 is strictly larger
than ω, and yet has the same cardinality (ℵ₀). This is the cleanest formal
statement of "you can keep going past ω without changing cardinality" —
the ordinal and cardinal hierarchies genuinely measure different things.
-/

/-- ω is strictly less than its own successor ω + 1. This is the safest
    possible instance of "a genuinely new tier past ω" — it only needs
    `Order.lt_succ`, not ordinal-addition monotonicity in the left argument,
    which (unlike the right argument) is famously *not* strict for ordinals
    (e.g. 1 + ω = ω). The stronger claim ω < ω + ω in the chapter's prose
    is true but needs right-monotonicity of ordinal `+`; state it here as
    a named gap rather than guess the exact Mathlib lemma name. -/
theorem omega0_lt_omega0_succ : Ordinal.omega0 < Ordinal.omega0 + 1 :=
  Order.lt_succ Ordinal.omega0

/-- ω < ω + ω.
    STATUS: sorry — AXLE Issue #22. True by right-strict-monotonicity of
    ordinal addition (`c + a < c + b` whenever `a < b`, for fixed `c` on
    the left — check `Ordinal.add_lt_add_left` or the relevant
    `CovariantClass` instance name in your Mathlib checkout). Left as sorry
    rather than a guessed API call. -/
theorem omega0_lt_omega0_add_omega0 :
    Ordinal.omega0 < Ordinal.omega0 + Ordinal.omega0 := by
  sorry -- AXLE Issue #22

/-!
## 2.3 Epsilon numbers — CONJECTURAL closure, honestly marked

An epsilon number is an ordinal ε satisfying ω^ε = ε: a fixed point of
ordinal exponentiation base ω. ε₀ is the smallest one, and it measures the
proof-theoretic strength of Peano Arithmetic (Gentzen 1936). We state the
existence claim precisely and leave the proof as an honest gap rather than
faking a derivation.
-/

/-- Definition: `e` is an epsilon number if it is a fixed point of
    `x ↦ ω ^ x`. -/
def IsEpsilonNumber (e : Ordinal) : Prop := (Ordinal.omega0 : Ordinal) ^ e = e

/-- There exists a smallest epsilon number, ε₀.
    STATUS: sorry — AXLE Issue #20 (epsilon-zero-existence).
    This is a genuine open item in this formalization, not a filled-in
    placeholder: closing it is real work, likely via Mathlib's normal-
    function fixed-point machinery if available, or an explicit
    `⨆ n, (fun x => ω ^ x)^[n] 0` construction otherwise. -/
theorem exists_epsilon0 : ∃ e : Ordinal, IsEpsilonNumber e ∧
    ∀ e' : Ordinal, IsEpsilonNumber e' → e ≤ e' := by
  sorry -- AXLE Issue #20

end NestedInfinities
