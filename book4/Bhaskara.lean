-- SPDX-License-Identifier: MIT
-- ============================================================================
/-
  Principia Orthogona · Book 4 · the Brahmagupta–Bhāskara composition

  WHAT THIS FILE IS.  The identity behind the chakravala method, the monoid
  structure it puts on the solutions of x² − N y² = 1, and the single case
  Fermat set as a challenge to the English mathematicians in February 1657 —
  five hundred and seven years after it had been solved and printed in India.

  THE HISTORY, STATED PRECISELY, BECAUSE THE LOOSE VERSION IS WRONG.

    628   Brahmagupta, Brāhmasphuṭasiddhānta.  States the composition identity
          below (his *bhāvanā*, "production") and solves x² − N y² = 1 for
          several N.  The identity is the whole engine: it turns two solutions
          into a third, and a near-solution into a better one.

    1150  Bhāskara II, Bījagaṇita.  The chakravala ("cyclic") method, which
          drives Brahmagupta's composition by a descent step.  Solves
          x² − 61 y² = 1 explicitly, obtaining x = 1766319049,
          y = 226153980.

    1657  Fermat, in a February challenge circulated to Wallis and Brouncker
          through Digby, poses x² − N y² = 1 for general non-square N and
          singles out N = 61 and N = 109 as the cases to try.  He claims a
          proof of solvability for every non-square N and does not give one.

    1768  Lagrange gives the first European proof that a solution always
          exists, via continued fractions.

  WHAT IS AND IS NOT CLAIMED HERE.  Bhāskara had the *answer* to the case
  Fermat later set as a challenge, in print, 507 years earlier.  He did not
  have a proof of the general theorem in the modern sense: chakravala always
  terminates, but its termination was not proved until much later.  So this is
  not "Bhāskara proved Fermat's theorem."  It is something sharper and easier
  to check: the specific number Fermat used to test Europe was already
  published, in a language Fermat did not read.  The identity below is the
  reason it could be found at all, and the reason a nine-digit answer is
  verifiable in one line by anyone who has the identity and none by anyone who
  does not.

  WHY IT BELONGS IN THIS BOOK.  Book 4 has been reading duality as a
  correspondence with two projections.  This is the arithmetic instance: the
  norm form x² − N y² is a quadratic form, its composition law is a group law,
  and Brahmagupta's identity is that law written before there was a word for
  it.  It is also the cleanest example in the corpus of a result whose *only*
  surviving justification, for five centuries, was that it could be checked.

  STATUS.  Every theorem below is proved.  No `sorry`.  Run

      bash ~/Desktop/geometry/tools/leancheck.sh --audit \
           ~/Desktop/GTCT/book4/Bhaskara.lean

  and the audit should report the three standard axioms and nothing else.
-/
-- ============================================================================

import Mathlib

namespace Bhaskara

/-! ### The composition identity -/

/-- **Brahmagupta's identity** (Brāhmasphuṭasiddhānta, 628).

The product of two values of the norm form `x² − N y²` is again a value of the
same form. This is what makes the solutions of a Pell equation composable, and
it is the engine of the chakravala method. -/
theorem brahmagupta (N a b c d : ℤ) :
    (a ^ 2 - N * b ^ 2) * (c ^ 2 - N * d ^ 2)
      = (a * c + N * b * d) ^ 2 - N * (a * d + b * c) ^ 2 := by
  ring

/-- The conjugate form of the same identity. Brahmagupta gives both; the two
signs are what let chakravala move in either direction. -/
theorem brahmagupta' (N a b c d : ℤ) :
    (a ^ 2 - N * b ^ 2) * (c ^ 2 - N * d ^ 2)
      = (a * c - N * b * d) ^ 2 - N * (a * d - b * c) ^ 2 := by
  ring

/-! ### The solutions of `x² − N y² = 1` form a commutative monoid -/

/-- `IsPell N x y` says that `(x, y)` solves `x² − N y² = 1`. -/
def IsPell (N x y : ℤ) : Prop := x ^ 2 - N * y ^ 2 = 1

/-- The trivial solution. -/
theorem isPell_one (N : ℤ) : IsPell N 1 0 := by
  unfold IsPell; ring

/-- **bhāvanā** — Brahmagupta's composition, as a closure property. Two
solutions compose to a third. This is the step chakravala iterates. -/
theorem isPell_comp {N a b c d : ℤ} (h₁ : IsPell N a b) (h₂ : IsPell N c d) :
    IsPell N (a * c + N * b * d) (a * d + b * c) := by
  unfold IsPell at *
  rw [← brahmagupta, h₁, h₂]
  ring

/-- Conjugation is an involution on solutions: it is the inverse of the monoid
law, so the solutions form a group, not merely a monoid. -/
theorem isPell_conj {N a b : ℤ} (h : IsPell N a b) : IsPell N a (-b) := by
  unfold IsPell at *
  rw [← h]; ring

/-- The composition of a solution with its conjugate is the identity. -/
theorem isPell_comp_conj {N a b : ℤ} (h : IsPell N a b) :
    a * a + N * b * (-b) = 1 ∧ a * (-b) + b * a = 0 := by
  unfold IsPell at h
  refine ⟨?_, by ring⟩
  have e : a * a + N * b * (-b) = a ^ 2 - N * b ^ 2 := by ring
  rw [e, h]

/-! ### The case Fermat set as a challenge -/

/-- **Bhāskara II, 1150.** The solution of `x² − 61 y² = 1` obtained by
chakravala, five centuries before Fermat proposed the same case to Europe.

The point of stating it in a proof assistant is the same point the number made
in 1657: a claim of this shape is cheap to check and expensive to find. -/
theorem bhaskara_61 : IsPell 61 1766319049 226153980 := by
  unfold IsPell; norm_num

/-- One `bhāvanā` step applied to Bhāskara's solution and itself. The two
components below are exactly the composition formulas of `isPell_comp`
evaluated at `a = c = 1766319049`, `b = d = 226153980`, `N = 61`. -/
theorem bhaskara_61_step_fst :
    (1766319049 : ℤ) * 1766319049 + 61 * 226153980 * 226153980
      = 6239765965720528801 := by
  norm_num

theorem bhaskara_61_step_snd :
    (1766319049 : ℤ) * 226153980 + 226153980 * 1766319049
      = 798920165762330040 := by
  norm_num

/-- The composed solution, obtained rather than guessed: `isPell_comp` applied
to `bhaskara_61` with itself, with the two components rewritten by the
arithmetic above. -/
theorem bhaskara_61_squared :
    IsPell 61 6239765965720528801 798920165762330040 := by
  have h := isPell_comp bhaskara_61 bhaskara_61
  rwa [bhaskara_61_step_fst, bhaskara_61_step_snd] at h

/-- The second case in Fermat's challenge, `N = 109`, with the solution the
challenge was designed to make hard to reach. -/
theorem fermat_challenge_109 :
    IsPell 109 158070671986249 15140424455100 := by
  unfold IsPell; norm_num

/-! ### What the composition is, in one line

`isPell_comp` is the multiplication of `ℤ[√N]` restricted to the norm-one
elements: `(a + b√N)(c + d√N) = (ac + Nbd) + (ad + bc)√N`, and Brahmagupta's
identity is multiplicativity of the norm. Brahmagupta had the law in 628; the
word "norm", the ring, and the group were not available for another twelve
hundred years. The identity did not need them, which is the observation this
file exists to record. -/

end Bhaskara
