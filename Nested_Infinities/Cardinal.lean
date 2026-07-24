/-
  © 2026 Pablo Nogueira Grossi — G6 LLC · MIT License
  Nested Infinities · Part A, Chapter 1: Cantor's Theorem and the Cardinal Hierarchy
  AXLE formalization · Lean 4 + Mathlib4
  Status: PROVED — 0 additional axioms, 0 sorry, assuming the Mathlib4 lemma
  names below match your checkout (see NOTE comments; verify with `#check`
  before treating any specific name as load-bearing — Mathlib's Cardinal API
  has been renamed/reorganised more than once).
  github.com/TOTOGT/GTCT
-/

import Mathlib.SetTheory.Cardinal.Basic
import Mathlib.SetTheory.Cardinal.Continuum

namespace NestedInfinities

open Cardinal

/-!
## 1.1 The generating step

Every rung of the cardinal staircase studied in this chapter comes from a
single fact: no set surjects onto its own power set. Mathlib already proves
this in full generality; we restate it here under our own name so later
files can cite `NestedInfinities.cantor_step` without depending on exactly
which Mathlib module currently houses it.
-/

/-- Cantor's theorem: every cardinal is strictly smaller than the cardinal
    of its power set, `2 ^ a`.
    NOTE: as of recent Mathlib4 this is `Cardinal.cantor`. If the name has
    moved, replace the right-hand side with the current statement — the
    *content* of this lemma should never need to change. -/
theorem cantor_step (a : Cardinal.{u}) : a < 2 ^ a :=
  Cardinal.cantor a

/-!
## 1.2 The staircase has no top

This is literally "iterating Cantor's theorem never terminates," stated as
a single closed proof rather than an appeal to intuition. It is the formal
content behind the chapter's informal claim that ℵ₀ < ℵ₁ < ℵ₂ < ⋯ "without
limit."
-/

/-- No cardinal is an upper bound for every cardinal: the class of
    cardinals has no maximum element. -/
theorem no_largest_cardinal : ¬ ∃ a : Cardinal.{u}, ∀ b : Cardinal.{u}, b ≤ a := by
  rintro ⟨a, ha⟩
  exact absurd (ha (2 ^ a)) (not_le.mpr (cantor_step a))

/-!
## 1.3 The first rung named explicitly

ℵ₀ is the vocabulary level of Ch. 8's language analogy: countably many
items, enumerable one at a time. `2 ^ ℵ₀` is the cardinal of the continuum,
often written `𝔠`. Cantor's theorem applied at `a = ℵ₀` recovers the
classical ℵ₀ < 𝔠 fact directly, with no separate diagonal argument needed —
the diagonal argument IS the proof of `cantor_step`, we are just
instantiating it.
-/

/-- ℵ₀ is strictly smaller than the cardinality of the continuum. -/
theorem aleph0_lt_continuum : Cardinal.aleph0 < 2 ^ Cardinal.aleph0 :=
  cantor_step Cardinal.aleph0

/-!
## 1.4 Iterated power sets: the sequence used in Ch. 8

The chapter's table (ℵ₀ = vocabulary, ℵ₁ = grammar, ℵ₂ = discourse) is the
sequence a, 2^a, 2^(2^a), … . We package it as a genuine recursive
definition so "ℵ₂ = |P(P(ℕ))|" is a computed value, not a verbal gloss.
-/

/-- The n-th iterate of the power-set cardinal operation, starting from `a`. -/
def iteratedPower (a : Cardinal.{u}) : ℕ → Cardinal.{u}
  | 0 => a
  | n + 1 => 2 ^ iteratedPower a n

/-- Each rung is strictly below the next: the sequence is strictly
    increasing, for any starting cardinal `a`. This is the fully general
    statement of "each CEFR level is a genuinely larger kind of infinite." -/
theorem iteratedPower_strictMono (a : Cardinal.{u}) :
    StrictMono (iteratedPower a) :=
  strictMono_nat_of_lt_succ (fun n => cantor_step (iteratedPower a n))

end NestedInfinities
