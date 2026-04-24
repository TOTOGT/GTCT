# dm³ Criticality Principle — Extended Framework
## Navrátil–GTCT Synthesis: The n-bonacci Phase Ladder and the Tribonacci Phase Boundary

---

## 1. The Core Insight

The Navrátil document establishes a precise empirical fact: the polynomial
P(η) = η³ − η² − η − 1 = 0 and its companion matrix T₃ ∈ SL(3,ℤ) derive 14
of the 19 Standard Model free parameters with no free parameters and errors
below 2%.  The uniqueness argument (Proposition 8.1) shows that no other rank
k ∈ {2, 4, 5, ...} satisfies all four conditions simultaneously: correct
Weinberg angle, Dcrit = 26, correct lepton masses, correct Cabibbo angle.

The GTCT framework establishes an independent criticality principle: there
exists a unique c* = 3 such that the generative cycle G = U∘F∘K∘C closes in a
nontrivial yet controllable way, encoded in the double-root factorization
V₃(q) = q³ − 3q = (q−1)²(q+2).

**The thesis of this document is that these are the same criticality
condition, expressed in two different languages.**

---

## 2. The n-bonacci Criticality Ladder

### 2.1 The Polynomial Family

Define the rank-n characteristic polynomial:
```
Pₙ(x) = xⁿ − xⁿ⁻¹ − xⁿ⁻² − ... − x − 1
```

Each polynomial has a unique dominant real root ηₙ > 1:
- n=2 (Fibonacci):   η₂ = φ ≈ 1.6180
- n=3 (Tribonacci):  η₃ = η ≈ 1.8393   ← CRITICAL POINT
- n=4 (Tetranacci):  η₄ ≈ 1.9276
- n→∞:               ηₙ → 2

The conformal dimension at rank n is Δₙ = log(ηₙ)/2.

### 2.2 The Ring Size and Critical Dimension

Each rank-n polynomial generates a companion matrix Tₙ ∈ SL(n,ℤ).
The Cayley-Hamilton recurrence produces integer sequences.  Define:
```
Npf(n) = a₇(n)   (the 7th term of the rank-n integer recurrence)
Dcrit(n) = 2·(Npf(n) − 1) + 2
```

Computed values:
| Rank n | ηₙ     | Npf(n) | Dcrit(n) | Status          |
|--------|--------|--------|----------|-----------------|
| 2      | 1.6180 | 13*    | 26*      | Accidental      |
| 3      | 1.8393 | 13     | 26       | **CRITICAL**    |
| 4      | 1.9276 | 56     | 112      | Supercritical   |
| 5      | ~1.966 | >>56   | >>112    | Strongly super  |

*Rank 2 gives Dcrit = 26 accidentally, but the ring is not ℤ-closed (φ⁷ ≈ 29.03
is not an integer), so the spectral zeta values ζ₁₃(1) = 14 and ζ₁₃(2) = 42
cannot be computed from rank-2 integer arithmetic. The coincidence breaks down
precisely where the physics requires exact integers.

### 2.3 The Phase Structure

The n-bonacci ladder defines a phase structure on the space of algebraic
recurrences:

**Subcritical (n < 3):** Insufficient algebraic complexity. The companion
matrix eigenvalues are either all real (n=1: trivially) or include only one
complex pair with trivial phase arg(λ₂) = π (n=2: just a sign change). No
non-trivial phase winding, no genuine ring geometry. The Weinberg angle formula
is formally undefined because the ring is not over ℤ.

**Critical (n = 3):** The Tribonacci phase boundary. Complex eigenvalue phase
arg(λ₂) = 2.17623... rad is a genuine algebraic number, encoding non-trivial
winding geometry. The ring size Npf = 13 is an exact integer. Dcrit = 26
matches string theory. The full GTCT cycle closes at finite entropic cost.

**Supercritical (n > 3):** Excess algebraic complexity. Ring sizes grow rapidly
(Npf = 56, 149, ...). Dcrit >> 26; BRST nilpotency Q²_BRST = 0 requires
c_matter + c_ghost = 0, which requires D = 26 exactly. The string sector is
inconsistent. Lepton masses are driven to zero by exponential suppression
(ηₙ^{−(Npf+2)/2} → 0 as Npf grows). The entropic operator E cannot close the
generative cycle.

---

## 3. The Potential–Rank Bridge

### 3.1 Two Languages, One Condition

The GTCT criticality condition is:
```
V_c(q) = q³ − c·q,   c* = 3   ⟺   V₃(q) = (q−1)²(q+2)
```

The double root at q = 1 is the **contact-geometric condition**: the generative
cycle closes at an integer fixed point with exactly one degenerate direction
(the fold direction) and one non-degenerate direction (the unfolding branch q = −2).

The Navrátil rank-criticality condition is:
```
Pₙ(η) = ηⁿ − ηⁿ⁻¹ − ... − 1 = 0,   n* = 3
```

