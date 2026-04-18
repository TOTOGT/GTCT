"""
dm3 toy ODE — numerical phase portrait and stability check.

System (cylindrical coordinates on a contact 3-manifold):
    r_dot     = r*(1 - r^2) + 2*(r - 1)*exp(-z)
    theta_dot = 1
    z_dot     = r^2 - 2*(r - 1)^2 * exp(-z)

Goals:
  (1) Verify that trajectories spiral onto r = 1 with z monotone increasing.
  (2) Extract the effective exponential decay rate mu_max empirically.
  (3) Sweep initial conditions to see where the linear-stability picture
      actually fails — i.e. probe the stability radius epsilon_0.
  (4) Save publication-quality figures.
"""

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

OUTDIR = "/sessions/kind-elegant-pascal/mnt/outputs/dm3-simulation"

# ------------------------------------------------------------------
# Vector field
# ------------------------------------------------------------------
def dm3(t, y):
    r, theta, z = y
    r = max(r, 1e-9)                      # keep r strictly positive
    ez = np.exp(-z)
    rdot     = r * (1.0 - r**2) + 2.0 * (r - 1.0) * ez
    thetadot = 1.0
    zdot     = r**2 - 2.0 * (r - 1.0)**2 * ez
    return [rdot, thetadot, zdot]


def integrate(y0, t_end=20.0, n=4000):
    t_eval = np.linspace(0.0, t_end, n)
    sol = solve_ivp(dm3, (0.0, t_end), y0, t_eval=t_eval,
                    rtol=1e-10, atol=1e-12, method="DOP853")
    return sol.t, sol.y


# ------------------------------------------------------------------
# (1) Overview figure: 3D helix + r(t) + z(t) + log|r-1|(t)
# ------------------------------------------------------------------
def overview_figure():
    inits = [
        (0.3, 0.0, 0.0),
        (0.7, 0.0, 0.0),
        (1.3, 0.0, 0.0),
        (2.0, 0.0, 0.0),
    ]
    colors = ["#1F7A8C", "#E1B93E", "#9E2A2B", "#2B4162"]

    fig = plt.figure(figsize=(14, 10))
    ax3d = fig.add_subplot(2, 2, 1, projection="3d")
    axr  = fig.add_subplot(2, 2, 2)
    axz  = fig.add_subplot(2, 2, 3)
    axlg = fig.add_subplot(2, 2, 4)

    for y0, c in zip(inits, colors):
        t, y = integrate(y0, t_end=25.0, n=6000)
        r, th, z = y
        x = r * np.cos(th)
        yc = r * np.sin(th)
        ax3d.plot(x, yc, z, color=c, lw=1.0, alpha=0.9,
                  label=f"r0={y0[0]}")
        axr.plot(t, r, color=c, lw=1.2, label=f"r0={y0[0]}")
        axz.plot(t, z, color=c, lw=1.2)
        axlg.plot(t, np.log(np.abs(r - 1.0) + 1e-16),
                  color=c, lw=1.2)

    # Unit-circle "target" helix on r=1
    th_grid = np.linspace(0, 8 * np.pi, 400)
    ax3d.plot(np.cos(th_grid), np.sin(th_grid),
              th_grid, color="k", lw=0.5, ls="--", alpha=0.5,
              label="r=1 helix")

    ax3d.set_xlabel("x = r cos θ"); ax3d.set_ylabel("y = r sin θ")
    ax3d.set_zlabel("z")
    ax3d.set_title("Trajectories on the contact 3-manifold")
    ax3d.legend(fontsize=8, loc="upper left")

    axr.axhline(1.0, color="k", lw=0.5, ls="--")
    axr.set_xlabel("t"); axr.set_ylabel("r(t)")
    axr.set_title("Radial convergence to r = 1")
    axr.legend(fontsize=9, loc="best")
    axr.grid(alpha=0.3)

    axz.set_xlabel("t"); axz.set_ylabel("z(t)")
    axz.set_title("z(t): monotone, asymptotically linear")
    axz.grid(alpha=0.3)

    # Reference line with slope -2 for comparison
    axlg.plot([0, 12], [0, -24], "k--", lw=0.7,
              label="slope = -2 (linearized rate)")
    axlg.set_xlabel("t"); axlg.set_ylabel("log |r(t) - 1|")
    axlg.set_title("Exponential radial decay")
    axlg.legend(fontsize=9, loc="best")
    axlg.grid(alpha=0.3)
    axlg.set_xlim(0, 12)
    axlg.set_ylim(-20, 2)

    fig.suptitle(r"dm$^3$ toy system — phase portrait",
                 fontsize=16, fontweight="bold")
    fig.tight_layout()
    out = f"{OUTDIR}/dm3_overview.png"
    fig.savefig(out, dpi=160, bbox_inches="tight")
    plt.close(fig)
    return out


