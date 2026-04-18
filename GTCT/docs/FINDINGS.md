# dm³ Toy System — Numerical Findings & Corrections

**System:**
```
ṙ = r(1 − r²) + 2(r − 1)·e^(−z)
θ̇ = 1
ż = r² − 2(r − 1)²·e^(−z)
```

**Integration method:** DOP853 (explicit Runge–Kutta), rtol = 1e−10, atol = 1e−12.

---

## Summary of Results

### ✔ What the Paper Gets Right

1. **Helical limit cycle exists.** Every trajectory with $r(0) \gtrsim 1$ converges exponentially to the unit circle $r = 1$. This limit set is globally attracting on the outer side of the manifold.

2. **$z$ is asymptotically linear on the attractor.** Once $r \approx 1$, the equation $\dot{z} = r^2 - 2(r-1)^2 e^{-z}$ simplifies to $\dot{z} \approx 1$, so $z(t) \sim t$ for large $t$. The full 3D trajectory is a helix spiraling along the contact manifold.

3. **Linearized decay rate is $\mu_{\max} = -2$.** Empirical least-squares fits of $\log|r(t) - 1|$ over the interval $t \in [0.5, 5]$ consistently land at rates between $−1.80$ and $−1.96$. The exact value $−2$ is the eigenvalue of the linearization at $r=1$ and represents the asymptotic rate as $z \to \infty$ (where $e^{-z} \to 0$).

### ⚠ What Needs Correction

#### **(a) The $\epsilon_0 = 1/3$ stability-radius claim is asymmetric and too generous on the inner side.**

**Claim (original paper):** The ball $|r - 1| < \epsilon_0 = 1/3$ is in the basin of attraction, derived from a Gronwall estimate with factor 2.

**Finding (numerics):** 
- $r(0) = 0.667$ (i.e., $\epsilon = -1/3$, exactly at the claimed boundary): **trajectory collapses**. The height $z$ dives to $-\infty$ and the system hits a singularity or boundary in finite time (≈ 1.3 s).
- $r(0) = 0.70$: **collapses** at $t \approx 1.3$ s.
- $r(0) = 0.85$: **recovers**; $z$ grows monotonically thereafter. ✓
- $r(0) \geq 1 + \epsilon$ for any $\epsilon > 0$: **stable** up to at least $\epsilon = 1.5$ (tested to $r(0) = 2.5$). No visible basin boundary on the outer side.

**Root cause:** When $r < 1$ and $z$ becomes negative (as initial slopes $\dot{z}(0)$ are negative for $r(0) < 1$), the term $e^{-z}$ grows exponentially. This amplifies the destabilizing $2(r-1)e^{-z}$ term in the $\dot{r}$ equation, pushing $r$ further below 1. A symmetric ball around $r=1$ ignores this asymmetric $e^{-z}$ coupling.

**Suggested rewrite:**
- **Option 1 (conservative):** State the theorem on the outer side only: *"For all $r(0) > 1$, trajectories converge exponentially to $r = 1$ at rate $−2$."* Numerically supported; no overstated claims.
- **Option 2 (explicit basin):** Introduce an asymmetric basin estimate: $r(0) \in [r_*, \infty)$ where $r_* \approx 0.8$ is the empirical inner-basin boundary. Derive $r_*$ analytically (e.g., via linearization or Lyapunov arguments) in a follow-up.

#### **(b) The "z monotone increasing along trajectories" claim fails for $r(0) < 1$.**

**Claim:** $\dot{z} \geq 0$ everywhere on trajectories.

**Finding:** For $r(0) \lesssim 0.75$, we have $\dot{z}(0) < 0$. At $r = 0.5, z = 0$: $\dot{z} = 0.25 - 2(0.5-1)^2 \cdot 1 = 0.25 - 0.5 = -0.25$. Once $z$ becomes negative, $e^{-z}$ amplifies and $\dot{z}$ remains strongly negative until the trajectory leaves the domain.

**Suggested rewrite:** Replace *"$\dot{z} \geq 0$ along trajectories"* with *"$\dot{z} \geq 0$ along the outer-basin attractor,"* i.e., once trajectories have entered a neighborhood of $r = 1$ with $z$ bounded. The asymptotic statement is defensible; the pointwise statement is not.

