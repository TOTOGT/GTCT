# ZENODO_DESCRIPTION_RH_V3.md
# New version of record 22179684 (v1) / 22181879 (v2). Upload the seven files in
# deposits/rh-arithmetic-contact-v1/ listed below — and no others.

---

## The Riemann Hypothesis as Non-Integrability of an Arithmetic Contact Structure on the Adele Class Space
### Version 3 — 30 August 2026 · a file correction to v2

**Pablo Nogueira Grossi · G6 LLC, Newark NJ · ORCID: 0009-0000-6496-2186**

**v1:** https://doi.org/10.5281/zenodo.22179684 · **v2:** https://doi.org/10.5281/zenodo.22181879
**Repositories:** https://github.com/TOTOGT/GTCT (`deposits/rh-arithmetic-contact-v1/`) ·
https://github.com/TOTOGT/geometry · https://github.com/TOTOGT/AXLE
**Formalisation:** https://github.com/TOTOGT/GTCT/blob/main/book4/ZetaReflection.lean

---

### Why v3 exists

The v2 upload shipped the wrong files. Stated plainly, because this paper's whole argument
is that a published claim must resolve to the artifact that produces it:

- **`ZetaReflection.lean` was uploaded at 5,749 bytes** — the pre-revision file, containing
  **none** of the four theorems that v2's own §4.7 describes as proved and kernel-audited.
  The correct file is **11,344 bytes** and contains `chiLog_real_on_critical_line`,
  `Zlog_conj`, `gCoef_odd_in_t` and `cCoef_even_in_t`.
- **The v1 markdown source was uploaded under the v2 source's name**, and the actual v2
  source was auto-renamed to `RH_arithmetic_contact_structure_1.md` on filename collision.
  A reader following the paper's own manifest got the old source.
- **`RELATED-WORK.md` was listed in the manifest and not uploaded.**

Nothing in the mathematics changed. v3 is v2 with the files the paper describes, plus a
manifest that now carries byte counts so a reader can check at a glance whether the file
they downloaded is the one the paper means.

### What v2 added, and v3 preserves

Four statements that v1 listed as *argued* or *admitted* are proved and kernel-audited in
Lean 4 / Mathlib v4.32.0 — the reality of the gamma-factor defect on σ = ½, the conjugation
symmetry of ζ′/ζ, and the parity of the two coefficients in *t*. Each reports
`[propext, Classical.choice, Quot.sound]` under `#print axioms`: no `sorryAx`, no
`native_decide`. None uses any information about the location of the zeros of ζ.

The single remaining admitted statement, `reflection_law`, is reduced to one classical
input, with its route through `completedRiemannZeta_one_sub` and its side conditions written
out. §5.5 states the category obstruction plainly: the adele class space is not a smooth
manifold, so the adelic assembly is a formal dictionary rather than a contact manifold. §7.4
compares the Deninger, Meyer, Bost–Connes and Connes–Consani–Marcolli programmes with
verified citations, and credits the thermodynamic contact lineage — lifting a 2D state space
to a 3D contact manifold carrying c dU − g dV is the standard construction of contact
thermodynamics, not something introduced here.

### What this paper does not do

**RH itself is untouched.** This is a translation dictionary, not a proof. §4.6 states which
claims are proved, which machine-checked, which classical, and which numerical only.

---

### Files (seven, and only these)

`rh_arithmetic_contact_v3.pdf` · `RH_arithmetic_contact_structure.md` ·
`ZetaReflection.lean` (11,344 bytes) · `RELATED-WORK.md` ·
`verify_reflection_laws.py` · `figures.py` · `fig1_rh_lift.pdf` · `fig1_rh_lift.png`

Do **not** re-upload `rh_arithmetic_contact_v1.pdf` or any `_1.md` duplicate. v1 remains
permanently at its own DOI.

**Keywords:** Riemann Hypothesis · contact geometry · adele class space · von Mangoldt
function · Riemann–Siegel theta · Weil explicit formula · Connes spectral triple ·
contact thermodynamics · Lean 4 · formal verification · Principia Orthogona

**MSC:** 11M26 · 53D10 · 11R56 · 81Q10 · **Licence:** CC BY 4.0