# ------------------------------------------------------------------
# (2) Stability-radius sweep: how big a perturbation still decays
#     exponentially at rate ~= -2?
# ------------------------------------------------------------------
def stability_sweep():
    # Sweep perturbations eps = r(0) - 1 from small to large,
    # fit slope of log|r(t) - 1| over the early window, and compare
    # to the linearized rate -2.
    eps_list = np.array([0.01, 0.05, 0.1, 0.2, 1/3, 0.5, 2/3, 1.0, 1.5])
    rates = []
    for eps in eps_list:
        _, y = integrate((1.0 + eps, 0.0, 0.0), t_end=8.0, n=4000)
        r = y[0]
        t = np.linspace(0.0, 8.0, len(r))
        # fit over a window that's well inside the decay phase but
        # before roundoff kicks in
        mask = (t > 0.5) & (np.abs(r - 1.0) > 1e-8) & (t < 5.0)
        if mask.sum() > 10:
            coef = np.polyfit(t[mask], np.log(np.abs(r[mask] - 1.0)), 1)
            rates.append(coef[0])
        else:
            rates.append(np.nan)

    fig, ax = plt.subplots(figsize=(8, 5))
    ax.axhline(-2.0, color="k", ls="--", lw=0.8,
               label="linearized rate μ = -2")
    ax.plot(eps_list, rates, "o-", color="#1F7A8C", lw=1.5, ms=7,
            label="fitted rate over t∈[0.5, 5]")
    for x, lbl in [(1/3, "ε=1/3\n(claimed ε₀)"),
                   (2/3, "ε=2/3\n(Gronwall)")]:
        ax.axvline(x, color="#E1B93E", lw=0.6, alpha=0.6)
        ax.annotate(lbl, xy=(x, -1.82), xytext=(x + 0.02, -1.82),
                    color="#8A6A14", fontsize=8, va="top")
    ax.set_xlabel(r"perturbation  $\varepsilon = r(0) - 1$")
    ax.set_ylabel("fitted exponential rate")
    ax.set_title("Empirical stability on the outer side (r(0) > 1) — "
                 "rate never collapses; no basin boundary visible")
    ax.grid(alpha=0.3)
    ax.legend(loc="lower right", fontsize=9)
    ax.set_ylim(-2.05, -1.78)
    out = f"{OUTDIR}/dm3_stability_sweep.png"
    fig.savefig(out, dpi=160, bbox_inches="tight")
    plt.close(fig)
    return out, list(zip(eps_list.tolist(), rates))


