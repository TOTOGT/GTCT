# B3 — Principia Orthogona Book 3: The Mini-Beast

**Living book repo · Paid access · G6 LLC · 2026**

> "Your education is yours. No one can take it away from you."  
> — Pablo Nogueira Grossi, Newark NJ · *The Seed*

**Buy access:** [g6llc.gumroad.com/l/soundworks](https://g6llc.gumroad.com/l/soundworks)  
**IMPA Portal:** [totogt.github.io/AXLE/impa-portal.html](https://totogt.github.io/AXLE/impa-portal.html)  
**Public site:** [totogt.github.io/3M](https://totogt.github.io/3M/)

---

## Submodules

| Module | Repository | Description |
|---|---|---|
| AXLE | [TOTOGT/AXLE](https://github.com/TOTOGT/AXLE) | AXLE v6.1 formal verification, series homepage |
| DM3-lab | [TOTOGT/DM3-lab](https://github.com/TOTOGT/DM3-lab) | Interactive simulators, student portal, preprints |
| book3-starter | [TOTOGT/book3-starter](https://github.com/TOTOGT/book3-starter) | Starter pack for new Book 3 readers |

```bash
git submodule update --init --recursive
```

---

## HTML Chapters — allRevised B3 Chapters

### Entry Points & Navigation

| File | Description |
|---|---|
| `index.html` | Main entry point |
| `living-book.html` | Living book hub — all chapters |
| `book3-starter-index.html` | Starter pack index for new readers |
| `dm3-lab-index.html` | DM3-lab mirror index |
| `course-16weeks.html` | 16-week structured course program A1→D1 |
| `journey.html` | The A1→D2 journey overview |
| `chapters-diagram.html` | Visual chapter map |
| `trilogy-sale.html` | Series sale page |
| `labyrinth.html` | Extended navigation / labyrinth structure |

### Core Sequence — Book 3 Chapters

| File | Chapter | Operator | Topic |
|---|---|---|---|
| `ch00-introduction.html` | 0 | — | Introduction to The Mini-Beast |
| `ch01-cajueiro.html` | 1 | C | The Cajueiro Principle — seed and fixed point |
| `ch01-dm3-framework.html` | 1b | C | The dm³ Framework — operator overview |
| `ch02-biological.html` | 2 | C→K | Biological Instantiations |
| `ch02-reading.html` | 2b | C→K | Reading and Compression |
| `ch03-plasma.html` | 3 | K | Plasma Reconnection |
| `ch03-sources.html` | 3b | K | Sources and Evidence |
| `ch03-circadian.html` | 3c | K | Circadian Regulation |
| `ch04-markets.html` | 4 | K | Market Volatility Manifolds |
| `ch04-milestone1.html` | 4b | K | Milestone 1 Assessment |
| `ch04-neural.html` | 4c | K | Neural Oscillations — K threshold, Kuramoto sync |
| `ch05-oscillations.html` | 5 | K→F | Oscillations and Coherence |
| `ch05-immune.html` | 5b | F | Immune Memory |
| `ch06-argument.html` | 6 | F | The Argument Structure |
| `ch06-pedagogy.html` | 6b | F | Pedagogy as Mathematical Necessity |
| `ch06-resonant.html` | 6c | F | Resonant Systems |
| `ch1-seed.html` | — | C | The Seed (standalone) |
| `ch2-allostatic.html` | — | C→K | Allostatic Load |
| `ch3-circadian.html` | — | K | Circadian (standalone) |
| `ch4-neural.html` | — | K | Neural Oscillations (standalone) |
| `ch5-immune.html` | — | F | Immune Memory (standalone) |
| `ch6-resonant.html` | — | F | Resonant Systems (standalone) |

### Upper Chapters

| File | Chapter | Operator | Topic |
|---|---|---|---|
| `ch7-crystalline.html` | 7 | F→U | Crystalline Structures — Wigner, moiré |
| `ch7-crystalline (2).html` | 7b | F→U | Crystalline (revised) |
| `ch8-axiomatic.html` | 8 | U | The Axiomatic Foundation |
| `ch8-axiomatic (1).html` | 8b | U | Axiomatic (revised) |
| `ch8-meru.html` | 8c | U | Meru — sacred geometry as dm³ |
| `ch8-meru (1).html` | 8d | U | Meru (revised) |
| `ch9-phi.html` | 9 | U | Phi — the golden ratio as fixed point |
| `ch10-lyapunov.html` | 10 | U | Lyapunov Exponents and Stability |
| `ch11-spectral.html` | 11 | U→G | Spectral Radius — transfer operator |
| `ch12-conclusion.html` | 12 | G | Conclusion — Complete Completeness |
| `ch13-revision.html` | 13 | — | Revision and Synthesis |
| `ch14-axle.html` | 14 | — | AXLE — Formal Verification Chapter |

### Bonus Chapters

| File | Label | Topic |
|---|---|---|
| `chE-gtct.html` | Bonus E | GTCT for Everyone — 9 axioms, 12 operators, 4 theorems, A1→D1 prompts |
| `ch-e-gtct.html` | Bonus E (alt) | GTCT (earlier version) |
| `chW-wigner.html` | Bonus W | The Wigner Crystal — dm³ fold diagram, interactive |
| `chPI-recurrence.html` | Bonus π | The Recurrence Ladder — π, φ, μ, η, Δ, Σ, Ω |
| `chapters-pi-phi-mu-eta-delta-sigma-omega.html` | Bonus π–Ω | Full recurrence ladder (extended) |
| `sample-chapter-tubulin.html` | Sample T | Tubulin as Computronium (public sample) |
| `sample-chapter-wigner.html` | Sample W | The Wigner Crystal (public sample) |

### Interactive Simulations & Tools

| File | Description |
|---|---|
| `spectral-radius.html` | Spectral radius — Syracuse return map, Collatz |
| `spectral-radius-v2.html` | Spectral radius v2 (revised, live at AXLE) |
| `wigner-fractal.html` | Wigner crystal interactive fold diagram |

### Portals & Sales

| File | Description |
|---|---|
| `impa-portal.html` | IMPA purchase portal — PayPal, pricing, delivery |
| `impa-portal (2).html` | IMPA portal (earlier version) |

---

## Lean 4 / AXLE Formal Proofs

| File | Description |
|---|---|
| `Main.lean` | Main AXLE file |
| `Main_v2.lean` – `Main_v5.lean` | Version history |
| `Main_v3_corrected.lean` | Corrected v3 |
| `DiscreteDM3Bridge.lean` | Discrete dm³ bridge theorem |
| `Finite.lean` | Finite case formalisation |
| `lakefile.lean` | Lean 4 lake build file |
| `lean-toolchain` | Lean version pin |

---

## LaTeX Manuscript Source

| File | Description |
|---|---|
| `master_book_FINAL_v2.tex` | **Master manuscript — current** |
| `master_book_FINAL.tex` | Master (prior version) |
| `master_book_FINAL_1.tex` | Master (prior version) |
| `master_book.tex` | Master (earlier) |
| `master_book_corrected.tex` / `_corrected-2.tex` | Corrected versions |
| `MASTER.tex` | Root master file |
| `main.tex` / `main-2.tex` / `main-3.tex` / `main-4.tex` | Main variants |
| `main-2-fixed.tex` / `main-2-fixed-2.tex` / `main_fixed.tex` | Fixed variants |
| `completePrincipia.tex` | Complete Principia source |
| `principia_vol2.tex` | Volume II source |
| `book321.tex` | Combined book source |
| `book2_outline.tex` | Volume II outline |
| `book2_preface_ch1.tex` | Volume II preface/ch1 |
| `vol2_section2.tex` / `vol2_section3.tex` | Volume II sections |
| `Fractal_Time_Crystals_clean.tex` | Fractal Time Crystals chapter |
| `Fractal Time Crystals.tex` | Fractal Time Crystals (earlier) |
| `Monster13.tex` / `Monster13.tex 2` | Monster paper |
| `MonsterPaper_GROSSI2026_clean.tex` / `_(1).tex` | Monster (cleaned) |
| `minibeast_gtct_chapter_E.tex` | Chapter E LaTeX source |
| `formalizations_Book2.tex` | Book 2 formalisations |
| `g6_scale_invariance.tex` | Scale invariance paper |
| `chapter 09 mars.tex` | Chapter 9 Mars |
| `chapter_eight_things.tex` | Chapter 8 things |
| `letter_to_the_pope.tex` | Letter to the Pope |

---

## PDFs

| File | Description |
|---|---|
| `Book3_VolIII_MiniBeast_eBook-combined copy-combined copy.pdf` | Book 3 eBook (full) |
| `mini_beast_complete.pdf` | Mini-Beast complete |
| `mini_beast.pdf` | Mini-Beast (shorter) |
| `mini_beast_ch2.pdf` | Chapter 2 |
| `mini_beast_ch3.pdf` | Chapter 3 |
| `mini_beast_ch6.pdf` | Chapter 6 |
| `Principia_Orthogona_Vol_1_Grossi3.2026.pdf` | Volume I |
| `Principia_Orthogona_Vol2_Grossi3.2026.pdf` | Volume II |
| `Binder2.pdf` | Binder collection |
| `cd7e41e3-…-minibeast_gtct_chapter_E.pdf` | Chapter E PDF |
| `0736f377-…-mini_beast_ch6.pdf` | Chapter 6 (upload copy) |
| `648d8966-…-minibeast (1).pdf` | Mini-Beast (upload copy) |
| `989f8f44-…-minibeast.pdf` | Mini-Beast (upload copy) |

---

## Python / Scripts

| File | Description |
|---|---|
| `bridges.py` | Coherence bridge computation |
| `collatz_c9_2_fourier_v2.py` | Collatz Fourier analysis |
| `collatz_c9_2_sampling_option1.py` | Collatz sampling |

---

## Other Files

| File | Description |
|---|---|
| `FILES_MANIFEST.txt` | File manifest (older) |
| `README-CHAPTERS.txt` | Chapter notes (older) |
| `README.md` | This file |
| `README 2.md` | Earlier README |
| `DO NOT READ ME.md` | Internal notes |
| `PROJECT-STATE.md` | Project state tracking |
| `axle_sorry_roadmap.svg` | AXLE sorry roadmap diagram |
| `axle_sorry_roadmap 2.svg` | AXLE roadmap (variant) |
| `.gitmodules` | Submodule configuration |

---

## Folder structure

| Folder | Contents |
|---|---|
| `AAA/` | Internal staging / scratch |
| `AXLE/` | AXLE submodule |
| `DM3-lab/` | DM3-lab submodule |
| `Orthogenesis/` | Orthogenesis materials |
| `allB3/` | All B3 chapters collection |
| `book3-starter/` | book3-starter submodule |

---

## The Principia Orthogona series

| Volume | Title | ISBN | Status |
|---|---|---|---|
| G¹ | The Orthogonal Operator Framework | 979-8-9954416-2-5 | Published |
| G² | TOGT: Applications Across Domains | 979-8-9954416-4-9 | Published |
| G³ | **The Mini-Beast** | 979-8-9954416-6-3 | **This repo** |
| G⁴ | GTCT T1 — The IMPA Edition | included | Submitted to IMPA |
| G⁵ | The Seed — Complete Completeness | 979-8-9954416-5-6 | Published |

**Buy:** [g6llc.gumroad.com/l/soundworks](https://g6llc.gumroad.com/l/soundworks)  
**PayPal eBook:** [paypal.me/pgrossi/213.24](https://www.paypal.com/paypalme/pgrossi/213.24)  
**PayPal Hardcover:** [paypal.me/pgrossi/263.36](https://www.paypal.com/paypalme/pgrossi/263.36)

---

## After purchase

1. Pay via Gumroad or PayPal
2. Text your GitHub username to **+1 (646) 342-3751** or include in your PayPal note
3. Added as collaborator within 24 hours
4. Clone: `git clone --recurse-submodules git@github.com:g6-llc/B3.git`

---

## License

Paid access · All rights reserved · © 2026 Pablo Nogueira Grossi — G6 LLC  
ORCID: 0009-0000-6496-2186 · Newark, New Jersey

*Public submodules (AXLE, DM3-lab, book3-starter) retain their original MIT license.*
