/-
  © 2026 Pablo Nogueira Grossi — G6 LLC · MIT License
  Nested Infinities · Part A, Chapter 3: Conway's Surreal Numbers
  AXLE formalization · Lean 4 + Mathlib4
  Status: CITED + open. Mathlib4 has `Surreal` (Mathlib.SetTheory.Surreal.Basic)
  as an ordered structure via the game-theoretic Left/Right construction, and
  proves it is a `LinearOrderedField` in the sense relevant to Mathlib's own
  development — but Conway's *universality theorem* ("No is the unique
  universal ordered field, every ordered field embeds in it") is a deep
  classical result that is NOT, to my knowledge, formalized in Mathlib4.
  Treat every claim in this file that depends on universality as CITED
  (Conway 1976, Alling 1987) rather than PROVED-in-Lean, until an actual
  Mathlib formalization exists to point to.
  github.com/TOTOGT/GTCT
-/

import Mathlib.SetTheory.Surreal.Basic

namespace NestedInfinities

/-!
## 3.1 What is actually machine-checked today

Mathlib4 defines `Surreal` and proves it carries a linear order and field
structure compatible with the surreal `≤`. That much is real and citable
as PROVED-in-Mathlib (not proved here — we are consumers of it). What is
NOT in Mathlib, as far as I can establish, is:
  (a) Conway's Day-n construction as an explicit indexed recursion
      matching the informal "Day 0, Day 1, …, Day ω, …" story in Ch. 8;
  (b) the universality theorem itself;
  (c) ω and ε = 1/ω as named surreal constants with the properties the
      chapter attributes to them (ω greater than every integer, ε positive
      and smaller than every positive real).
None of these should be asserted as PROVED without either finding the
actual Mathlib lemma names or doing the construction from scratch. -/

/-- Placeholder for the informal claim "there exists a surreal number
    greater than every natural number." This is true and constructible
    (Conway's Day-ω number), but I have not located a ready-made Mathlib
    statement of it; left open rather than invented.
    STATUS: sorry — AXLE Issue #23 (surreal-omega-exists). -/
theorem exists_surreal_gt_all_nat :
    ∃ x : Surreal, ∀ n : ℕ, (n : Surreal) < x := by
  sorry -- AXLE Issue #23

/-- Placeholder for the existence of a positive infinitesimal: a surreal
    number greater than 0 but smaller than every positive rational (hence
    every positive real, once the real embedding is established).
    STATUS: sorry — AXLE Issue #24 (surreal-epsilon-exists). -/
theorem exists_positive_infinitesimal :
    ∃ x : Surreal, 0 < x ∧ ∀ q : ℚ, 0 < q → x < (q : Surreal) := by
  sorry -- AXLE Issue #24

/-!
## 3.2 What Theorem 8.1(3) actually needs, stated precisely

Chapter 8's "G_∞ is isomorphic to No" is a much stronger claim than either
of the two placeholders above: it asserts a *specific* fixed point of a
*specific* operator embeds as an order-isomorphism into the surreals. That
requires, at minimum, (i) an actual construction of G_∞ as a mathematical
object outside of Lean (see the note in GTCT.lean — this has not been
supplied yet), and (ii) a proof that whatever No-fragment it lands in
recovers surreal order structure exactly, not merely "resembles" it. Until
(i) exists, this file cannot honestly contain even a sorry for (3) — there
is no well-typed statement to sorry yet. This gap is recorded here so it
is not silently lost. -/

end NestedInfinities