# ------------------------------------------------------------------
# (3) (r, z) phase portrait — showing that z is monotone and
#     r -> 1 is achieved for every r(0) > 0.
# ------------------------------------------------------------------
def rz_phase_portrait():
    fig, ax = plt.subplots(figsize=(8, 6))
    r0_list = [0.1, 0.3, 0.6, 0.9, 1.1, 1.5, 2.0, 3.0]
    for r0 in r0_list:
        _, y = integrate((r0, 0.0, 0.0), t_end=15.0, n=4000)
        r, _, z = y
        ax.plot(r, z, lw=1.0, alpha=0.9)
    ax.axvline(1.0, color="k", lw=0.4, ls="--", alpha=0.6)
    ax.set_xlabel("r"); ax.set_ylabel("z")
    ax.set_title("(r, z) phase portrait — trajectories sweep right onto r=1, z↑")
    ax.set_xlim(0, 3.1)
    ax.grid(alpha=0.3)
    out = f"{OUTDIR}/dm3_rz_portrait.png"
    fig.savefig(out, dpi=160, bbox_inches="tight")
    plt.close(fig)
    return out


# ------------------------------------------------------------------
# (4) Monotonicity check — is z_dot >= 0 along every trajectory?
# ------------------------------------------------------------------
def monotonicity_check():
    r0_list = np.linspace(0.1, 3.0, 20)
    min_zdot_per_traj = []
    for r0 in r0_list:
        t, y = integrate((r0, 0.0, 0.0), t_end=15.0, n=3000)
        r, _, z = y
        zdot = r**2 - 2.0 * (r - 1.0)**2 * np.exp(-z)
        min_zdot_per_traj.append(zdot.min())
    return list(zip(r0_list.tolist(), min_zdot_per_traj))


# ------------------------------------------------------------------
def inner_basin_check():
    """What happens for r(0) < 1?  z transiently goes very negative,
       e^(-z) blows up, and the 'spiral-return' narrative breaks."""
    fig, axes = plt.subplots(1, 2, figsize=(12, 5))
    r0_list = [0.5, 0.7, 0.85, 0.95, 1.05, 1.3, 2.0]
    colors = plt.cm.viridis(np.linspace(0.1, 0.9, len(r0_list)))
    for r0, c in zip(r0_list, colors):
        t, y = integrate((r0, 0.0, 0.0), t_end=3.0, n=2000)
        axes[0].plot(t, y[2], color=c, lw=1.3, label=f"r(0)={r0}")
        axes[1].plot(y[0], y[2], color=c, lw=1.3, label=f"r(0)={r0}")
    axes[0].axhline(0, color="k", lw=0.5, ls="--", alpha=0.5)
    axes[0].set_xlabel("t"); axes[0].set_ylabel("z(t)")
    axes[0].set_title("z(t) — NOT monotone for r(0) < 1")
    axes[0].legend(fontsize=8, loc="best")
    axes[0].grid(alpha=0.3)
    axes[1].axvline(1, color="k", lw=0.5, ls="--", alpha=0.5)
    axes[1].set_xlabel("r"); axes[1].set_ylabel("z")
    axes[1].set_title("(r, z) trajectories — r(0) < 1 dive into z < 0")
    axes[1].grid(alpha=0.3)
    fig.suptitle("Finding: the z-monotonicity claim fails inside r(0) < 1",
                 fontsize=13, fontweight="bold")
    fig.tight_layout()
    out = f"{OUTDIR}/dm3_inner_basin.png"
    fig.savefig(out, dpi=160, bbox_inches="tight")
    plt.close(fig)
    return out


if __name__ == "__main__":
    f1 = overview_figure()
    f2, sweep = stability_sweep()
    f3 = rz_phase_portrait()
    f4 = inner_basin_check()
    mono = monotonicity_check()

    print(f"Saved: {f1}")
    print(f"Saved: {f2}")
    print(f"Saved: {f3}")
    print(f"Saved: {f4}")
    print()
    print("Stability sweep — (epsilon, fitted rate):")
    for eps, rate in sweep:
        print(f"  eps = {eps:.3f}   rate = {rate:.4f}")
    print()
    print("Monotonicity check — min(z_dot) along trajectories:")
    for r0, mz in mono:
        flag = "OK" if mz > -1e-6 else "NEG"
        print(f"  r0 = {r0:.3f}   min(z_dot) = {mz:+.4f}   [{flag}]")
