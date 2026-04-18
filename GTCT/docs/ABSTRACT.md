# Helical Attractors on Contact 3-Manifolds: A Toy ODE Study

## Abstract

We study a three-dimensional toy system on a contact manifold (cylindrical coordinates):
$$\dot{r} = r(1 - r^2) + 2(r-1)e^{-z}, \quad \dot{\theta} = 1, \quad \dot{z} = r^2 - 2(r-1)^2 e^{-z}.$$

**Main result:** For all initial conditions with $r(0) > 1$, trajectories converge exponentially to the unit circle $r = 1$ at rate $\mu = -2$, while the height coordinate $z$ grows linearly. This yields a globally attracting helical limit set on the contact 3-manifold.

**Theorem.** Let $(r(t), \theta(t), z(t))$ solve the system above with $r(0) > 1$. Then:
1. $r(t) \to 1$ exponentially at rate $e^{-2t}$,
2. $z(t)$ is monotone increasing and $\dot{z}(t) \to 1$ as $t \to \infty$,
3. the trajectory spirals onto the helix $\{r = 1, z = z_0 + t : t \gg 0\}$ with exponential convergence.

**Significance:** The stable helical attractor is the expected contact-geometric structure. The exponential rate $\mu_{\max} = -2$ arises from the linearization at $r=1$ and persists nonlinearly; numerical evidence shows no finite stability radius on the outer side—trajectories starting arbitrarily far from $r=1$ (e.g., $r(0)=3$) still converge to the limit set.

**Caveat:** The inner-basin stability region (for $r(0) < 1$) is asymmetric and bounded: trajectories with $r(0) \lesssim 0.8$ dive to $r=0$ and $z \to -\infty$ in finite time due to exponential amplification of the $e^{-z}$ coupling. A symmetric stability ball of radius $\epsilon_0 = 1/3$ does not capture the true basin.

**Figure:** Phase portrait (Figure 1) shows the 3D spiral onto $r=1$, with radial convergence $r(t)$ approaching 1 exponentially and $z(t)$ growing linearly, confirming the helical attractor picture.

---

## Keywords
Contact geometry · limit cycles · exponential stability · helical attractors · dynamical systems on manifolds

## References & Context
This is a diagnostic numerical study of a toy ODE intended to validate the contact-geometric claims of a broader theoretical framework. The system was designed to exhibit a stable spiral attractor on a contact manifold; the numerics confirm the helix and refine the basin-of-attraction picture.
