# Copyright (c) 2026 Pablo Nogueira Grossi — G6 LLC. All rights reserved.
# Released under the MIT License. See the LICENSE file in the project root.
# Author: Pablo Nogueira Grossi.

"""
dm3 toy ODE simulation — regenerate the 4 figures for the SBM bilingual submission.

System (cylindrical coordinates on a contact 3-manifold):
    ṙ = r(1 - r²) + 2(r - 1) e^(-z)
    θ̇ = 1
    ż = r² - 2(r - 1)² e^(-z)
"""

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "mathtext.fontset": "dejavusans",
    "axes.grid": True,
    "grid.alpha": 0.3,
    "savefig.dpi": 180,
    "figure.dpi": 180,
})

OUT = "/sessions/trusting-funny-darwin/work"


# ---------- ODE ----------
def rhs(t, y):
    r, th, z = y
    # Guard against exploding e^(-z) when z is very negative
    ez = np.exp(-np.clip(z, -50.0, 50.0))
    return [
        r * (1.0 - r * r) + 2.0 * (r - 1.0) * ez,
        1.0,
        r * r - 2.0 * (r - 1.0) ** 2 * ez,
    ]


def event_collapse(t, y):
    # Trigger when z dives too low (trajectory collapsing)
    return y[2] + 8.0


event_collapse.terminal = True
event_collapse.direction = -1


def integrate(r0, tmax=25.0, n_points=2000):
    sol = solve_ivp(
        rhs,
        (0.0, tmax),
        [r0, 0.0, 0.0],
        method="DOP853",
        rtol=1e-10,
        atol=1e-12,
        t_eval=np.linspace(0, tmax, n_points),
        events=event_collapse,
    )
    return sol


# ---------- Figure 1: overview (4 panels) ----------
def fig_overview():
    fig = plt.figure(figsize=(13, 8))
    fig.suptitle("dm³ toy system — phase portrait", fontsize=15, fontweight="bold")

    initial_r = [0.3, 0.7, 1.3, 2.0]
    colors = plt.cm.viridis(np.linspace(0.15, 0.85, len(initial_r)))

    # 3D trajectories
    ax1 = fig.add_subplot(2, 2, 1, projection="3d")
    for r0, c in zip(initial_r, colors):
        sol = integrate(r0)
        r, th, z = sol.y
        x, y = r * np.cos(th), r * np.sin(th)
        ax1.plot(x, y, z, color=c, lw=1.2, label=f"r₀={r0}")
    # reference helix on r=1
    t_ref = np.linspace(0, 25, 600)
    ax1.plot(np.cos(t_ref), np.sin(t_ref), t_ref, "k--", lw=0.8, alpha=0.5,
             label="r=1 helix")
    ax1.set_xlabel("x = r cos θ")
    ax1.set_ylabel("y = r sin θ")
    ax1.set_zlabel("z")
    ax1.set_title("Trajectories on the contact 3-manifold")
    ax1.legend(fontsize=8, loc="upper left")

    # Radial convergence
    ax2 = fig.add_subplot(2, 2, 2)
    for r0, c in zip(initial_r, colors):
        sol = integrate(r0)
        ax2.plot(sol.t, sol.y[0], color=c, lw=1.2, label=f"r₀={r0}")
    ax2.axhline(1.0, color="k", ls=":", lw=0.8)
    ax2.set_xlabel("t")
    ax2.set_ylabel("r(t)")
    ax2.set_title("Radial convergence to r = 1")
    ax2.legend(fontsize=8, loc="lower right")

    # z(t)
    ax3 = fig.add_subplot(2, 2, 3)
    for r0, c in zip(initial_r, colors):
        sol = integrate(r0)
        ax3.plot(sol.t, sol.y[2], color=c, lw=1.2)
    ax3.set_xlabel("t")
    ax3.set_ylabel("z(t)")
    ax3.set_title("z(t): monotone, asymptotically linear")

    # Exponential decay with reference slope
    ax4 = fig.add_subplot(2, 2, 4)
    for r0, c in zip(initial_r, colors):
        if r0 <= 1.0:
            continue
        sol = integrate(r0, tmax=12.0)
        mask = np.abs(sol.y[0] - 1) > 1e-9
        ax4.plot(sol.t[mask], np.log(np.abs(sol.y[0][mask] - 1)),
                 color=c, lw=1.2, label=f"r₀={r0}")
    t_slope = np.linspace(0, 10, 50)
    ax4.plot(t_slope, -2 * t_slope, "k--", lw=1.0, label="slope = −2")
    ax4.set_xlabel("t")
    ax4.set_ylabel("log |r(t) − 1|")
    ax4.set_title("Exponential radial decay")
    ax4.legend(fontsize=8)
    ax4.set_ylim(-20, 1)

    plt.tight_layout(rect=[0, 0, 1, 0.96])
    path = f"{OUT}/dm3_overview.png"
    plt.savefig(path, bbox_inches="tight")
    plt.close()
    print(f"  ✓ {path}")


