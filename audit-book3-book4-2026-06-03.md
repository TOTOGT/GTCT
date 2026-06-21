# Audit — totogt.github.io/geometry — Book 3 & Book 4
**Date:** 2026-06-03  
**Scope:** All HTML pages under `totogt.github.io/geometry/` and `totogt.github.io/geometry/book4/`

---

## Site Structure

### Book 3 — The Mini-Beast (Vol. III)
Pages in the **main nav** (standard bar): Prelude, Ch1–Ch12, Epilogue(Ch17), Collatz(ChH), Ocio, Overture, IMPA, Portal  
Pages **deployed but absent from main nav**: Ch13, Ch15, Ch16, ch7-topological-orthogenesis, ch8-nested-infinities  
Pages **missing entirely** (404): Ch14

### Book 4 — /book4/
Only one page deployed: `book4/chE-gtct.html`  
Three other Book 4 pages referenced from chE are all 404.

---

## A. Broken Links (hard 404s)

| Source page | Link text / anchor | Broken URL | Notes |
|---|---|---|---|
| ch3c-econophysics | "Ch 4b: Market Volatility →" | `ch04-markets.html` | Page never deployed |
| ch7-crystalline | "← Chapter 6 · Resonant" (header) | `ch6-resonant.html` | Correct URL is `ch6-resonance.html` |
| ch7-crystalline | "Chapter 8 → (forthcoming)" (footer) | `access-required.html` | Ch8 exists at `ch8-axiomatic.html` |
| ch8-axiomatic | "Chapter 9 → (forthcoming)" (footer) | `access-required.html` | Ch9 exists at `ch9-phi.html` |
| ch8-axiomatic | "Support the Newark Wellness Center →" | `newark-wellness.html` | Page never deployed |
| book4/chE-gtct | "☰ All Chapters" | `book4/living-book.html` | 404 |
| book4/chE-gtct | "← Ch 7 · The Crystalline Return" | `book4/ch7-crystalline.html` | Should be `../ch7-crystalline.html` |
| book4/chE-gtct | "Ch T · Tubulin →" | `book4/chT-tubulin.html` | Page never deployed |

**Total hard 404s: 8**

---

## B. Wrong-URL Links (page exists but wrong slug used)

| Source page | Link text | URL used | Correct URL | Impact |
|---|---|---|---|---|
| ch6-resonance | "Chapter 7 · Topological Orthogenesis →" (footer) | `ch7-topological-orthogenesis.html` | `ch7-crystalline.html` (nav canonical) | Both 200, but navigates to shadow version |
| ch9-phi | "← Ch8 · Axiomatic" (footer) | `ch8-nested-infinities.html` | `ch8-axiomatic.html` (nav canonical) | Both 200, but navigates to shadow version |

---

## C. Navigation Bar Inconsistencies

The standard full nav bar (Prelude through Portal, 20 links) is present on most chapters but is missing or replaced on several pages:

| Page | Nav status | Missing items |
|---|---|---|
| ch1-neural | Short nav | Ch3c, Epilogue, Collatz, Ocio, Overture |
| ch6-resonance | Short nav | Ch3c, Epilogue, Collatz, Ocio, Overture |
| ch8-axiomatic | Minimal nav (prev/next + section anchors only) | Full global nav absent |
| ch11-spectral | Alternative nav: AXLE Portal · Map · 16 Weeks · S-Portal · Trilogy | Full chapter nav absent |
| ch12-conclusion | Same as Ch11 | Full chapter nav absent |
| ch17-epilogue | Near-bare (just "Portal" at bottom) | Full nav absent |
| chH-collatz | Custom nav: Hub · Engineering Supplement · AXLE · Zenodo | Standard chapter nav absent |
| overture | Custom nav (missing Ch3c, Epilogue, Collatz, Ocio) | Partial |
| book4/chE-gtct | Own mini-nav only (Axioms · Tiers · Operators…) | No link back to Book 3 chapters |

---

## D. Deployed Pages Missing from Main Nav

These pages are live and reachable but are not linked from the standard nav bar:

