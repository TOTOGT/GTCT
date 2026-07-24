# Nested Infinities

### A Theorem Book on Self-Referential Hierarchies in Set Theory, Ordinal Arithmetic, and the Surreal Numbers — With a Conjectural Extension to the dm³ Operator Chain

**Pablo Nogueira Grossi**
G6 LLC · Newark, NJ
*Principia Orthogona*, companion volume
AXLE formalization: Lean 4 + Mathlib4 · github.com/TOTOGT/GTCT

---

## Abstract

We collect, in one place and with a single consistent epistemic ledger, the
mathematics that "nested infinities" actually refers to across four
classical constructions — Cantor's cardinal hierarchy, the ordinal number
line and its epsilon numbers, Conway's surreal numbers, and Gödel's
incompleteness theorems — and we distinguish sharply between what is
**PROVED** (machine-checked in Lean 4 against Mathlib4, cited in this
paper), what is **CITED** (a classical result we rely on but do not
re-derive), and what is **CONJECTURAL** (the proposed identification of
these structures with the dm³ operator chain G = U∘F∘K∘C from the
*Principia Orthogona* series, first asserted informally in Book 3, Ch. 8).
Part A is a correct, citable account of nested infinities in standard
mathematics. Part B states precisely what would need to be true for the
dm³ identification to become a theorem rather than an analogy, and
records the specific open problems — as AXLE Issues — that block it.

**Ledger legend:** PROVED (Lean-checked, cited by file/theorem name) ·
CITED (established in the literature, not re-derived here) · CONJECTURAL
(asserted without proof, explicitly flagged) · PROVE-ME (a concrete,
stated open problem).

---

## Part A — Standard Mathematics

### Chapter 1. Cantor's Theorem and the Cardinal Hierarchy

