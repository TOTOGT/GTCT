# GTCT — G-Chain / Contact Topology / Toy Dynamics

**A Lean 4 formalization of the G-chain operator framework, plus numerical validation of the dm³ toy ODE on contact 3-manifolds, plus the SBM Bienal bilingual submission.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Lean 4](https://img.shields.io/badge/Lean-4.11.0-blue.svg)](https://leanprover.github.io/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.11.0-green.svg)](https://leanprover-community.github.io/)

---

## Overview

This repository brings together three complementary strands of the GTCT research programme:

1. **Formalization (Lean 4).** Five Mathlib-backed modules defining the four primitive operators `C, K, F, U` and the composite chain `G = U ∘ F ∘ K ∘ C`, together with the g-series regime taxonomy (g⁰, g², g⁶, g³³, g⁶⁴) and the AXLE proof obligations.
2. **Numerics (Python / SciPy).** A reference DOP853 integration of the dm³ toy ODE on a contact 3-manifold, reproducing the helical attractor and — crucially — identifying the asymmetric basin correction that had previously been obscured by a too-generous Gronwall estimate.
3. **Dissemination.** The 3-page bilingual (Portuguese / English) submission to the **SBM Bienal** — Brazil is a major market for this work, which is why the primary dissemination path is through the Sociedade Brasileira de Matemática.

## Repository layout

```
GTCT/
├── LICENSE                              MIT
├── lakefile.lean                        Lake build configuration
├── lean-toolchain                       Pinned Lean 4 version
├── GCTC.lean                            Umbrella import
├── GCTC/
│   └── Operators/
│       ├── Compress.lean                C : contraction with Lipschitz ratio
│       ├── Threshold.lean               K : nonlinear gate + soft-threshold
│       ├── Fold.lean                    F : contraction toward attractor
│       ├── Unfold.lean                  U : expansion from seed
│       └── Chain.lean                   G-chain + g-series + AXLE obligations
├── docs/
│   ├── ABSTRACT.md                      SBM abstract (bilingual source)
│   ├── FINDINGS.md                      dm³ numerical findings & corrections
│   └── GCTC_REVIEW.md                   Code review + ε₀ → r_star patch rationale
├── numerics/
│   ├── dm3_simulation.py                Reference integrator (DOP853)
│   └── figures/                         4 PNGs: overview, (r,z), stability, inner basin
└── submissions/
    └── sbm-bienal/
        └── PO_10_Pablo_Grossi.pdf       Final submission, 3 pages PT→EN
```

## Key result

For the dm³ toy ODE

```
ṙ = r(1 − r²) + 2(r − 1)·e⁻ᶻ
θ̇ = 1
ż = r² − 2(r − 1)²·e⁻ᶻ
```

every trajectory with `r(0) > 1` converges exponentially to the unit circle `r = 1` at rate `μ = −2`, yielding a globally attracting helix on the contact 3-manifold. On the inner side, the true basin boundary is `r* ≈ 0.8` — **not** the symmetric ball `|r − 1| < 1/3` previously claimed from a Gronwall estimate. See `docs/FINDINGS.md` for the stability sweep and `docs/GCTC_REVIEW.md` for how this changed the Lean formalization.

## Building the Lean project

Requires `elan` (Lean version manager).

```bash
git clone https://github.com/TOTOGT/GTCT.git
cd GTCT
lake exe cache get     # fetch pre-built Mathlib oleans (~5 min the first time)
lake build             # build the GCTC library
```

## Reproducing the numerics

```bash
cd numerics
pip install scipy matplotlib numpy
python3 dm3_simulation.py
```

Generates all four figures in `numerics/figures/` and prints the stability sweep table (reproduces `docs/FINDINGS.md` to 3 decimals).

## AXLE proof obligations

Four `sorry`s are currently open. Each is documented in `GCTC/Operators/Chain.lean`.

| ID  | Target                              | Difficulty | Status |
|-----|-------------------------------------|------------|--------|
| (a) | `gronwall_outer` exponential bound  | easy       | sorry — proof sketch in review |
| (b) | `inner_basin_is_asymmetric` axiom   | hard       | axiom pending ODE formalisation |
| (c) | `spiral_return_exists` (T1)         | medium     | sorry — non-triviality hypothesis added |
| (d) | `poincare_collatz` conjecture       | open       | sorry — conjectural |

The previous `gronwall_bound` statement was provably false (see `docs/GCTC_REVIEW.md §5.1`); the replacement `gronwall_outer` is sharp.

## References

- **AXLE working paper (book3).** Grossi, P. N. *AXLE: Asymmetric Attractors, g-Series Dynamics and the Spiral-Return Theorem.* 2026. <https://totogt.github.io/AXLE>
- **SBM Bienal submission.** Grossi, P. N. *Helical Attractors on Contact 3-Manifolds: A Toy ODE Study / Atratores Helicoidais em Variedades de Contato de Dimensão 3.* Sociedade Brasileira de Matemática, 2026. Included in this repository at `submissions/sbm-bienal/PO_10_Pablo_Grossi.pdf`.
- **Mathlib.** The Lean Community. *Mathlib4.* <https://github.com/leanprover-community/mathlib4>
- **Lean 4.** de Moura, L.; Ullrich, S. *The Lean 4 theorem prover.* <https://leanprover.github.io/>
- **DOP853 integrator.** Hairer, E.; Nørsett, S. P.; Wanner, G. *Solving Ordinary Differential Equations I: Nonstiff Problems.* Springer Series in Computational Mathematics 8, 2nd ed., 1993.
- **Contact geometry background.** Geiges, H. *An Introduction to Contact Topology.* Cambridge Studies in Advanced Mathematics 109, Cambridge University Press, 2008.
- **Gronwall inequality.** Hartman, P. *Ordinary Differential Equations,* 2nd ed., SIAM Classics in Applied Mathematics 38, 2002, §III.1.

## Copyright and license

© 2026 Pablo Nogueira Grossi — G6 LLC. All rights reserved where not licensed.

This repository is released under the **MIT License** (see `LICENSE`). You are free to use, modify, and redistribute the code and documentation, subject to attribution of the copyright holder.

The dm³ simulation script, the Lean formalization, the review document, and the SBM submission PDF are all covered by the same MIT license. Mathlib imports remain under their own Apache-2.0 license.

## Citation

If you use this work, please cite:

```
@misc{grossi2026gtct,
  author       = {Pablo Nogueira Grossi},
  title        = {{GTCT}: G-Chain Formalization and Helical Attractors on Contact 3-Manifolds},
  year         = {2026},
  howpublished = {\url{https://github.com/TOTOGT/GTCT}},
  note         = {MIT license. See also the AXLE working paper at \url{https://totogt.github.io/AXLE}.}
}
```

## Contact

Questions, corrections, and pull requests welcome via GitHub Issues at <https://github.com/TOTOGT/GTCT/issues>.
