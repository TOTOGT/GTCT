# ZENODO_DESCRIPTION_RH_V1.md
# Copy this text into the Zenodo description field for the V1 upload.

---

## The Riemann Hypothesis as Non-Integrability of an Arithmetic Contact Structure on the Adele Class Space
### Version 1 — August 2026

**Pablo Nogueira Grossi · G6 LLC, Newark NJ · ORCID: 0009-0000-6496-2186**

**V1 (this version):** https://doi.org/10.5281/zenodo.22179684
**Concept DOI** (resolves to latest): _to be filled after publication_
**Repositories:** https://github.com/TOTOGT/GTCT (Lean, this deposit) ·
https://github.com/TOTOGT/geometry (Book 4 chapters)
**Chapters this paper formalises:** Book 4 Ch 11 and Ch 12, public since 2026-06-09 —
https://totogt.github.io/geometry/book4/ch12.html

---

### What this paper does

It reformulates RH as a non-vanishing condition on an arithmetic contact 3-form on the adele
class space. The zeta function is lifted from the plane to an extended phase space by promoting
the height $t$ from a parameter to a coordinate; the resulting 1-form $\alpha_\text{arith}$
carries the von Mangoldt–Dirichlet series as its coefficient; the non-integrability condition
$\alpha \wedge d\alpha \neq 0$, automatic in the smooth ODE setting, becomes a global positivity
statement on the idele class group action.

**It is a translation dictionary, not a proof.** §4.6 states, claim by claim, what is proved,
what is machine-checked, what is classical, and what is numerical only.

### What is new here, and what is not

**New.** Two reflection laws for the form's coefficients under the functional equation:

    g(σ,t) − g(1−σ,t) =  Im[(χ′/χ)(σ+it)]      difference law
    c(σ,t) + c(1−σ,t) = −Re[(χ′/χ)(σ+it)]      sum law

verified numerically to 30 significant digits. That the simple pole of ζ′/ζ at each zero falls
**entirely into one component** of the form while the other stays analytic (Proposition 4.3).
And a **refutation** of the conjecture, stated in Book 4 §12.2, that the functional equation
acts as a contactomorphism of $\alpha_\text{arith}$ — it does not, off the critical line, and
the obstruction is an explicit gamma-factor term carrying no von Mangoldt data (Proposition 4.6).

**Not new, and credited as such in the text.** The corollary $c(½,t) = \vartheta'(t)$, with
$\vartheta$ the Riemann–Siegel theta function, is equivalent to the standard fact that
$Z(t) = e^{i\vartheta(t)}\zeta(½+it)$ is real-valued. Its role here is only to identify the
$d\tilde U$ coefficient on the critical wall with the density of the Riemann–von Mangoldt
counting formula $N(T) = \vartheta(T)/\pi + 1 + S(T)$.

### What is machine-checked, exactly

One lemma. `lseries_vonMangoldt_eq_neg_Zlog` in `ZetaReflection.lean` — that
$\sum \Lambda(n) n^{-s} = -\zeta'/\zeta(s)$ for $\Re s > 1$, hence that $c$ and $g$ are the real
and imaginary parts of one meromorphic object — proved against **Mathlib v4.32.0**, resting on
`[propext, Classical.choice, Quot.sound]` and nothing further.

**Two statements are admitted, and carry `sorryAx`:** `reflection_law` and
`chiLog_real_on_critical_line`. They are in the file as statements of record, numerically
confirmed and not proved. The file's header says so. Running
`leancheck.sh --audit ZetaReflection.lean` reports 4 declarations, 2 trusting `sorryAx`.

Nothing in this deposit bears on RH itself.

### On the figure

Figure 1 shows the lift: the same three trajectories without and with the third coordinate. The
printed version fixes one viewpoint and loses the rotation, which is most of what makes the
separation legible. The interactive version is Figure 12.1 of Book 4 Chapter 12, linked above,
and readers who want the geometry rather than a picture of it should start there.

### Files in this deposit

| File | What it is |
|---|---|
| `rh_arithmetic_contact_v1.pdf` | The paper, 13 pages |
| `RH_arithmetic_contact_structure.md` | Source of the above |
| `ZetaReflection.lean` | Lean 4 / Mathlib v4.32.0 — one lemma proved, two admitted |
| `verify_reflection_laws.py` | Reproduces all four numerical claims; exits non-zero on failure |
| `figures.py` | Regenerates Figure 1 |
| `fig1_rh_lift.pdf`, `.png` | Figure 1 |

### Build instructions

**Numerics** — reproduces every figure quoted in §4.4–§4.6:

    pip install mpmath
    python3 verify_reflection_laws.py        # ~2 min; exit 0 = all checks passed

**Figure:**

    pip install mpmath matplotlib
    python3 figures.py

**Paper:**

    pandoc RH_arithmetic_contact_structure.md -o rh_arithmetic_contact_v1.pdf \
      --pdf-engine=pdflatex -V geometry:"margin=1in" -V fontsize=11pt \
      -V colorlinks=true --toc --toc-depth=2

**Lean** — from a checkout with a complete Mathlib v4.32.0 build:

    lake env lean ZetaReflection.lean

### Open obligations

1. Prove `reflection_law` rather than admit it. Mathlib has `Complex.digamma` and
   `completedRiemannZeta_one_sub`; no contact geometry is required.
2. Prove `chiLog_real_on_critical_line` — conjugate-symmetry of digamma.
3. Determine the transformation of $\tilde U$ and $\tilde V$ themselves, without which the
   graded form of Proposition 4.6 cannot be made precise.
4. The corresponding law for the $d\tilde U$ component off the critical line.
5. Global positivity (§6). Open, and untouched by this deposit.

### Version history

**V1 (this deposit, 30 August 2026).** First deposit. The manuscript was written 10 June 2026
and revised 30 August 2026 to add §4.4–§4.6, Figure 1, and the status-of-claims table.

### Series context

*Principia Orthogona*, Book 4 (GTCT). Chapters 11–12 are the source; the framework's smooth
prototype is Book 4 Chapter 10 (helical attractors on contact 3-manifolds) and Chapter 2 (the
promotion of time to a coordinate).

---

**MSC codes:** 11M26 · 53D10 · 11R56 · 81Q10

**Keywords:** Riemann Hypothesis · contact geometry · adele class space · von Mangoldt function ·
Riemann–Siegel theta function · Weil explicit formula · Connes spectral triple · p-adic
differential forms · Lean 4 · formal verification · Principia Orthogona

**License:** CC BY-NC-ND 4.0 (paper) · MIT (code) — matching the *Principia Orthogona* series.

---

### Before publishing, check
- [ ] `python3 verify_reflection_laws.py` exits 0
- [ ] `leancheck.sh --audit ZetaReflection.lean` → 4 declarations, 2 trusting sorryAx
- [ ] The DOI in the manuscript header matches the record
- [ ] Concept DOI filled in above once the record exists