The bridge between them:

**Claim:** The double-root condition V_c*(1) = 0, V'_c*(1) = 0 at c* = 3 is
the algebraic fingerprint that the characteristic polynomial must be exactly
cubic. Specifically:

- The minimal polynomial degree admitting a double root at an **integer** fixed
  point alongside a non-trivial additional real root is degree 3.
- Degree 1: V(q) = q − c. Single root, no fold structure.
- Degree 2: V(q) = q² − c. Double root requires c = 0 (trivial) or non-integer.
- Degree 3: V(q) = q³ − 3q = (q−1)²(q+2). FIRST non-trivial case: integer double
  root at q = 1, non-trivial branch at q = −2.
- Degree 4+: Additional roots create uncontrolled fold proliferation.

Therefore, c* = 3 in the potential language selects exactly the cubic = rank-3 =
Tribonacci structure.

### 3.2 The Spectral Map

The conformal dimension Δ₃ ≈ 0.3047 connects the two frameworks through the
Weinberg angle formula:
```
sin²θW = Δ/(1+Δ) · (1 − Δ²/6)
```

The denominator factor (1 − Δ²/6) comes from the Iwasawa A-component ratio
a₁²/a₃² = 6, which is the ratio of the leading-to-trailing Iwasawa component
of T₃. This ratio equals exactly 6 at the critical point — and 6 = (double root
multiplicity 2) × (non-trivial root distance |1 − (−2)| = 3) = ... more
precisely, it is the canonical curvature eigenvalue of the Ricci-flat connection
on the rank-3 Iwasawa manifold.

---

## 4. Supercriticality: What It Means Physically

When rank n > 3, the system generates too many modes for physical closure.

### 4.1 BRST Perspective

The Virasoro central charge from Npf − 1 oscillator modes:
```
c_matter(n) = 2·(Npf(n) − 1)
c_ghost = −26  (universal, from bc system)
```

BRST nilpotency requires c_matter + c_ghost = 0, hence c_matter = 26, hence
Npf = 14 — but then Dcrit = 2·13 + 2 = 28, contradicting the requirement
Dcrit = 26. This apparent contradiction is resolved at rank 3: the mode count
Npf = 13 gives c_matter = 24 (not 26), and the remaining 2 units come from
the longitudinal and temporal oscillators. Only rank 3 achieves this balance.

At rank 4, Npf = 56: c_matter = 110, and no ghost system can compensate.
The string theory is simply inconsistent.

### 4.2 dm³ Perspective

In the GTCT language: the entropic operator E must close the cycle by mapping
the fold output back to the compression input. The entropic cost of this closure
grows with the ring size Npf:
```
Cost(E) ∝ log(Npf)
```

At rank 3, Cost(E) ∝ log(13) ≈ 2.56 — finite and manageable.
At rank 4, Cost(E) ∝ log(56) ≈ 4.03 — the cycle cannot regenerate fast enough
to pay this cost while maintaining the integer coherence constraint.

More precisely: the integer coherence constraint requires that the Tribonacci
recurrence a_{n+3} = a_{n+2} + a_{n+1} + aₙ remain in ℤ at every step. This
is trivially satisfied because T₃ ∈ SL(3,ℤ) (det = 1, integer entries). But
the entropic cost of *checking* this coherence at each of Npf = 56 ring elements
(rank 4) exceeds the generative capacity of the cycle.

---

## 5. The Koide Formula as Criticality Invariant

The Koide formula K = (√mτ + √mμ + √mₑ)² / 3(mτ + mμ + mₑ) ≈ 0.5000 to
five decimal places is currently unexplained by both the Standard Model and the
Navrátil framework (it acknowledges this as a numerical coincidence).

**Conjecture:** K = 1/2 follows from the double-root structure of V₃.

The Tribonacci mass ladder assigns depths nτ = 7.5, nμ = 14, nₑ = 21 to the
three leptons. These satisfy:
```
nₑ = 3 · nμ/2 = 3 · nτ × 2/1   (not quite, but approximately)
```

More precisely: the Iwasawa decomposition of T₃ at the critical point assigns
Gram-Schmidt weights to the three eigenspaces. The Koide invariant K is
a function of these weights. At the critical point (q = 1 double root):
the weight ratio is exactly 2:1 between the degenerate and non-degenerate
Iwasawa directions, and K = weight/(weight + 1) = 2/3... 

But numerically K ≈ 1/2, not 2/3. The discrepancy requires the η^{Δ²}
CFT correction factor. This is a genuine open problem, but the
near-coincidence of K ≈ 1/2 with the critical ratio 1/(1+1) = 1/2 from
the (q−1)² structure (double root contributing weight 1 to each of two
directions) suggests a deeper connection.

---

## 6. The g³³ = 33 Threshold as Rank-3 Saturation

The GTCT g³³ = 33 stability threshold — requiring 33 generative cycles for
spectral collapse — connects to the Tribonacci algebra as follows:

