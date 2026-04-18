-- GCTC.Operators.Unfold
-- U : X → X  (unfold / generative expansion)
-- Models the fourth phase: expanding a compressed, thresholded, folded
-- representation into a richer output.  The dual of Fold: moves away
-- from a seed toward an expanded attractor basin.

import Mathlib.Topology.MetricSpace.Basic

namespace GCTC

/-- An unfold operator that expands X away from a seed point. -/
structure Unfolder (X : Type*) [MetricSpace X] where
  apply  : X → X
  /-- The seed: a point the unfolder moves away from. -/
  seed   : X
  /-- Each application strictly increases distance from the seed,
      unless we are already at the seed. -/
  expands : ∀ x : X, dist (apply x) seed > dist x seed ∨ x = seed

/-- Iterating an Unfolder n times. -/
def Unfolder.iter {X : Type*} [MetricSpace X] (U : Unfolder X) : ℕ → X → X
  | 0,     x => x
  | n + 1, x => Unfolder.iter U n (U.apply x)

/-- After one step the distance from seed is non-decreasing. -/
lemma Unfolder.dist_nondecreasing {X : Type*} [MetricSpace X]
    (U : Unfolder X) (x : X) (hx : x ≠ U.seed) :
    dist (U.apply x) U.seed > dist x U.seed := by
  rcases U.expands x with h | h
  · exact h
  · exact absurd h hx

end GCTC