# ---------- Figure 2: (r, z) phase portrait ----------
def fig_rz_portrait():
    fig, ax = plt.subplots(figsize=(9, 7))
    ax.set_title("(r, z) phase portrait", fontsize=14)
    initials = [0.1, 0.3, 0.6, 0.9, 1.1, 1.5, 2.0, 3.0]
    for r0 in initials:
        sol = integrate(r0, tmax=15.0, n_points=3000)
        ax.plot(sol.y[0], sol.y[2], lw=1.3, label=f"r₀={r0}")
    ax.axvline(1.0, color="k", ls=":", lw=0.7)
    ax.set_xlabel("r")
    ax.set_ylabel("z")
    ax.set_xlim(0, 3.2)
    ax.set_ylim(-6, 17)
    plt.tight_layout()
    path = f"{OUT}/dm3_rz_portrait.png"
    plt.savefig(path, bbox_inches="tight")
    plt.close()
    print(f"  ✓ {path}")


# ---------- Figure 3: stability sweep (outer side) ----------
def fig_stability_sweep():
    epsilons = np.array([0.01, 0.05, 0.10, 0.20, 0.33, 0.50, 0.67, 1.00, 1.50])
    rates = []
    for eps in epsilons:
        sol = integrate(1.0 + eps, tmax=6.0, n_points=4000)
        t = sol.t
        r = sol.y[0]
        # fit log|r-1| linearly on t in [0.5, 5]
        mask = (t >= 0.5) & (t <= 5.0) & (np.abs(r - 1) > 1e-12)
        if mask.sum() < 10:
            rates.append(np.nan)
            continue
        slope, _ = np.polyfit(t[mask], np.log(np.abs(r[mask] - 1)), 1)
        rates.append(slope)
    rates = np.array(rates)

    fig, ax = plt.subplots(figsize=(8, 5.5))
    ax.axhline(-2.0, color="k", ls="--", lw=1, label="linearized rate μ = −2")
    ax.plot(epsilons, rates, "o-", color="#1f6f8b", lw=1.8, ms=7, label="fitted")
    ax.set_xlabel("perturbation  ε = r(0) − 1")
    ax.set_ylabel("fitted rate")
    ax.set_title("Empirical stability (r(0) > 1)")
    ax.legend(fontsize=10)
    ax.set_ylim(-2.05, -1.78)
    plt.tight_layout()
    path = f"{OUT}/dm3_stability_sweep.png"
    plt.savefig(path, bbox_inches="tight")
    plt.close()
    print(f"  ✓ {path}")
    return epsilons, rates


# ---------- Figure 4: inner basin asymmetry ----------
def fig_inner_basin():
    initials = [0.5, 0.7, 0.85, 0.95, 1.05, 1.3, 2.0]
    colors = plt.cm.viridis(np.linspace(0.0, 0.95, len(initials)))

    fig, axes = plt.subplots(1, 2, figsize=(13, 5.5))
    fig.suptitle("Inner basin: asymmetry finding", fontsize=14, fontweight="bold")

    # z(t)
    for r0, c in zip(initials, colors):
        sol = integrate(r0, tmax=3.0, n_points=4000)
        axes[0].plot(sol.t, sol.y[2], color=c, lw=1.4, label=f"r(0)={r0}")
    axes[0].axhline(0, color="k", ls="--", lw=0.6, alpha=0.5)
    axes[0].set_xlabel("t")
    axes[0].set_ylabel("z(t)")
    axes[0].set_title("z(t)")
    axes[0].legend(fontsize=9, loc="lower left")

    # (r, z) phase
    for r0, c in zip(initials, colors):
        sol = integrate(r0, tmax=3.0, n_points=4000)
        axes[1].plot(sol.y[0], sol.y[2], color=c, lw=1.4)
    axes[1].axvline(1.0, color="k", ls="--", lw=0.6, alpha=0.5)
    axes[1].set_xlabel("r")
    axes[1].set_ylabel("z")
    axes[1].set_title("(r, z) phase")

    plt.tight_layout(rect=[0, 0, 1, 0.95])
    path = f"{OUT}/dm3_inner_basin.png"
    plt.savefig(path, bbox_inches="tight")
    plt.close()
    print(f"  ✓ {path}")


if __name__ == "__main__":
    print("Generating figures...")
    fig_overview()
    fig_rz_portrait()
    eps, rates = fig_stability_sweep()
    fig_inner_basin()
    print("\nStability sweep (empirical rates):")
    for e, r in zip(eps, rates):
        print(f"  ε = {e:.2f}   μ = {r:.4f}")
    print("Done.")