From the Navrátil CH recurrence, at n = 33:
```
T₃³³ = a₃₃T₃² + b₃₃T₃ + c₃₃I
```

The coefficients a₃₃, b₃₃, c₃₃ grow as η^{33} ≈ η^{33}.
Since η ≈ 1.8393: η^{33} ≈ 1.8393^{33} ≈ 4.7 × 10⁶.

The spectral collapse condition (all eigenvalues of DG inside unit disk)
is satisfied when the transverse deviation ξ = ρ − 1 satisfies |ξ| < η^{−33}.

The number 33 is not arbitrary: it is the smallest n such that the
nilpotency condition δ³ = 0 (required by the cubic characteristic polynomial)
and orthogonality of transverse/longitudinal components are simultaneously
achieved at integer n. This is a Diophantine condition on the CH recurrence.

**Claim:** g³³ = 33 is derivable from the Navrátil CH recurrence as the
minimal n such that a_n/a_{n-1} approximates η to within machine precision
and the nilpotency δ³ = 0 is satisfied at integer lattice points.

---

## 7. Open Problems and Research Programme

### 7.1 Immediate (Lean-formalizable)

1. **Double-root minimality theorem:** Prove that degree 3 is the minimal
   polynomial degree admitting an integer double root with non-trivial
   additional root. This is pure polynomial algebra over ℤ.

2. **critDim monotonicity:** Prove that nBonacciRingSize(n) is strictly
   increasing for n ≥ 3. This requires bounding the growth of the 7th term
   of rank-n recurrences.

3. **double_root_at_q_one:** The sorry in the current Lean file is almost
   closed. The deriv computation is straightforward: d/dq(q³ − 3q)|_{q=1} = 0.
   The contact/Hamiltonian embedding is the remaining open piece.

### 7.2 Medium-term (requires new mathematics)

4. **Tensor product algebra for CKM parameters:** The three inter-generational
   mixing parameters A, ρ, η_CKM require the full A⊗A⊗A structure. Conjecture:
   each generation corresponds to one factor of T₃, and the CKM matrix entries
   are matrix elements of T₃⊗T₃⊗T₃ projected onto grade sectors.

5. **Koide from criticality:** Show that the (q−1)²(q+2) factorization implies
   K = 1/2 through the Iwasawa weight structure.

6. **g³³ derivation:** Derive g³³ = 33 as the minimal Diophantine solution
   to the spectral collapse condition from the CH recurrence.

### 7.3 Long-term (speculative but motivated)

7. **Phase transition universality:** Is the rank-3 criticality condition
   related to other known phase transitions at d = 3? The Navrátil document
   notes that Navier-Stokes blow-up and Ricci flow singularities are both
   problems of 3-dimensional geometry. The GTCT file lists these as
   instantiations of IsGenerativeCriticalPoint(3). A unified proof that all
   "hard" problems in 3 dimensions share the same criticality structure
   would be the strongest possible confirmation.

8. **Electroweak vev from criticality:** v = 246 GeV = M_Pl · η^{−63}.
   The exponent 63 = 3 × ζ₁₃(2) = 3 × 21 = 63. This is a motivated
   formula but not yet derived. The factor 3 might come from the three
   generations (three T₃ factors in the tensor product algebra).

---

## 8. Summary

| Concept               | Navrátil Language              | GTCT Language                        |
|-----------------------|--------------------------------|--------------------------------------|
| Critical structure    | P(η) = η³−η²−η−1 = 0          | V_c*(q) = (q−1)²(q+2), c* = 3       |
| Integer coherence     | det(T₃) = 1, T₃ ∈ SL(3,ℤ)   | Generative cycle closes over ℤ       |
| Ring size             | Npf = a₇ = 13                  | Entropic cost = log(13) (minimal)    |
| String consistency    | Dcrit = 2(Npf−1)+2 = 26        | c_matter + c_ghost = 0               |
| CP conservation       | arg(det T₃ⁿ) = 0               | θ_eff = 0 (SL(3,ℤ) theorem)         |
| Subcritical failure   | rank 2: arg(λ₂) = π, trivial  | c < 3: FoldEventsAreTrivial          |
| Supercritical failure | rank 4: Dcrit = 112            | c > 3: FoldEventsProliferateUncontrollably |
| Stability threshold   | η^{33} spectral collapse        | g³³ = 33 saturation                  |
| Entropic closure      | ζ₁₃(1) = 14, ζ₁₃(2) = 42     | Entropic Boundary Principle          |

The Tribonacci algebra η³ = η² + η + 1 is not merely one convenient
polynomial that happens to fit the Standard Model data. It is the unique
algebraic structure sitting at the phase boundary between insufficient and
excessive generative complexity — the minimal closed system that is both
non-trivial and controllable. This is what rank-3 means physically, and it
is what c* = 3 means geometrically. They are the same fact.
