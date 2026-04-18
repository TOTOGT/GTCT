# dm³ toy ODE — numerical findings

System:
```
ṙ = r(1 − r²) + 2(r − 1)·e^(−z)
θ̇ = 1
ż = r² − 2(r − 1)²·e^(−z)
```

Integration: DOP853, rtol = 1e-10, atol = 1e-12.

## What the paper gets right

1. **Limit cycle on r = 1 exists.** Every trajectory starting with r(0) ≳ 0.85 converges exponentially to r = 1. The unit circle in (r, θ) is an attractor for a wide set of initial conditions. ✔
2. **z is asymptotically linear along the attractor.** Once r ≈ 1, ż ≈ 1, so z(t) ~ t and the full 3D picture is a stable helix on the contact 3-manifold. ✔
3. **Linearized decay rate is μ_max = −2.** Empirical fits land at −1.80 to −1.96 depending on ε; the rate approaches −2 as z grows and the e^(−z) coupling dies out. ✔ (exact linearization is the correct asymptotic)

## What needs correction

### (a) The ε₀ = 1/3 stability-radius claim is too generous on the inner side.

The paper claims the ball |r − 1| < ε₀ = 1/3 is in the basin of attraction, derived from a Gronwall estimate with a factor-of-2 I previously flagged as suspicious. Empirically:

- r(0) = 0.667 (i.e., ε = −1/3, at the claimed boundary): **trajectory collapses**, z → −∞, r goes negative in finite time.
- r(0) = 0.7: **collapses** at t ≈ 1.3.
- r(0) = 0.85: recovers, z grows linearly. ✔
- r(0) = 1 + ε for any ε > 0: stable up to at least ε = 2.0. ✔

The basin is **asymmetric**: generous on the outer side (r > 1, possibly all of it), narrow on the inner side (r > ~0.8). A two-sided ball of radius 1/3 is not the right picture.

**Suggested rewrite.** Either:
- State the theorem on the outer side only ("for all r(0) > 1, the trajectory converges exponentially to r = 1 at rate −2"), which is what the numerics strongly support; or
- Replace the ball with an explicit asymmetric basin estimate derived from the actual coupling (the e^(−z) term is what breaks symmetry).

### (b) The "z monotone increasing along Γ" claim fails for r(0) < 1.

For r(0) ≲ 0.75, ż is strongly negative at t = 0: at r = 0.5, z = 0 the computed ż ≈ −0.25. More importantly, once z dips below 0, the e^(−z) term amplifies the negative feedback and z dives to −∞ in finite time.

This matters for the **spiral-return theorem** in the paper: the conclusion x₀′ ≠ x₀ "because dz/dt ≥ 0 on Γ" is only true if Γ is taken to be the outer-basin attractor, not an arbitrary trajectory.

**Suggested rewrite.** Replace "ż ≥ 0 along trajectories" with "ż ≥ 0 along the attractor Γ (i.e., once trajectories have entered a neighborhood of r = 1 with z bounded below)." The asymptotic statement is defensible; the pointwise statement is not.

## What's unambiguously solid

- Existence of a stable limit cycle on r = 1.
- Exponential convergence rate in the neighborhood of r = 1 (on the outer side).
- Asymptotic helical trajectory — the contact-geometric picture the paper wants.
- The Whitney fold / cusp / swallowtail classification is a separate analytic claim not tested here.

## One-line summary for the abstract

> The dm³ toy system admits a globally stable helical attractor on r = 1 for all r(0) > 1, with exponential radial convergence rate −2 and linear z-growth; the inner-basin boundary is asymmetric and concave, failing the symmetric Gronwall estimate of radius 1/3.

## Files

- `dm3_overview.png` — 3D helix + r(t), z(t), log|r−1|(t)
- `dm3_rz_portrait.png` — (r, z) phase portrait
- `dm3_stability_sweep.png` — fitted decay rate vs ε on the outer side
- `dm3_inner_basin.png` — the new finding, inner-basin collapse
