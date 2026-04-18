# GCTC Lean 4 Project — Code Review

**Reviewer:** Cowork (review-only pass)
**Scope:** `Compress.lean`, `Threshold.lean`, `Fold.lean`, `Unfold.lean`, `Chain.lean`
**Date:** 2026-04-18

## Summary

The five files define the G-chain `G = U ∘ F ∘ K ∘ C` with clean, minimal primitive-operator structures and state three AXLE proof obligations. The code is stylistically consistent and reasonably documented. However, there are **two substantive correctness issues** in `Chain.lean` (the `gronwall_bound` statement is provably false as written, and `spiral_return_exists` is vacuously sorry-able but logically stronger than intended), one **semantic gap** in `Threshold.lean` (the `cutoff` field is orphaned — unused by any axiom), and several minor style / API issues across the modules. A separate update of `Chain.lean` ships alongside this review, replacing the symmetric `ε₀ = 1/3` Gronwall claim with the asymmetric-basin formulation that matches your dm³ numerics.

The table below summarises severity.

| Severity | File | Issue |
|---|---|---|
| **High (bug)** | `Chain.lean` | `gronwall_bound` hypothesis `μ_max + 3ε < 0` is insufficient; the stated inequality fails for large *t* unless `μ_max + 3ε ≤ -ε₀`. |
| **High (design)** | `Chain.lean` | `SpiralReturn.not_fixed` makes T1 *false* for contracting chains that converge to a fixed point. `not_fixed` should be a hypothesis on the chain, not a field of the witness. |
| **High (paper↔code)** | `Chain.lean` | `ε₀ = 1/3` contradicts the dm³ numerics (empirical inner boundary r\* ≈ 0.8; no finite outer radius). |
| **Medium (design)** | `Threshold.lean` | `cutoff` field is not related to `apply` by any axiom — trivially satisfied by `apply = id`. |
| **Medium (design)** | `Fold.lean` | `contracts` does not force `apply attractor = attractor`; slightly weaker than intended. |
| **Low (style)** | `Unfold.lean` | `dist_nondecreasing` proves *strict* increase; name is misleading. |
| **Low (API)** | `Compress.lean` | `isLipschitz` is stated in terms of `LipschitzWith` but the field uses `‖·‖`; needs explicit dist/edist bridge. |
| **Low (math)** | `Threshold.lean` | `softThreshold` has no `0 ≤ c` precondition baked in; it is used in `softThreshold_neg`'s hypothesis but the definition itself degenerates for `c < 0`. |

---

## 1. `Compress.lean`

### Design

`Compressor` bundles a map with a Lipschitz constant. The two hypotheses `ratio < 1` (strict contraction) and `0 ≤ ratio` (non-negative) are both right. The `lipschitz` field is phrased in terms of the norm `‖·‖`, which is the natural choice for a `SeminormedAddCommGroup`.

### Issues

1. **The `isLipschitz` sorry is harder than the "AXLE" comment suggests.** `LipschitzWith K f` in Mathlib is defined via `edist`, not `dist` or `‖·‖`. Converting requires `edist_eq_coe_nndist` and `ENNReal.coe_le_coe`. A cleaner approach is `LipschitzWith.of_dist_le_mul` (or, newer, `LipschitzWith.mk_one_div_le` variants). Proposed proof sketch:

   ```lean
   theorem isLipschitz {X : Type*} [SeminormedAddCommGroup X]
       (C : Compressor X) : LipschitzWith ⟨C.ratio, C.ratio_nn⟩ C.apply := by
     refine LipschitzWith.of_dist_le_mul (fun x y => ?_)
     simpa [dist_eq_norm] using C.lipschitz x y
   ```

   If this doesn't typecheck directly, the conversion boils down to `dist x y = ‖x - y‖` in a seminormed group (via `dist_eq_norm`) plus the coercion `NNReal → ℝ`.

2. **Naming.** Project-wide, consider `Compressor.lipschitz_apply` or `Compressor.isLipschitzWith_ratio` for clarity — the bare `isLipschitz` hides the ratio.

