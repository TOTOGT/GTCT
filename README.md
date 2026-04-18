# GTCT — Generative Temporal Contact Theory

**Chapter 10 · Principia Orthogona Vol. IV**  
*Helical Attractors on Contact 3-Manifolds: A Toy ODE Study*

Pablo Nogueira Grossi · G6 LLC · Newark, New Jersey · 2026

---

## What this is

A complete mathematical chapter studying a three-dimensional ODE system on a contact manifold. The unit circle r = 1 is a globally attracting helix for all initial conditions with r(0) > 1, with exponential convergence rate μ → −2. The inner-basin boundary is asymmetric at r* ≈ 0.80, correcting the symmetric Gronwall estimate.

This is a concrete instantiation of the dm³ operator cycle **C → K → F → U** in the GTCT framework, with formal verification in Lean 4 (AXLE v6.1).

## Live site

[totogt.github.io/GTCT](https://totogt.github.io/GTCT)

Includes interactive ODE simulation, inline diagrams, stability table, Lean 4 proof excerpts, and purchase links.

## Contents

| File | Description |
|---|---|
| `index.html` | Full chapter — live GitHub Pages site |
| `PO_10_Pablo_Grossi.pdf` | SBM Bienal 2026 submission (3-page bilingual PT/EN) |
| `dm3_overview.png` | 3D helix + convergence panels |
| `dm3_rz_portrait.png` | (r, z) phase portrait |
| `dm3_stability_sweep.png` | Decay rate vs. initial perturbation |
| `dm3_inner_basin.png` | Inner-basin asymmetry |
| `dm3_simulation.py` | DOP853 reference simulation (Python) |
| `Chain.lean` | GCTC operator chain — Lean 4 |
| `Compress.lean` | C operator formal definition |
| `Fold.lean` | F operator formal definition |
| `Threshold.lean` | Threshold constant g₃₃ = 33 |
| `Unfold.lean` | U operator formal definition |
| `ABSTRACT.md` | Full abstract |
| `FINDINGS.md` | Numerical findings with stability table |
| `GCTC_REVIEW.md` | Code review and correction notes |

## The ODE system

```
r' = r(1 - r²) + ε(r - 1)e^{-z}
θ' = 1
z' = r² - ε(r - 1)²e^{-z}
```

ε = 2 throughout. Integration: DOP853, rtol = 1e-10, atol = 1e-12.

## Key results

- **Attractor confirmed** — all r(0) > 1 converge to r = 1 at rate μ → −2
- **Basin asymmetry** — inner boundary r* ≈ 0.80, not ε₀ = 1/3 (Gronwall)
- **Lean 4 verification** — AXLE v6.1, 0 axioms beyond Mathlib4
- **Open** — AXLE Issue #12 (kappa_lipschitz) is the remaining proof obligation

## Part of the Principia Orthogona series

| Volume | Title | ISBN |
|---|---|---|
| G¹ | The Orthogonal Operator Framework | 979-8-9954416-2-5 |
| G² | TOGT: Applications Across Domains | 979-8-9954416-4-9 |
| G³ | The Mini-Beast: Biological Instantiations | 979-8-9954416-6-3 |
| G⁴ | GTCT T1 — The IMPA Edition | this repo |
| G⁵ | The Seed — Complete Completeness | 979-8-9954416-5-6 |

**Buy:** [brodanova6.gumroad.com/l/soundworks](https://brodanova6.gumroad.com/l/soundworks)  
**IMPA Portal:** [totogt.github.io/AXLE/impa-portal.html](https://totogt.github.io/AXLE/impa-portal.html)  
**Series:** [totogt.github.io/AXLE](https://totogt.github.io/AXLE)

## Formal verification

AXLE v6.1 — Lean 4 + Mathlib4 — 0 additional axioms  
[github.com/TOTOGT/AXLE](https://github.com/TOTOGT/AXLE)

## License

MIT — © 2026 Pablo Nogueira Grossi — G6 LLC  
ORCID: 0009-0000-6496-2186