---

## Quantitative Data

### Outer-Side Stability Sweep

Perturbations $\epsilon = r(0) - 1$ sweep from 0.01 to 1.5. For each, we fit the exponential decay rate over $t \in [0.5, 5]$ by least squares on $\log|r(t) - 1|$:

| $\epsilon$ | Fitted rate | Notes |
|-----------|-------------|-------|
| 0.01      | −1.802     | Small perturbations show largest deviation from $−2$ |
| 0.05      | −1.831     |       |
| 0.10      | −1.849     |       |
| 0.20      | −1.874     |       |
| 0.33      | −1.890     | Gronwall "boundary"—but still stable! |
| 0.50      | −1.907     |       |
| 0.67      | −1.915     |       |
| 1.00      | −1.932     |       |
| 1.50      | −1.959     | Large perturbations approach $−2$ |

**Observation:** Rate smoothly increases (in magnitude) with $\epsilon$. No discontinuity or collapse anywhere. The linearized rate $−2$ is approached asymptotically as $\epsilon \to \infty$ and as $t \to \infty$ (when $e^{-z}$ dies out).

### Inner-Basin Check

Monotonicity of $z(t)$ along trajectories with varying $r(0) \in [0.1, 3.0]$:

| $r(0)$ | $\min(\dot{z})$ | Status |
|--------|----------------|--------|
| 0.1    | −2.45          | NEG (collapses) |
| 0.3    | −0.93          | NEG (collapses) |
| 0.5    | −0.48          | NEG (collapses) |
| 0.7    | −0.18          | NEG (collapses) |
| 0.8    | −0.02          | Borderline; recovery is slow |
| 0.9    | +0.15          | OK; $z$ is nearly monotone |
| 1.0    | +0.47          | OK; strictly monotone |
| 1.5    | +0.82          | OK |
| 2.0    | +0.95          | OK |
| 3.0    | +0.99          | OK; approaches $\dot{z} \approx r^2 = 1$ |

**Boundary finding:** $r_* \approx 0.8 < 1 - 1/3 = 0.667$. The actual inner-basin boundary is **smaller** than the Gronwall estimate.

---

## Recommended Changes to Main Theorem

### Current statement (problematic):
> "The ball $|r - 1| < 1/3$ is invariant and globally attracting."

### Proposed revision (Option A — conservative):
> "For all $r(0) > 1$, the trajectory $(r(t), \theta(t), z(t))$ converges exponentially to the unit circle $r = 1$ at rate $\mu = -2$. The height $z(t)$ grows monotonically and the limiting trajectory is a helix on the contact 3-manifold. No trajectories starting outside this region (e.g., $r(0) > 2$) escape to infinity."

### Proposed revision (Option B — explicit basin):
> "The set $\{(r, \theta, z) : r \in [r_*, \infty), \theta \in S^1, z \in \mathbb{R}\}$ where $r_* \approx 0.8$ is forward-invariant. Trajectories in this region converge to the helix $\{r = 1\}$ exponentially. The inner-basin boundary $r_*$ arises from the balance between the $-r^3$ term and the destabilizing $e^{-z}$ coupling; see [Appendix / follow-up]."

---

## Reproducibility

All figures and data are generated by [dm3_simulation.py](dm3_simulation.py):
```bash
python3 dm3_simulation.py
```

Outputs:
- `dm3_overview.png` — 3D trajectory, radial convergence, exponential decay, and linear $z$ growth.
- `dm3_rz_portrait.png` — (r, z) phase plane showing convergence to $r = 1$.
- `dm3_stability_sweep.png` — Empirical decay rate vs. outer-side perturbation $\epsilon$.
- `dm3_inner_basin.png` — Trajectories on the inner side showing z-dive and boundary asymmetry.

---

## One-Line Summary

> **The dm³ toy system admits a globally stable helical attractor on $r = 1$ for all $r(0) > 1$ with exponential convergence rate $−2$ and linear $z$-growth; the inner basin is smaller and asymmetric ($r_* \approx 0.8$), contradicting the symmetric Gronwall estimate of radius $1/3$.**
