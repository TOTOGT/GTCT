# Lean Zulip post — `#mathlib4`

**Where:** [leanprover.zulipchat.com](https://leanprover.zulipchat.com) → stream `#mathlib4` → new topic.
**Topic title:** `logDeriv Gammaℝ, and the log-derivative of the ζ functional equation`

Posted before any PR, deliberately: Mathlib's contribute page states that reviewers
will close without comment a low-quality PR produced with LLM assistance,
particularly where the author has not engaged the community first. The thread is
the gate, not a courtesy. Do not `@`-mention maintainers in the first post; the
stream is watched.

Both statements below are proved against **Lean v4.32.0 / Mathlib v4.32.0** and are
kernel-audited on `[propext, Classical.choice, Quot.sound]`. Source:
`GTCT/book4/ZetaReflection.lean`; axiom report at
`geometry/tools/verify-audit/2026-09-08/ZetaReflection.axioms.txt`.

---

## The post

I've proved a small lemma against Mathlib v4.32.0 that I think belongs in the
library, and I'd like to check where it should go before opening a PR.

```lean
theorem logDeriv_Gammaℝ (s : ℂ) (hΓ : ∀ n : ℕ, s ≠ -(2 * n)) :
    logDeriv Gammaℝ s = -(Real.log Real.pi : ℂ) / 2 + digamma (s / 2) / 2
```

It mentions only `Gammaℝ` and `digamma`, both already in Mathlib, and it's what you
need any time an archimedean factor is differentiated. The proof is `logDeriv_mul`
over `Gammaℝ_def`, with `HasDerivAt.const_cpow` for the π-power and `logDeriv_comp`
plus `digamma_def` for the Γ half. Differentiability of `Gammaℝ` comes from
inverting `differentiable_Gammaℝ_inv`, which avoids Γ's own differentiability API
entirely — that seemed worth mentioning since `Gammaℝ` has no derivative lemma of
its own.

I wanted it for this, which I've also proved and which may be the more interesting
question for the library:

```lean
theorem Zlog_add_Zlog_one_sub (s : ℂ)
    (hΓ  : ∀ n : ℕ, s ≠ -(2 * n))
    (hΓ' : ∀ n : ℕ, (1 - s) ≠ -(2 * n))
    (hζ  : riemannZeta s ≠ 0)
    (hζ' : riemannZeta (1 - s) ≠ 0) :
    logDeriv riemannZeta s + logDeriv riemannZeta (1 - s)
      = (Real.log Real.pi : ℂ) - digamma (s / 2) / 2 - digamma ((1 - s) / 2) / 2
```

The proof is `completedRiemannZeta_one_sub` differentiated: Λ(1−s) = Λ(s) holds as a
function identity, so `deriv_comp_const_sub` gives −Λ'(1−s) = Λ'(s), and dividing by
Λ(s) = Λ(1−s) turns that into `logDeriv Λ s + logDeriv Λ (1-s) = 0`. Then
`logDeriv Λ = logDeriv Gammaℝ + logDeriv ζ` on a neighbourhood, and the lemma above
finishes it.

Two things I ran into that shaped the statement:

1. `Λ = Gammaℝ · ζ` is false at the zeros of `Gammaℝ` — at `z = -2` the right side
   vanishes and `Λ(-2) = Λ(3)` doesn't — so the split is only available on a
   neighbourhood. The set where `Gammaℝ ≠ 0` is open because `1/Gammaℝ` is entire,
   which is again `differentiable_Gammaℝ_inv` doing the work.
2. The four hypotheses turn out to be *sufficient* and not merely necessary: at
   `n = 0` they give `s ≠ 0` and `s ≠ 1`, which are exactly the two points where ζ
   and Λ aren't differentiable, so no differentiability side condition has to be
   added. Without them the identity would assert equality of junk values at the
   zeros and its truth would depend on where those zeros are.

What I found already present, so I'm not asking about it:
`ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div` for `1 < s.re`;
the functional equation in three forms; and PNT+ §3.4's bounds on ζ'/ζ
(`LogDerivZetaBnd`, `ZetaInvBnd`, and the rest). I couldn't find the reflection
itself in either place, but I'd rather be told I'm looking in the wrong place than
duplicate work.

Questions:

1. Is `logDeriv_Gammaℝ` wanted, and does it belong in `Analysis/SpecialFunctions/Gamma/Deligne.lean`
   beside `Gammaℝ_def`, or somewhere else?
2. Is the four-hypothesis form right, or would you prefer the side conditions
   phrased through the `Gammaℝ` API rather than as `∀ n : ℕ, s ≠ -(2 * n)`?
3. Is anyone already doing the reflection? And if not, does it belong in Mathlib or
   in PNT+?

Happy to do the work either way.

---

## Notes for the thread, not for the post

- If asked about tooling, the answer is the same one the corpus works to: assistance
  used is not the test; the proof is mine to defend line by line. Both statements
  are on the three standard axioms and the reports are committed.
- Set the Zulip display name to a real name a reviewer can attach to an ORCID and a
  repo. Attribution on a Mathlib contribution follows the Zulip identity.
- Silence for a day or two is not rejection. Bump the topic once after about three
  days, not sooner.
- `#Is there code for X?` is the stream for a bare existence question; `#new members`
  is for first-PR mechanics once someone says yes.
