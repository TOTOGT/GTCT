#!/usr/bin/env python3
"""
figures.py — regenerates the figures for

  "The Riemann Hypothesis as Non-Integrability of an Arithmetic Contact
   Structure on the Adele Class Space", Pablo Nogueira Grossi, v1.

    pip install mpmath matplotlib
    python3 figures.py

Produces:
    fig1_rh_lift.pdf / .png   the lift: what the third coordinate buys
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D          # noqa: F401
from mpmath import mp, mpc, zeta
import numpy as np

mp.dps = 15
T0, T1, N = 0.0, 34.0, 1400
ts = np.linspace(T0, T1, N)

SIG = [(0.30, "#c9a227", "σ = 0.30"),
       (0.50, "#c0392b", "σ = ½  (self-mirror)"),
       (0.70, "#1b7f79", "σ = 0.70")]

def curve(sig):
    U, V = [], []
    for t in ts:
        z = zeta(mpc(sig, t))
        U.append(float(z.real)); V.append(float(z.imag))
    return np.array(U), np.array(V)

data = {s: curve(s) for s, _, _ in SIG}

fig = plt.figure(figsize=(11, 5.0))

# ---- left: the 2D phase plane, t invisible --------------------------------
ax1 = fig.add_subplot(1, 2, 1)
for s, col, lab in SIG:
    U, V = data[s]
    ax1.plot(U, V, color=col, lw=.9, alpha=.9, label=lab)
ax1.plot([0], [0], "k+", ms=9, mew=1.4)
ax1.set_xlabel("U = Re ζ"); ax1.set_ylabel("V = Im ζ")
ax1.set_title("Without the lift\nt is a parameter; the curves overlap", fontsize=10)
ax1.axhline(0, color="#bbb", lw=.5); ax1.axvline(0, color="#bbb", lw=.5)
ax1.set_aspect("equal", adjustable="datalim")
ax1.legend(fontsize=7, loc="upper left", framealpha=.9)

# ---- right: the lift, t as a coordinate -----------------------------------
ax2 = fig.add_subplot(1, 2, 2, projection="3d")
for s, col, lab in SIG:
    U, V = data[s]
    ax2.plot(U, V, ts, color=col, lw=.9, alpha=.95, label=lab)
# mark the first five zero heights on the critical-line curve
for g in [14.134725, 21.022040, 25.010858, 30.424876, 32.935062]:
    if T0 <= g <= T1:
        ax2.scatter([0], [0], [g], color="#c0392b", s=16, depthshade=False)
ax2.plot([0, 0], [0, 0], [T0, T1], color="#c0392b", lw=.6, ls=":", alpha=.6)
ax2.set_xlabel("U", labelpad=-4); ax2.set_ylabel("V", labelpad=-4)
ax2.set_zlabel("t", labelpad=-4)
ax2.set_title("With the lift\nt is a coordinate; the curves separate,\n"
              "and each zero is a puncture of the axis", fontsize=10)
ax2.view_init(elev=18, azim=-58)
ax2.tick_params(labelsize=6)
for a in (ax2.xaxis, ax2.yaxis, ax2.zaxis):
    a.pane.set_alpha(.04)

fig.suptitle("Figure 1 — The lift.  Interactive version: "
             "totogt.github.io/geometry/book4/ch12.html  (Fig 12.1)",
             fontsize=8.5, y=.02, color="#444")
fig.tight_layout(rect=[0, .045, 1, 1])
fig.savefig("fig1_rh_lift.pdf", bbox_inches="tight")
fig.savefig("fig1_rh_lift.png", dpi=170, bbox_inches="tight")
print("wrote fig1_rh_lift.pdf and .png")
