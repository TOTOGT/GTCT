-- SPDX-License-Identifier: MIT
-- ============================================================================
/-
  Principia Orthogona · Book VI · WP-84, generalised

  WHAT THIS FILE IS.  WP-84 observes that on the framework's twelve-slot phase
  vector, six-fold symmetry leaves no non-constant Fourier mode except the
  folding frequency itself, and calls this "a characterisation of twelve."

  The arithmetic behind it is correct.  The framing is not: twelve is not
  characterised, it is an instance.  The same argument run at any k gives
  N = 2k, and the theorem below is the general statement.  For k = 6 it returns
  N = 12; for k = 10 it returns N = 20.

  WHAT PROMPTED THE GENERALISATION.  On 2 September 2026 a ten-sided wave was
  reported at Saturn's south pole (Sánchez-Lavega et al., *Science Advances*,
  doi 10.1126/sciadv.aee4251), beside the long-known six-sided wave at the
  north.  Two different k in the sky is a good reason to stop presenting one
  value of k as special.

  WHAT THIS FILE DOES NOT CLAIM.  Nothing here bears on Saturn.  The theorem is
  about which Fourier modes of a *discretely sampled* ring survive a cyclic
  symmetry.  Saturn's polar waves are jet-stream wavenumbers in a continuous
  fluid, selected by barotropic instability of a circumpolar jet — the width and
  shear of that jet fix k, and that is a matter of geophysical fluid dynamics
  with no established connection to the sampling statement below.  The two share
  the integers 6 and 10 and, so far as this file is concerned, nothing else.

  A SIMPLIFICATION WORTH RECORDING.  The physically motivated hypothesis is
  k ∣ N — the symmetry must rotate by a whole number of sites.  The arithmetic
  does not need it.  Only 0 < k and 2 ∣ N are used, so the hypothesis is dropped
  rather than carried unused.

  A NOTE ON THE TWO MEMBERSHIP TUPLES.  Both are discharged without naming a
  variable: `by omega, by omega, dvd_rfl` rather than `hk.ne', by omega,
  dvd_refl k`.  `subst` on `m = k` is free to eliminate either side, so a tuple
  that spells one of them out is a proof whose validity depends on which
  variable the tactic happens to keep.  `dvd_rfl` takes its argument
  implicitly and `omega` reads the context, so neither can name something that
  is no longer there.

  STATUS.  No `sorry`.  Check with

      bash ~/Desktop/geometry/tools/leancheck.sh --audit \
           ~/Desktop/GTCT/book4/FoldingFrequency.lean
-/
-- ============================================================================

import Mathlib

namespace FoldingFrequency

/-- The non-constant Fourier modes of an `N`-site ring that survive a `k`-fold
cyclic symmetry: the multiples of `k` up to the folding frequency `N / 2`, with
the constant mode removed. -/
def visibleModes (N k : ℕ) : Finset ℕ :=
  ((Finset.range (N / 2 + 1)).filter (fun m => k ∣ m)).erase 0

/-! ### The general statement -/

/-- **The folding frequency is the only survivor exactly at `N = 2k`.**

For an even number of sites and any `k > 0`, the `k`-fold symmetric ring retains
exactly one non-constant mode — the folding frequency `N / 2` — if and only if
`N = 2k`. -/
theorem visibleModes_eq_nyquist_iff (N k : ℕ) (hk : 0 < k) (hN : 2 ∣ N) :
    visibleModes N k = {N / 2} ↔ N = 2 * k := by
  constructor
  · intro h
    have hmem : N / 2 ∈ visibleModes N k := by
      rw [h]; exact Finset.mem_singleton_self _
    simp only [visibleModes, Finset.mem_erase, Finset.mem_filter,
      Finset.mem_range] at hmem
    obtain ⟨hne, _, hdvd⟩ := hmem
    have hpos : 0 < N / 2 := Nat.pos_of_ne_zero hne
    have hle : k ≤ N / 2 := Nat.le_of_dvd hpos hdvd
    have hk' : k ∈ visibleModes N k := by
      simp only [visibleModes, Finset.mem_erase, Finset.mem_filter,
        Finset.mem_range]
      exact ⟨by omega, by omega, dvd_rfl⟩
    rw [h, Finset.mem_singleton] at hk'
    have hdiv : N / 2 * 2 = N := Nat.div_mul_cancel hN
    omega
  · rintro rfl
    have h2 : 2 * k / 2 = k := by omega
    ext m
    simp only [visibleModes, h2, Finset.mem_erase, Finset.mem_filter,
      Finset.mem_range, Finset.mem_singleton]
    constructor
    · rintro ⟨hm0, hmlt, hdvd⟩
      have := Nat.le_of_dvd (Nat.pos_of_ne_zero hm0) hdvd
      omega
    · intro hm
      subst hm
      exact ⟨by omega, by omega, dvd_rfl⟩

/-! ### The two instances, and the near misses -/

/-- The corpus's twelve-slot phase vector: six-fold symmetry, folding frequency
6, nothing else. -/
theorem hexagon_at_twelve : visibleModes 12 6 = {6} := by decide

/-- Ten-fold symmetry does the same thing at twenty sites. Twelve was never
distinguished. -/
theorem decagon_at_twenty : visibleModes 20 10 = {10} := by decide

/-- Eighteen sites leave a single non-constant mode too — but it is 6, not the
folding frequency 9. A singleton is not the claim; the claim is that the
singleton *is the fold*. -/
theorem eighteen_is_not_the_fold : visibleModes 18 6 = {6} ∧ (18 : ℕ) / 2 = 9 := by
  refine ⟨by decide, by norm_num⟩

/-- Twenty-four sites keep two non-constant modes. -/
theorem twentyfour_keeps_two : visibleModes 24 6 = {6, 12} := by decide

/-- Forty sites, ten-fold: the same failure one k up. -/
theorem forty_keeps_two : visibleModes 40 10 = {10, 20} := by decide

/-- Stated for the record: both published cases follow from the general theorem
rather than from computation. -/
example : visibleModes 12 6 = {12 / 2} ↔ (12 : ℕ) = 2 * 6 :=
  visibleModes_eq_nyquist_iff 12 6 (by norm_num) (by norm_num)

example : visibleModes 20 10 = {20 / 2} ↔ (20 : ℕ) = 2 * 10 :=
  visibleModes_eq_nyquist_iff 20 10 (by norm_num) (by norm_num)

end FoldingFrequency
