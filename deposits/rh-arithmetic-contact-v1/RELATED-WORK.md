# Related work — verified citations

Assembled 2026-08-30 from a Gemini session's prior-art answer, **after checking
each reference**. Two were wrong as given; both are corrected below. Nothing
here entered the paper on trust.

## Verified

| Work | Reference | Where it stops |
|---|---|---|
| Connes, *Trace formula in noncommutative geometry and the zeros of the Riemann zeta function* | **Selecta Math. (N.S.) 5 (1999)** ✔ as cited | The spectral realisation gives an absorption spectrum at the zeros, but eliminating unwanted spectrum needs a global positivity/trace condition equivalent to RH. |
| Bost–Connes, *Hecke algebras, type III factors and phase transitions with spontaneous symmetry breaking in number theory* | **Selecta Math. (N.S.) 1 (1995)** ✔ as cited | Encodes primes as KMS states with a phase transition at β = 1; makes no contact with the critical strip where the zeros sit. |
| Meyer, *On a representation of the idele class group related to primes and zeros of L-functions* | **Duke Math. J. 127 (2005)** ✔ as cited | Self-adjointness of the generator is structurally Weil positivity again. |
| Deninger, *Some analogies between number theory and dynamical systems on foliated spaces* | **Documenta Math., Extra Vol. ICM I (1998), 163–186** — cited to *Ergod. Th. & Dynam. Sys.*, **corrected** | The foliated space carrying the ℝ-action with the right trace formula has never been constructed; the operators remain hypothetical. |
| Connes–Consani–Marcolli, *The Weil proof and the geometry of the adeles class space* | attributed to **Consani–Marcolli, Adv. Math. 2006**; it is **Connes–Consani–Marcolli**, **corrected** | Transports the Weil proof's geometry to the adele class space; the positivity that closes the function-field case has no number-field analogue. |

## Not mentioned by Gemini, and directly on point

- **"On a relation between Deninger's foliated dynamical systems and Connes–Consani's adelic spaces"**, arXiv:2508.15971 (2025). It connects precisely the two programmes this paper sits between. Read before the next revision.
- Consani–Marcolli, *Non-commutative geometry, dynamics, and ∞-adic Arakelov geometry*, arXiv:math.AG/0205306 (Selecta Math. 2004).

## Claims rejected in the audit

- **"A_Q/Q^× is a compact, connected topological group (a solenoid)."** No. Q^×
  acts multiplicatively on A_Q, which has zero divisors, so the quotient **is not
  a group** — the idele class group A_Q^×/Q^× is. It is also not compact, and it
  is the *bad*, non-Hausdorff quotient that motivated Connes to leave the
  commutative category. The same session had called it non-Hausdorff one answer
  earlier. Do not cite this description.
- **A trace expression of the form `Tr_ω(π(α)[D,α]²)`** offered as the
  noncommutative meaning of `α ∧ dα ≠ 0`. Not a standard expression; no source
  found. Treat as invented.
- **Berkovich "skeletal graph (tietze/tree representation)"**. The Tietze
  theorem is an extension theorem in general topology and has nothing to do with
  Berkovich skeleta. Invented detail.
- **Novelty claims** for the lift, the two-coefficient form, and the one-sided
  pole. Offered as "Unremarked / Novel" — a label invented to avoid saying
  *I do not know*, which is what an unsearched novelty claim is. **No novelty
  claim goes into the deposit without a literature search someone actually ran.**
  A referee checks novelty first, and a wrong novelty claim costs more than a
  wrong lemma.

## What survived and was used

The **route to `reflection_law`** — once corrected to include the parity step,
it is right, and it matches what is now proved in `ZetaReflection.lean`
(`gCoef_odd_in_t`). One caveat carried into the file: that route writes
`g = Im(−ζ'/ζ)`, but this corpus defines `g = Im(+ζ'/ζ)` with only `c` carrying
the minus sign. The asymmetry is deliberate; using Gemini's sign flips the
identity.

## Correction to the proposed Lean route (2026-08-30)

A Gemini session proposed closing `reflection_law` via Mathlib's
`riemannZeta_one_sub`, calling it "strictly local — `HasDerivAt.log` and the
chain rule". That names the wrong functional equation.

`riemannZeta_one_sub` is the **asymmetric** form,
`ζ(1−s) = 2(2π)^(−s) Γ(s) cos(πs/2) ζ(s)`, whose logarithmic derivative is
`−log(2π) + ψ(s) − (π/2)tan(πs/2)` — not this corpus's `chiLog`. Converting
between them requires Legendre duplication and Euler reflection for Γ.

Use `completedRiemannZeta_one_sub : Λ(1−s) = Λ(s)` instead, with
`Λ(s) = π^(−s/2)Γ(s/2)ζ(s)`. Taking `logDeriv` of both sides and applying
`logDeriv_mul` twice gives `ζ'/ζ(s) + ζ'/ζ(1−s) = chiLog s` directly. Verified
numerically to 30 digits (mpmath) at s = 0.7+14.3i, 0.3+25.1i, 1.4+6.2i.

Also noted: the session's stated *Goal* line and its closing parenthetical both
give `g(σ,t) + g(1−σ,t) = −Im[χ'/χ]`, which contradicts its own step 5. The
body derivation is correct; the header and the aside are not.

## Second audit round (2026-08-30, evening)

A further bibliography arrived from the same source. Four more entries wrong:

| given | actual |
|---|---|
| Bost–Connes, *"…and arithmetical dynamical systems"* | *"…and phase transitions with spontaneous symmetry breaking in number theory"*, Selecta Math. **1** (1995), 411–457 |
| Deninger, *"Some analogies between number theory and topology"* | *"…and dynamical systems on foliated spaces"*, Documenta Math., Extra Vol. ICM I (1998), 163–186 |
| Meyer, *"…related to prime numbers"* | *"…related to primes and zeros of L-functions"*, Duke Math. J. **127** (2005); arXiv:math/0311468 |
| Mrugała, *"Continuous contact transformations in thermodynamic phase space"*, Rep. Math. Phys. **29**(1) (1990), 117–129 | *"Continuous contact transformations in thermodynamics"*, Rep. Math. Phys. **33** (1993), 149–154 |

Also corrected here: **Morishita is arXiv 2508, i.e. August 2025, not 2026.** That was my
own error in the first audit round, not the source's.

Left uncited because they could not be verified: a second Deninger paper on Γ-factors of
regularized determinants, and two Consani–Marcolli / Connes–Consani–Marcolli entries whose
titles, journals and years did not agree with anything found.

### The one that mattered
Mrugała, despite the wrong citation, was the most important item of the day.
**The lift of a 2D state space to a 3D contact manifold carrying `c dU − g dV` is the
standard construction of contact thermodynamics** — the Gibbs form on the extended state
space, with equations of state as Legendre submanifolds. The paper does not introduce that
geometry, it applies it. §7.4 now says so and cites it, and the novelty claims that were
provisionally attached to the lift are withdrawn.

**Ryszard Mrugała**, Department of Mathematical Physics, Nicolaus Copernicus University,
Toruń. Also: *On contact and metric structures on thermodynamic spaces*, RIMS Kôkyûroku
**1142** (2000).