3. **No structure on `X` beyond `SeminormedAddCommGroup`.** If you later need a fixed point (e.g., for a Banach-style iteration argument in T1), you will want to require `CompleteSpace X` at the theorem level, not the structure level.

---

## 2. `Threshold.lean`

### Design

`Thresholder` carries three fields: `apply`, `cutoff : ℝ`, and `idem`. Soft-threshold is defined non-computably (correctly — it involves `ite` on real inequalities).

### Issues

1. **`cutoff` is an orphan.** Nothing in the structure connects `cutoff` to `apply`. The instance `⟨id, 1, fun _ => rfl⟩` satisfies the structure — with `apply = id` and `cutoff = 1`, but `id` is clearly not thresholding anything. Recommended fix:

   ```lean
   structure Thresholder (X : Type*) [Zero X] [Norm X] where
     apply : X → X
     cutoff : ℝ
     cutoff_nn : 0 ≤ cutoff
     /-- Below the cutoff, the output is zero. -/
     below_cutoff : ∀ x, ‖x‖ < cutoff → apply x = 0
     idem : ∀ x, apply (apply x) = apply x
   ```

   This ties `cutoff` to observable behaviour. Alternatively, if you want to stay abstract, drop `cutoff` from the structure entirely.

2. **`softThreshold` degenerates for `c < 0`.** If `c = -1` and `x = 0`, then `x > c` is true, so the function returns `0 - (-1) = 1`. Clearly undesired. Either:
   - Require `0 ≤ c` in the definition (`softThreshold` becomes a `Function ℝ₊ → ℝ → ℝ`), or
   - Document the precondition explicitly and push it to callers (current approach, but the lemma `softThreshold_neg` silently assumes it).

3. **`softThreshold_neg` proof.** `split_ifs with h1 h2 h3 h4` generates 4 × 2 = 8 or more cases. The `push_neg at * ; linarith` closer is robust but opaque. Consider `split_ifs <;> simp_all <;> linarith` — or split it into named cases with comments showing which case each branch corresponds to (useful when the proof breaks under Mathlib updates). Either way, the proof as written typechecks and is correct.

4. **Idempotence of `softThreshold` is not proved here.** The `Thresholder` structure needs an `idem` witness to instantiate, so somewhere you will eventually need `softThreshold_idem : softThreshold c (softThreshold c x) = softThreshold c x`. This is true but requires a proof. Worth adding.

---

## 3. `Fold.lean`

### Design

`Folder` carries `apply`, an `attractor : X`, and a `contracts` field stating that each application strictly decreases distance to the attractor (or `x = attractor` already). The `iter` definition is tail-recursive and clean.

### Issues

1. **`contracts` does not force `apply attractor = attractor`.** Because the `x = attractor` disjunct fires for the input `x = attractor` regardless of what `apply attractor` is, you could have e.g. `apply attractor = y` with `y ≠ attractor` and a strictly-larger distance, yet the structure is still inhabited. This is almost certainly unintended: an attractor should be a fixed point. Proposed fix:

   ```lean
   structure Folder (X : Type*) [MetricSpace X] where
     apply : X → X
     attractor : X
     fixed : apply attractor = attractor
     contracts : ∀ x : X, x ≠ attractor →
                 dist (apply x) attractor < dist x attractor
   ```

   This is equivalent to the current axioms *plus* the fixed-point condition.

2. **`iter` direction.** `Folder.iter F (n+1) x = Folder.iter F n (F.apply x)` — this folds "from the left," i.e., `iter F n x = F^n x` where `F` is applied `n` times. That's fine, but note that this is the *opposite* direction from `Nat.iterate`, which is `Nat.iterate f (n+1) x = f (Nat.iterate f n x)`. Neither is wrong, but mixing conventions in a project is a source of confusion. Consider using `Nat.iterate F.apply n x` directly and dropping the custom `iter`.

3. **No lemmas on `iter`.** `Folder.iter_zero`, `Folder.iter_succ`, and a monotonicity lemma `dist (iter F n x) attractor ≤ dist x attractor` (weak) or a strict-decrease lemma for `x ≠ attractor` would be standard companions. They would all be short `by` blocks.

