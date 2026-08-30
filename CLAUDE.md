# CLAUDE.md (pointer)

The canonical house rules for this whole computer live in:

`~/Desktop/dnls/CLAUDE.md`

Read that file before doing any non-trivial work. It covers:

- Section 0 — filesystem map (which folder does what)
- Section 3 — repo table + folder roles + the "every chapter card must convert" rule for the Book 3 site
- Sections 4–10 — house style, licensing, reproducibility, what agents must NOT do without consent, what they SHOULD flag proactively

Folder-specific notes (if any) for THIS folder will be appended below the line:

---

**This folder holds the Generative Transition / Critical Threshold proofs + Vol. V student edition.**

- Lean files appear in multiple subfolders because tarballs (`GTCT.tar.gz`, `GTCT_clean.tar.gz`) were extracted in place. Those duplicates are intentional bundles — do not dedupe across them.
- Paper PDFs (PO_10, CO_T2, OF_T2) are deposited under the Principia Orthogona series.

---

## Session log — 2026-08-30: the Lean was never kernel-checked

### The pin was unsatisfiable
`lakefile.toml` required `mathlib rev = "main"` while `lean-toolchain` said `v4.14.0`.
That combination cannot resolve. **Nothing in this repo had ever been compiled under the
pin it shipped with**, so nothing in it had ever been kernel-checked. Now pinned to
`leanprover/lean4:v4.32.0` + `mathlib v4.32.0`, matching TOTOGT/geometry. Keep the two
repos on the same pin.

### GTCTsorryFree.lean — now actually sorry-free, and kernel-audited
- The file's *name* asserted a property the file did not have: `weinberg_monotone` was a
  `sorry`. It is now proved.
- **Section 1 was false, not stale.** `V_c q c = q^3 - c*q` cannot factor as
  `(q-1)^2 (q+2) = q^3 - 3q + 2`; the two differ by the constant 2. So
  `fold_factorization_c3`, `root_at_one` and `c_star_unique` were *false statements*, not
  unproved ones. The corrected operator is `W_c q c = q^3 - c*q + (c-1)`. The true V_c
  facts are kept with a withdrawal note; the c* = 3 results are restated over W_c.
- **The matrix literals were wrong.** `T₃_sq[0][1]` is 2, not 1; `T₃_cube[1][1]` is 2,
  not 1. The old literals also fail Cayley–Hamilton, which is why that theorem would not
  close. Corrected against a numpy computation of T₃², T₃³ and T₃²+T₃+I.
- `tribSeq_14` / `tribSeq_21` were `by native_decide` — compiler-trusted, **not**
  kernel-checked — and were being counted as verified. Both are now `by decide`.
- `intermediate_value_Ioo` is a subset statement, not a three-goal `apply`;
  `tribonacci_root_in_interval` rewritten accordingly.
- A ~40-line debugging monologue was sitting inside `c_star_unique`'s proof body. Removed.

**Result: 0 errors, 0 warnings; 43/43 declarations audited with `#print axioms`.**
No `sorryAx`, no `native_decide`. 29 report exactly
`[propext, Classical.choice, Quot.sound]`; the 10 `tribSeq` values depend on no axioms at
all; the 4 `Dcrit` facts depend on a strict subset. The file's header and Section 9 now
carry the build provenance and every correction above, so a reader sees the errata rather
than a clean-looking summary.

### Stubs developed (were 12- and 13-byte placeholders)
- **`Axioms.lean`** — 8 theorems on the toy field
  `radialField r z = r(1-r²) + 2(r-1)e^(-z)`. Finding: the transverse eigenvalue at the
  cycle is `-2 + 2e^(-z)`, **not** −2. It approaches −2 only as z → +∞
  (`eigenvalue_tendsto_neg_two`) and diverges as z → −∞. The canonical μ_max = −2 is the
  z-asymptotic value, not the value on the cycle. Pages quoting −2 should say which.
- **`Lexicon.lean`** — defines `Flow` as a one-parameter semigroup and proves
  `Flow.injective` / `.surjective` / `.bijective`. Consequence to keep in view:
  **a flow is reversible, so no operator that is a flow can be a fold.** Irreversibility
  in the G = U∘F∘K∘C chain has to enter somewhere that is not a flow.

### Checked and clean
No published HTML or Markdown in GTCT or geometry quotes the incorrect T₃²/T₃³ literals —
that error lived only in the Lean file.

### Still open in this folder
- `Compress.lean`, `Threshold.lean`, `Conformal.lean` — errors not yet triaged.
- `NonCommutativity_v4.lean` — 77 errors.
- `dm3CriticalityPrinciple_extended.lean` — carries the **same false `V_c` double-root
  claim** corrected in `GTCTsorryFree.lean`. Needs the same W_c correction. This is the
  next thing to fix in this folder.
