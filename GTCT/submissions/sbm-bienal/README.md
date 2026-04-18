# SBM Bienal — Bilingual Submission

**File:** `PO_10_Pablo_Grossi.pdf` — 3 pages, Portuguese → English.
**Author:** Pablo Nogueira Grossi (G6 LLC).
**Title:** Helical Attractors on Contact 3-Manifolds: A Toy ODE Study / Atratores Helicoidais em Variedades de Contato de Dimensão 3.
**Event:** Bienal da Sociedade Brasileira de Matemática (Brazil is a major market for this research programme; primary dissemination route).

## Page map

1. **Página 1 (Português)** — Resumo, Sistema (ODE), Teorema, Figura 1 (fase 4 painéis).
2. **Página 2 (Português, continuação)** — Descobertas Numéricas, Tabela 1 (varredura de estabilidade), Figuras 2 e 3 (taxa empírica + assimetria da bacia interna), Significado, Reprodutibilidade.
3. **Page 3 (English)** — Abstract, System, Theorem, Key Findings, Significance, Reproducibility, Keywords.

## Reproducing the figures

All four embedded figures are regenerated from `numerics/dm3_simulation.py` in the repository root. The PDF itself is rebuilt via the reportlab-based generator in the project's build scripts (not included in this release; see `docs/GCTC_REVIEW.md` for rationale on font and typography choices).

## Linked artefacts

- Source abstract: `../../docs/ABSTRACT.md`
- Numerical findings: `../../docs/FINDINGS.md`
- Code review with the ε₀ → r_star correction: `../../docs/GCTC_REVIEW.md`
- Lean formalization of the G-chain: `../../GCTC/Operators/Chain.lean`
- AXLE working paper: <https://totogt.github.io/AXLE>

Copyright © 2026 Pablo Nogueira Grossi — G6 LLC. MIT License.
