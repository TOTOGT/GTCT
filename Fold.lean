-- GCTC.Operators.Fold
-- F : X → X  (fold / structural contraction)
-- Models the third phase: collapsing structure — the "going inward" step.
-- In the language chain: taking a complex draft toward a core argument.

import Mathlib.Topology.MetricSpace.Basic

namespace GCTC

/-- A fold operator that contracts X toward a fixed attractor set. -/
structure Folder (X : Type*) [MetricSpace X] where
  apply     : X → X
  /-- The attractor: a point that fold moves toward. -/
  attractor : X
  /-- Each application gets strictly closer to the attractor. -/
  contracts : ∀ x : X, dist (apply x) attractor < dist x attractor ∨
                        x = attractor

/-- Iterating a Folder n times. -/
def Folder.iter {X : Type*} [MetricSpace X] (F : Folder X) : ℕ → X → X
  | 0,     x => x
  | n + 1, x => Folder.iter F n (F.apply x)

end GCTC