---

## 4. `Unfold.lean`

### Design

The file is a near-mirror of `Fold.lean`: `seed` replaces `attractor`, `expands` replaces `contracts`, and strict `>` replaces strict `<`.

### Issues

1. **`dist_nondecreasing` is a misnomer.** The lemma proves `dist (U.apply x) U.seed > dist x U.seed` — strictly greater, not merely non-decreasing. Rename to `dist_strictIncreasing` or `dist_apply_gt` to reflect what's actually proved.

2. **Same fixed-point gap as Fold.** `U.apply seed` is unconstrained. Symmetrically:

   ```lean
   fixed : apply seed = seed
   expands : ∀ x : X, x ≠ seed → dist (apply x) seed > dist x seed
   ```

3. **Symmetry with Fold could be enforced via a common structure.** Both `Folder` and `Unfolder` are "contractions/expansions relative to a distinguished point with a fixed-point condition." You could introduce a single `PointwiseFlow` structure parameterised by `Ordering` (or a sign), and derive `Folder`/`Unfolder` as specializations. This is a refactoring suggestion, not a correctness issue.

---

## 5. `Chain.lean` — the substantive issues

### 5.1. `gronwall_bound` is **false as stated**

Current statement:

```lean
theorem gronwall_bound
    (μ_max ε : ℝ) (hε : ε < ε₀) (hμ : μ_max + 3 * ε < 0) :
    ∃ C : ℝ, C > 0 ∧ ∀ t : ℝ, t ≥ 0 →
      Real.exp ((μ_max + 3 * ε) * t) ≤ C * Real.exp (-ε₀ * t) := by
  sorry
```

The hypothesis `μ_max + 3ε < 0` only ensures the left-hand side decays; it does not ensure it decays *faster* than `exp(-ε₀ · t)`. Take `μ_max = -0.01`, `ε = 0.01`. Then `μ_max + 3ε = 0.02` — still positive, wait: `-0.01 + 0.03 = 0.02`, which *violates* `hμ`. Take instead `μ_max = -0.1`, `ε = 0.01`. Then `μ_max + 3ε = -0.07 < 0` ✓ and `ε < ε₀ = 0.33` ✓. But `-ε₀ = -0.33` and `μ_max + 3ε = -0.07 > -0.33`, so for large *t*, `exp(-0.07 · t)` grows (relative to `exp(-0.33 · t)`) without bound. No constant `C` bounds the ratio.

**Correct hypothesis:** `μ_max + 3 * ε ≤ -ε₀` (or `< -ε₀` for strict inequality, but equality is enough for the bound with `C = 1`). With that hypothesis, the proof becomes `C := 1; by intro t ht; gcongr; linarith`. I included a corrected version in the companion `Chain_updated.lean`.

### 5.2. `SpiralReturn.not_fixed` makes `spiral_return_exists` too strong

If `G` is a genuine contraction converging to a fixed point `p`, then for any starting point `x₀`, the iterates satisfy `G^{64}(x₀) ≈ p ≈ G^{64}(G^{64}(x₀))` — so `x₀' ≠ x₀` may hold (initial ≠ limit), but if we take `x₀ = p` itself then `x₆₄ = x₀' = p = x₀`, contradicting `not_fixed`. So the theorem `spiral_return_exists` as stated claims, for *every* chain `G`, that *some* initial point `x₀` gives a non-trivial 128-orbit. That is only true for chains that have "room" (e.g., multiple fixed points, or no fixed point at all) — it is false for a single-fixed-point contraction on a non-trivial space.

**Fix:** add a hypothesis to the theorem that guarantees non-triviality, e.g. a seed and an attractor are distinct, and formalise T1 as: "for such chains, a SpiralReturn exists." Or move `not_fixed` out of `SpiralReturn` and into the theorem hypothesis.

### 5.3. The ε₀ = 1/3 Gronwall bound conflicts with the dm³ numerics