| URL | Title | Linked from |
|---|---|---|
| `ch13-revision.html` | Revision | Ch12 footer "Ch13 →" |
| `ch15-entropy.html` | Entropy | Ch14 chain (ch14 itself is 404) |
| `ch16-scale.html` | Scale | Ch15 footer |
| `ch7-topological-orthogenesis.html` | Topological Orthogenesis | Ch6 footer |
| `ch8-nested-infinities.html` | Nested Infinities | Ch9 back-link |

---

## E. Duplicate / Shadow Chapter Pages

Ch7 and Ch8 each have two deployed versions with different content/titles:

| Canonical (in nav) | Shadow (linked from elsewhere) |
|---|---|
| `ch7-crystalline.html` — "The Crystalline Return" | `ch7-topological-orthogenesis.html` — "Topological Orthogenesis" |
| `ch8-axiomatic.html` — "The Axiomatic Turn" | `ch8-nested-infinities.html` — title TBD |

These appear to be earlier drafts or alternate versions. No disambiguation or redirect in place — a reader following chapter-to-chapter footers ends up on a different edition than a reader following the nav bar.

---

## F. Missing Chapter (Ch14 = 404)

`ch14-sorry.html` returns 404. Ch13 presumably links forward to it; Ch15 is deployed and presupposes Ch14 has been read. This breaks the Ch13 → Ch14 → Ch15 sequence.

---

## G. Book 4 Identity / Structural Issues

- The only Book 4 page deployed is `book4/chE-gtct.html`.
- Its `<title>` and heading say **"Principia Orthogona · Book 3 · Extended Chapter E"** — the page identifies itself as Book 3, not Book 4, despite living in `/book4/`.
- Its back-link points to `book4/ch7-crystalline.html` (404) rather than `../ch7-crystalline.html` (200).
- The forward link (`book4/chT-tubulin.html`) and the all-chapters index (`book4/living-book.html`) are both 404 — the Book 4 section is a stub with one orphaned page.

---

## H. Minor Issues

- **Ch3c** references `chapters-diagram.html` in an inline text link — this page **does** exist (200) but is not in the nav.
- **Ch8** links to `<newark-wellness.html>` (angle-bracket literal in HTML source) — this is a malformed relative URL and also 404.
- **Ch17 Epilogue** is in the main nav as "Epilogue" but its footer says "Book 3 · The Mini-Beast · Complete" with `← Ch16` — implying a 17-chapter linear sequence, while the main nav presents it as a standalone link after Ch12.
- **Sportal / Student Portal** navigation buttons "← Previous Level" and "Next Level →" have no `href` — they are non-functional placeholders.

---

## Summary Table

| Category | Count |
|---|---|
| Hard 404 broken links | 8 |
| Wrong-URL links (existing page, wrong slug) | 2 |
| Pages with non-standard / missing nav | 9 |
| Deployed pages absent from main nav | 5 |
| Shadow/duplicate chapter pages | 2 pairs |
| Missing chapter (Ch14 gap) | 1 |
| Book 4 stub issues | 3 |

---

## Priority Fixes

1. **Ch7 and Ch8 footers** — replace `access-required.html` with the correct existing URLs (`ch8-axiomatic.html`, `ch9-phi.html`). Readers hitting these are hard-blocked.
2. **Ch7 back-link** — fix `ch6-resonant.html` → `ch6-resonance.html`.
3. **Book 4 back-link** — fix `book4/ch7-crystalline.html` → `../ch7-crystalline.html`.
4. **Ch14** — deploy or stub `ch14-sorry.html` to restore Ch13→Ch14→Ch15 sequence.
5. **Nav bar** — standardise across Ch8, Ch11, Ch12, Ch17, ChH to include the full chapter nav.
6. **Book 4 identity** — decide: is chE a Book 3 extended chapter or the first Book 4 page? Update title/heading to match.
7. **Ch3c forward link** — deploy `ch04-markets.html` or update the link to an existing page.
8. **newark-wellness.html** — deploy or remove the link from Ch8.
9. **Sportal** — wire up the prev/next level navigation buttons.
10. **Shadow pages** — resolve ch7-topological-orthogenesis and ch8-nested-infinities: either redirect to canonical or add to nav.
