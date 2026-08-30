# Prompt for Gemini — RH arithmetic contact paper

Use this instead of asking "how do I close the proof". That question invites a
plausible scaffold; this one asks for things that can be checked. Paste the
paper with it.

---

I am attaching a preprint that **reformulates** the Riemann Hypothesis as a
non-integrability condition on an arithmetic contact 3-form over the adele class
space. The paper is explicit that it is a translation dictionary and not a
proof: §4.6 separates what is proved, what is machine-checked in Lean, what is
classical and credited, and what is numerical only.

**Do not give me a proof strategy, a list of steps, or an outline of how to
close the gap.** I have had several of those and each one turned out to restate
the Riemann Hypothesis as one of its own steps. Assume any such plan is circular
until proven otherwise, and do not produce another.

Instead, answer these five questions. Where you do not know, say so explicitly
rather than filling the gap.

**1. Smooth structure.** Contact geometry needs `α ∧ (dα)^n ≠ 0` on a smooth
(2n+1)-manifold. The adele class space `A_Q/Q^×` is not a smooth manifold — it
is the bad quotient that motivated Connes to work in noncommutative geometry
instead. In precisely what category is the paper's `α_arith` a differential
form? Name the options (Connes' spectral triple, Deninger's dynamical system,
the Berkovich analytification, a formal/rigid-analytic structure at each finite
place, or something else), and for each say what `α ∧ dα ≠ 0` would even mean
there. If the paper's construction only makes literal sense on `R²_{U,V} × R_t`
before adelic assembly, say that plainly.

**2. Prior art, with citations.** Who has attempted to realise RH as a geometric
non-degeneracy or rigidity condition, rather than a spectral or positivity one?
I want names, papers and years — Connes 1998–1999, Deninger's foliation
programme, Meyer, Consani–Marcolli, the Bost–Connes system, and anything else.
For each, state in one sentence **where it stops**, i.e. the precise step nobody
has been able to make.

**3. The reduction test.** For any decomposition into lemmas — including a split
into "an intrinsic construction with no ζ" plus "an identification with the
ζ-built form" — apply this test and report the result: *is either lemma, taken
alone, already known to be equivalent to RH?* If yes, the split has moved the
difficulty rather than reduced it, and I want you to say so in one line rather
than elaborate the lemma.

**4. What is actually new here, if anything.** Compare the paper's specific
constructions — the lift of ζ to `R² × R_t` making t a coordinate rather than a
parameter, the two-coefficient form `α = c dŨ − g dṼ` with `c = Re(−ζ'/ζ)` and
`g = Im(ζ'/ζ)`, the one-sided pole at zeros, the identification of `c` on the
critical line with the Riemann–Siegel `θ'` — against the literature from (2).
Which of these appear elsewhere? Which look genuinely unremarked? A translation
dictionary can still be a contribution; I want to know which entries in it are
new.

**5. Small, closable obligations.** The Lean file `ZetaReflection.lean` has one
remaining `sorry`: the transformation law `g(σ,t) − g(1−σ,t) = Im[χ'/χ(σ+it)]`,
confirmed numerically to 30 digits. Ignoring RH entirely, what is the shortest
classical route to that identity from `ζ'/ζ(s) = χ'/χ(s) − ζ'/ζ(1−s)` and the
parity of `c` and `g` in `t`? Cite the standard reference for each step.

Finally, label every substantive claim you make as one of: **proved in the
literature** (with citation), **folklore/expected but unpublished**,
**my own conjecture**, or **I do not know**. An unlabelled claim I will treat as
the last category.
