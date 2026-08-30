# ZENODO_DESCRIPTION_RH_V2.md
# Copy this text into the Zenodo description field for the V2 upload.
# Upload as a NEW VERSION of record 22179684, not a new record, so the concept
# DOI keeps resolving to the latest.

---

## The Riemann Hypothesis as Non-Integrability of an Arithmetic Contact Structure on the Adele Class Space
### Version 2 — 30 August 2026

**Pablo Nogueira Grossi · G6 LLC, Newark NJ · ORCID: 0009-0000-6496-2186**

**V1:** https://doi.org/10.5281/zenodo.22179684
**Repositories:** https://github.com/TOTOGT/GTCT (source, Lean, figures — `deposits/rh-arithmetic-contact-v1/`) ·
https://github.com/TOTOGT/geometry (*Principia Orthogona*, Books 1–8) ·
https://github.com/TOTOGT/AXLE (Lean corpus)
**Formalisation:** https://github.com/TOTOGT/GTCT/blob/main/book4/ZetaReflection.lean
**Chapters this paper formalises:** Book 4 Ch 11 and Ch 12 —
https://totogt.github.io/geometry/book4/ch12.html

---

### What changed in V2

**Four statements are now proved and kernel-audited** that V1 listed as *argued* or
*admitted*, in Lean 4 / Mathlib v4.32.0:

- `chiLog_real_on_critical_line` — the gamma-factor defect is real on σ = ½. This is *why*
  the critical line is distinguished in §4.5, and it was admitted in V1.
- `Zlog_conj` — ζ′/ζ commutes with complex conjugation.
- `gCoef_odd_in_t`, `cCoef_even_in_t` — the parity of the two coefficients in *t*, asserted
  without proof in V1.

Each reports `[propext, Classical.choice, Quot.sound]` under `#print axioms` — no `sorryAx`,
no `native_decide`. **None of them uses any information about the location of the zeros of
ζ**; all four reduce to Schwarz reflection.

**The one remaining admitted statement is reduced to a single classical input.**
`reflection_law` now depends only on ζ′/ζ(s) + ζ′/ζ(1−s) = χ′/χ(s), verified to 30 digits.
§4.7 gives the route through Mathlib's `completedRiemannZeta_one_sub`, and records two traps
that cost real time to find: the *asymmetric* functional equation leads into Legendre
duplication and does not give χ′/χ, and Mathlib encodes Γ's poles as zeros, so Γ(s/2) ≠ 0 is
a hypothesis that must be carried rather than a fact.

**The thermodynamic contact lineage is credited.** Lifting a 2D state space to a 3D contact
manifold carrying c dU − g dV is the standard construction of contact thermodynamics, not
something introduced here. §7.4 says so and cites it. The contribution is a dictionary
entry, not a new geometry — and no novelty is claimed for the lift, the two-coefficient
form, or the one-sided pole, because no literature search establishing it has been run.

**A prior-art comparison with verified citations** (§7.4): Deninger's foliated dynamical
systems, Meyer's spectral interpretation, the Bost–Connes system, and Morishita's recent
bridge between Deninger's Witt-space foliations and Connes–Consani's adelic spaces. Three
widely circulated citations were found to be wrong during preparation and are corrected in
the reference list.

**A new §5.5 states the category obstruction plainly.** On ℝ²×ℝ_t the form is an ordinary
smooth 1-form. On the adele class space it is not: that quotient is not a smooth manifold,
which is the obstruction that sent Connes to noncommutative geometry. The adelic assembly is
a formal dictionary, not a contact manifold, and this is the largest gap in the paper —
separate from, and prior to, the positivity question.

**A new *Deposit contents and reproducibility* section** lists every file and the exact
commands to re-check the formalisation and the numerics.

---

### What this paper does

It reformulates RH as a non-vanishing condition on an arithmetic contact 3-form on the adele
class space, by promoting the height *t* from a parameter to a coordinate. The resulting
1-form carries the von Mangoldt–Dirichlet series as its coefficient, and the non-integrability
condition — automatic in the smooth setting — becomes a global positivity statement on the
idele class group action.

### What it does not do

**RH itself is untouched.** This is a translation dictionary, not a proof. §4.6 states
exactly which claims are proved, which are machine-checked, which are classical, and which
are numerical only. The missing rung (§6) is equivalent to RH, and nothing here bears on it.

---

**Keywords:** Riemann Hypothesis · contact geometry · adele class space · von Mangoldt
function · Riemann–Siegel theta · Weil explicit formula · Connes spectral triple ·
contact thermodynamics · Lean 4 · formal verification · Principia Orthogona

**MSC:** 11M26 · 53D10 · 11R56 · 81Q10

**Licence:** CC BY 4.0
