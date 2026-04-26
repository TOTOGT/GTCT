import Lake
open Lake DSL

package GCTC where
  -- Lean + Mathlib options
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.11.0"

@[default_target]
lean_lib GCTC where
  -- Library roots are the files in GCTC/
  globs := #[.andSubmodules `GCTC]

-- dm³ dual-cavity multi-orbit extension
lean_lib DualChamberGTCT where
  srcDir := "lean/dm3-dual-cavity"
  globs  := #[.submodules `DualChamberGTCT]