Per `FINDINGS.md` (and validated by the fresh numerics run for the SBM submission, which reproduced the stability sweep to 3 decimals), the symmetric-ball stability estimate `|r - 1| < ε₀ = 1/3` is **not observed**. Specifically:

- `r(0) = 0.667` (exactly the Gronwall boundary on the inner side) **collapses** to `z → -∞` at `t ≈ 1.3`.
- The empirical inner-basin boundary is `r_* ≈ 0.8 > 1 - ε₀ = 0.667`.
- On the outer side, no finite stability radius is observed — trajectories with `r(0) = 2.5` still converge to `r = 1`.

The companion `Chain_updated.lean` therefore replaces `ε₀` with a named inner-basin boundary `r_star : ℝ ≈ 0.8` and reformulates the outer-basin claim as "no finite radius," matching the dm³ evidence. The `gronwall_bound` theorem statement is also corrected per 5.1.

### 5.4. Minor issues

- **`GSeries` order.** The `LE GSeries` instance is fine as a raw relation, but without a `Preorder GSeries` or `DecidableEq`-based `≤`, downstream `Decidable (a ≤ b)` lemmas will not fire. Add `instance : DecidableRel ((· ≤ ·) : GSeries → GSeries → Prop) := fun a b => decEq a.cycles b.cycles |> ... ` (or derive via `Nat.decLe`).
- **`poincare_collatz` phrasing.** The conclusion uses `n ≥ 33` and `dist (G^n x) (G^{n+1} x) < ε₀` (Cauchy-step). A stronger and more standard formulation is "eventually the orbit enters an ε-ball of some limit point," i.e. `∃ p n₀, ∀ n ≥ n₀, dist (G^n x) p < ε`. The current phrasing is defensible as a Cauchy criterion but is not obviously what you want for a Collatz-style stability claim.
- **`GChain.iter` direction.** Same observation as for `Folder.iter`: tail-recursion vs. Mathlib's `Nat.iterate` convention. Consider `Nat.iterate G.apply`.
- **Missing instance imports.** `Real.exp` is used but only `Mathlib.Analysis.SpecialFunctions.ExpDeriv` is imported; the non-deriv basic file is sufficient for the statement. Minor.
- **Documentation drift.** The top-comment lists obligation `(b) g-series as inductive type` as an "AXLE proof obligation," but it is already defined, not proved — it does not require a proof, only an instance or theorem tying it to the dynamics. Consider removing it from the list or reframing.

---

## Recommendations — prioritised

**Do now (blocks correctness):**

1. Apply the `Chain_updated.lean` patch (fixes 5.1, 5.3; documents 5.2 with a `TODO` comment).
2. Tighten `Thresholder` so `cutoff` is not orphaned (§2.1).
3. Add `fixed : apply attractor = attractor` to `Folder` and the analogous field to `Unfolder` (§3.1, §4.2).

**Do soon (style / API hygiene):**

4. Rename `Unfolder.dist_nondecreasing` → `dist_apply_gt` (§4.1).
5. Add `Folder.iter_zero`, `iter_succ`, `iter_dist_le` companion lemmas (§3.3).
6. Prove `softThreshold_idem` and attach a `0 ≤ c` precondition to `softThreshold` (§2.2, §2.4).
7. Refactor to use `Nat.iterate` where possible (§3.2, §5.4).

**Consider (architectural):**

8. Unify `Folder`/`Unfolder` under a `PointwiseFlow` structure (§4.3).
9. Reformulate `poincare_collatz` as an eventual-ball statement (§5.4).
10. Turn `spiral_return_exists` into a theorem with explicit non-triviality hypothesis (§5.2).

---

## Deliverables in this review

- `GCTC_REVIEW.md` (this document)
- `Chain_updated.lean` — drop-in replacement for `Chain.lean` that fixes the `gronwall_bound` statement and replaces `ε₀ = 1/3` with the asymmetric-basin formulation `r_star ≈ 0.8`, with the rest of the module preserved. Other files are not modified.

The other four files are left unchanged; the recommendations above are suggestions for a follow-up pass.
