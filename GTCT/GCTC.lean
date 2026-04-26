/-
Copyright (c) 2026 Pablo Nogueira Grossi — G6 LLC. All rights reserved.
Released under the MIT License. See the LICENSE file in the project root.
Authors: Pablo Nogueira Grossi
-/

/-
GCTC — umbrella module

Importing this file brings in the entire G-chain operator library:
  C (Compress), K (Threshold), F (Fold), U (Unfold), and the
  composite  G = U ∘ F ∘ K ∘ C  (Chain) together with the g-series
  taxonomy, the asymmetric-basin constants (r_star, μ_outer),
  the Gronwall outer-basin bound, and the AXLE proof obligations.

Copyright (c) 2026 Pablo Nogueira Grossi — G6 LLC
Released under the MIT License; see the LICENSE file in the project root.
-/

import GCTC.Operators.Compress
import GCTC.Operators.Threshold
import GCTC.Operators.Fold
import GCTC.Operators.Unfold
import GCTC.Operators.Chain
import GCTC.Operators.OrbitLadder