**1.1 The theorem.** For any set $S$, $|\mathcal{P}(S)| > |S|$. Equivalently,
for any cardinal $a$, $a < 2^a$. **[PROVED — `NestedInfinities.cantor_step`,
citing Mathlib's `Cardinal.cantor`.]**

*Proof idea (the diagonal argument).* Suppose $f : S \to \mathcal{P}(S)$ is
surjective. Let $D = \{ x \in S : x \notin f(x)\}$. Since $f$ is surjective,
$D = f(d)$ for some $d \in S$. Then $d \in D \iff d \notin f(d) = D$,
a contradiction. Hence no surjection $S \to \mathcal{P}(S)$ exists, so
$|\mathcal{P}(S)| \neq |S|$; combined with the trivial injection
$S \hookrightarrow \mathcal{P}(S)$, $x \mapsto \{x\}$, this gives
$|S| < |\mathcal{P}(S)|$.

**1.2 No largest cardinal.** There is no cardinal $a$ with $b \le a$ for all
cardinals $b$. **[PROVED — `NestedInfinities.no_largest_cardinal`.]** This
is the formal content of "the staircase has no top": take $b = 2^a$ and
apply Theorem 1.1.

**1.3 The first rung.** $\aleph_0 < 2^{\aleph_0}$ (the continuum).
**[PROVED — `NestedInfinities.aleph0_lt_continuum`.]** No separate diagonal
argument is needed; this is Theorem 1.1 instantiated at $a = \aleph_0$.

**1.4 The iterated staircase.** Define $a_0 = a$, $a_{n+1} = 2^{a_n}$. Then
$(a_n)_{n \in \mathbb{N}}$ is strictly increasing, for any starting
cardinal $a$. **[PROVED — `NestedInfinities.iteratedPower_strictMono`.]**
This is the precise statement behind any informal "vocabulary < grammar <
discourse mastery" cardinality picture: each step is a genuine application
of Cantor's theorem, not a metaphor.

**1.5 What this does *not* license.** Theorem 1.4 says the sequence
$a, 2^a, 2^{2^a}, \dots$ is strictly increasing for a fixed starting
cardinal $a$. It says nothing about *which* infinite sets in the world
(vocabularies, grammars, discourse communities) have which of these
cardinalities, nor that any specific empirical transition between them is
a "cardinality jump" in this technical sense. That identification, where
made elsewhere in this series, is CONJECTURAL and pedagogical, not a
corollary of Cantor's theorem.

---

### Chapter 2. Ordinal Numbers and Epsilon Numbers

**2.1 Successor and limit ordinals.** $\omega$, the first infinite
ordinal, is a limit ordinal: it is not the successor of any ordinal.
**[PROVE-ME — `NestedInfinities.omega0_not_succ`, currently `sorry`,
AXLE Issue #21. The mathematics is completely standard; the gap is purely
in locating or re-deriving the exact Mathlib4 lemma.]**

**2.2 Beyond $\omega$.** $\omega < \omega + 1$. **[PROVED —
`NestedInfinities.omega0_lt_omega0_succ`, via `Order.lt_succ`.]** The
stronger and more illustrative fact $\omega < \omega + \omega$ needs
right-strict-monotonicity of ordinal addition and is currently
**[PROVE-ME — AXLE Issue #22.]**

A note on what this hierarchy measures: $\omega + \omega$ and $\omega$
have the *same* cardinality ($\aleph_0$) but *different* order types. The
ordinal and cardinal hierarchies of Chapters 1–2 are independent axes; a
number can climb arbitrarily far up the ordinal line while never leaving
$\aleph_0$.

**2.3 Epsilon numbers.** An ordinal $e$ is an *epsilon number* if
$\omega^e = e$ — a fixed point of ordinal exponentiation base $\omega$.
$\varepsilon_0$, the least epsilon number, is the supremum of the tower
$\omega, \omega^\omega, \omega^{\omega^\omega}, \dots$
**[CITED — classical, e.g. Gentzen 1936.]** Its existence as a Lean
theorem, `NestedInfinities.exists_epsilon0`, is currently
**[PROVE-ME — AXLE Issue #20]**: this needs either an explicit
supremum construction or a general fixed-point-of-normal-functions theorem.

**2.4 Proof-theoretic content.** $\varepsilon_0$ is exactly the ordinal
measuring the strength of Peano Arithmetic: PA proves transfinite induction
below $\varepsilon_0$ but not at $\varepsilon_0$ itself (Gentzen's
consistency proof). **[CITED — not attempted in Lean here; a full formal
treatment would require formalizing PA's proof theory, well beyond this
paper's scope.]**

---

### Chapter 3. Conway's Surreal Numbers

**3.1 The construction.** Starting from $0 = \{\,|\,\}$, each "day" $n$
produces new numbers $\{L \mid R\}$ from numbers already constructed,
subject to $\ell < r$ for all $\ell \in L, r \in R$. By day $\omega$,
all integers exist simultaneously; the construction continues
transfinitely. **[CITED — Conway 1976; Mathlib4 formalizes the resulting
type `Surreal` and its order/field structure, but not, to my knowledge,
the day-indexed recursive construction itself as a named object.]**

**3.2 Universality.** $\mathbf{No}$ (the class of all surreal numbers) is
the unique universal ordered field: every ordered field embeds in it.
**[CITED — Conway 1976; Alling 1987. Not formalized in Mathlib4 at the
time of writing.]**

**3.3 $\omega$ and $\varepsilon$.** There exists a surreal number greater
than every natural number, and a positive surreal number smaller than
every positive rational. **[PROVE-ME —
`NestedInfinities.exists_surreal_gt_all_nat`, AXLE Issue #23;
`NestedInfinities.exists_positive_infinitesimal`, AXLE Issue #24. Both are
true and constructible directly from Conway's Day-$\omega$ number, but I
have not located ready-made Mathlib statements and have not re-derived
them from scratch here.]**

**3.4 What "surreal isomorphism" would require of any other structure.**
For any mathematical object $X$ to be claimed isomorphic to $\mathbf{No}$
(or an order-embedding into it), one needs (i) an order on $X$, (ii) a map
$X \to \mathbf{No}$, and (iii) a proof the map is an order-embedding (or
isomorphism, if onto a specific sub-field). Asserting an isomorphism
without supplying these three ingredients is not yet a mathematical claim
— it is a hoped-for one. This standard is stated explicitly because
Part B needs it.

---

### Chapter 4. Gödel's Incompleteness Theorems

**4.1 First incompleteness theorem.** Any consistent, recursively
axiomatizable formal system $S$ powerful enough to encode arithmetic
contains a sentence $G_S$ that is true (in the standard model) but not
provable in $S$. **[CITED — Gödel 1931. Full formalization of
incompleteness for a specific system is a major undertaking — see the
Lean/Mathlib `Incompleteness` efforts and the independent Isabelle/HOL and
Coq formalizations by O'Connor and others — and is out of scope for this
paper's Lean files.]**

**4.2 Second incompleteness theorem.** No such $S$ can prove its own
consistency (assuming $S$ is in fact consistent). **[CITED — Gödel 1931.]**

**4.3 What this does and does not say about "nested" hierarchies.**
Gödel's theorems produce, for each consistent $S$, a *specific* true
sentence unprovable in $S$; moving to $S' = S + G_S$ produces a new
unprovable sentence $G_{S'}$, and so on transfinitely (this iterated
process is itself measured by ordinals — Turing's 1938 ordinal logics, and
ultimately by $\varepsilon_0$-scale proof theory for arithmetic
specifically). **[CITED — Turing 1938; Feferman 1962 on transfinite
progressions.]** This is a genuine, well-studied "nested" structure and is
the most defensible bridge between Chapters 2 and 4 in this book. It is
*not*, without further argument, evidence that any other self-referential
system (a learner, a pedagogical operator chain) has the same structure —
that identification would need its own proof, supplied on its own terms.

---

## Part B — The Conjectural Extension: dm³ and the Operator Chain

### Chapter 5. What Theorem 8.1 Would Need

*Principia Orthogona*, Book 3 ("The Mini-Beast"), Chapter 8, states
"Theorem 8.1 — Nested Orthogenesis": that $G = U \circ F \circ K \circ C$,
iterated on itself, converges to a fixed point $G_\infty$ that is
simultaneously (1) Banach-reachable, (2) Gödelian, (3) isomorphic to
$\mathbf{No}$, and (4) identified with the Mandelbrot set's phase
portrait. As presented there, this is explicitly framed as a pedagogical
claim for students to interrogate and attempt to falsify, not a proved
research result — see Ch. 8's inquiry prompt and Falsifiability section.
This chapter takes that invitation at face value and asks what a genuine
proof would require.

**5.1 The blocking question.** None of (1)–(4) is well-posed until
$C, K, F, U$ are defined as actual functions on an actual space $X$. The
three candidate choices of $X$ implicit in the *Principia Orthogona*
series so far — a metric space of learner/theory states (needed for (1)),
a space of formal systems (needed for (2)), and $\mathbf{No}$ itself
(needed for (3)) — are not obviously the same space, and no single
definition of $C, K, F, U$ in the existing corpus (including the Chapter
10 contact-manifold ODE, where $C, K, F, U$ label *stages of a single
concrete flow*, not compositional factors of it) currently serves all
four simultaneously. **[This is the paper's central open problem —
AXLE Issue #26.]**

**5.2 A precise, weaker, and possibly provable substitute.** Rather than
asserting all four simultaneously, we propose the four parts be pursued
as *independent* theorems, each with its own hypotheses stated explicitly:

- **(1) Convergence.** Given an explicit metric space $X$ and an explicit
  Lipschitz bound $k < 1$ for $G$ on $X$, existence and uniqueness of
  $G_\infty$ follows immediately from Banach's fixed-point theorem (already
  in Mathlib). The mathematics is not in question; the missing ingredient
  is $X$ and the bound. **[Lean skeleton:
  `NestedInfinities.GTCT.fixedPoint_of_contracting`, hypothesis unfilled,
  AXLE Issue #25.]**
- **(2) Gödelian structure.** This requires $X$ to be (or encode) a formal
  system rich enough for diagonalization, and $G_\infty$ to be shown
  equivalent to (or to encode) such a system. No candidate encoding is
  proposed here; this is a genuinely open design problem, not a proof gap.
- **(3) Surreal isomorphism.** Requires an explicit order on $X$ and an
  explicit order-embedding $X \to \mathbf{No}$ — see §3.4's checklist.
- **(4) Mandelbrot identification.** Requires $X$ to carry (or be shown
  equivalent to) a one-complex-parameter family indexed by $c$, with $G$
  corresponding to the map $z \mapsto z^2 + c$ under some explicit
  correspondence — again, no such correspondence is currently proposed.

**5.3 Falsifiable predictions carried over from Ch. 8.** The three
falsifiable predictions already stated in Book 3, Ch. 8 (on finite-state
grammar, L2-vs-native teacher outperformance at B1–B2, and formal-system
self-consistency) stand as originally written and are not restated here;
they concern the *pedagogical* analogy, not the formal claims of this
chapter, and should be evaluated on their own terms.

---

### Chapter 6. AXLE Issue Ledger for This Volume

| Issue # | Statement | File | Status |
|---|---|---|---|
| #20 | $\varepsilon_0$ exists as least fixed point of $\omega^{(\cdot)}$ | `Ordinal.lean` | open |
| #21 | $\omega$ is not a successor ordinal | `Ordinal.lean` | open (likely quick — locate Mathlib lemma) |
| #22 | $\omega < \omega + \omega$ | `Ordinal.lean` | open (needs right-monotonicity lemma) |
| #23 | A surreal number exceeds every natural number | `Surreal.lean` | open |
| #24 | A positive surreal infinitesimal exists | `Surreal.lean` | open |
| #25 | Banach fixed point for $G$, given an explicit contraction hypothesis | `GTCT.lean` | blocked on §5.1/§B.0 |
| #26 | Choose $X$ and define $C, K, F, U : X \to X$ concretely | `GTCT.lean` | **the** blocking design question |

None of these are claimed closed. This table is the honest current state
of the formalization, to be updated as issues close.

---

## References

[1] Cantor, G. (1874/1891). Diagonal argument; power set theorem.
[2] Gödel, K. (1931). *Über formal unentscheidbare Sätze der Principia
    Mathematica und verwandter Systeme I.*
[3] Gentzen, G. (1936). Consistency proof for Peano Arithmetic via
    transfinite induction up to $\varepsilon_0$.
[4] Turing, A. (1938). *Systems of Logic Based on Ordinals.*
[5] Conway, J. H. (1976). *On Numbers and Games.*
[6] Alling, N. (1987). *Foundations of Analysis over Surreal Number
    Fields.*
[7] Feferman, S. (1962). Transfinite recursive progressions of axiomatic
    theories.
[8] Mathlib Community (2024–2026). *Mathlib4*, mathlib4_docs.
[9] Grossi, P. N. (2026). *Principia Orthogona*, Book 3 ("The
    Mini-Beast"), Ch. 8: Nested Infinities. doi:10.5281/zenodo.20719399.

---

*G6 LLC · Newark, NJ · MIT License · This is a draft. AXLE Issues #20–#26
are open and their resolutions (or continued non-resolution) should be
reflected in the next revision before deposit.*
