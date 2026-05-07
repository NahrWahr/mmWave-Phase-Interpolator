<!-- v1.0 -->
# `figures-lib.tex` — shared figure macro library

**Date:** 2026-04-24
**Status:** Approved, awaiting implementation plan

## Problem

Hand-coded TikZ for every figure is token-expensive to author and to debug.
Common failure modes seen in this repo:

- Each figure invents its own scale, line widths, and coordinate system, so
  edits routinely require fighting `\fitwidth` overflow, overlapping labels,
  and snake-line / text collisions.
- Inline `\def`-with-`#1` macros inside `\fitwidth{...}` arguments interact
  badly with PGF `\foreach`'s `\iterate`, producing misleading error
  messages (one full build cycle wasted per occurrence).
- Paper and presentation figures duplicate the same TikZ for the same
  concept (signal chain, phasors, beam steering) with subtly different
  parameters.

## Goal

A small, opinionated TikZ macro library — `figures-lib.tex` — that:

1. Provides high-level primitives for the figure types this project needs:
   phasors, block diagrams, antenna-array / beam-steering schematics, and
   labelled coordinate axes.
2. Carries a **single style switch** (`\figstyle{paper}` / `\figstyle{slides}`)
   that retunes line weights, font sizes, and arrow tips for the medium —
   thick for slides, clean/thin for paper.
3. Centralises the UCI color palette so all macros theme consistently with
   `presentation/uci-theme.tex`.
4. Is extensible: adding a new primitive follows a documented template,
   no rewrites of existing primitives required.

## Non-goals

- Backporting existing figures. Current paper and presentation figures stay
  as-is. The library applies only to figures authored from this point on.
- Vector fields, quiver plots, 3D plots. Deferred until first need.
- Replacing matplotlib for data-driven plots. Library covers analytical /
  schematic figures only.

## Architecture

### File and load path

- Library lives at repo root: `figures-lib.tex`.
- `paper/main.tex` adds in its preamble:
  ```tex
  \input{../figures-lib.tex}
  \figstyle{paper}
  ```
- `presentation/main.tex` adds in its preamble:
  ```tex
  \input{../figures-lib.tex}
  \figstyle{slides}
  ```
- The library is `\input`ed in the preamble only — never inside a
  `tikzpicture` or inside `\fitwidth{...}` (see "Anti-clutter conventions").

### Theme / colors

The library defines the UCI palette using `\providecommand` / `\@ifundefined`
guards so it co-exists with `uci-theme.tex`:

- `uciNavy`, `uciBlue`, `uciAmber`, `uciSand`, `uciGold`, `uciGoldPale`,
  `uciCream`.

The library defines the palette unconditionally with `\providecommand` /
`\@ifundefined{<colorname>}{...}` guards. `presentation/main.tex` already
gets the palette via `uci-theme.tex`, so the library's guards are no-ops
there. `paper/main.tex` picks up the palette from the library itself,
keeping a single source of truth.

### Style switch

`\figstyle{...}` sets a single `\tikzset` block under the `figlib/.cd`
namespace:

| key                     | `slides`         | `paper`          |
| ----------------------- | ---------------- | ---------------- |
| `figlib/line`           | `thick`          | `semithick`      |
| `figlib/thin`           | `semithick`      | `thin`           |
| `figlib/font`           | `\scriptsize`    | `\footnotesize`  |
| `figlib/tip`            | `Stealth[length=2mm]` | `Stealth[length=1.5mm]` |
| `figlib/label sep`      | `2pt`            | `1pt`            |

Every primitive draws using these styles, so changing the medium retunes
the entire figure set without per-figure edits.

### Primitive inventory (v1)

Atoms — `\newcommand`. Single optional positional arg = color (default
listed). Unlabelled / labelled split into separate macros to keep call
sites short and avoid keyval overhead for atoms:

- `\phasor[<color>]{<angle-deg>}{<magnitude>}` — arrow from origin.
- `\phasorL[<color>]{<angle-deg>}{<magnitude>}{<label>}` — same, with a
  label placed just past the tip along the same angle.
- `\phaseArc[<color>]{<from-deg>}{<to-deg>}{<radius>}{<label>}` — arc with
  label; used for angle indicators between two phasors.
- `\signal[<color>]{<from-coord>}{<to-coord>}` — directed arrow.
- `\signalL[<color>]{<from>}{<to>}{<label>}` — same, label at midpoint.

Composites — TikZ `pic`s (anchor at `(0,0)` of the local frame):

- `pic{phasor sum=<list>}` — head-to-tail composition of phasors.
- `pic{block=<label>}` — labelled rectangle (size from style).
- `pic{sum node}` — summing junction (`+` in a circle).
- `pic{mixer}` — multiplier (`×` in a circle).
- `pic{branch node}` — fan-out (filled small disk).
- `pic{antenna array=<N>}` with options `spacing=`, `labels=`,
  `label position=above|below`.
- `pic{wavefronts=<N>}` with options `angle=`, `length=`, `arrow=true`.
- `pic{beam lobe}` with options `angle=`, `scale=`, `sidelobes=true`.
- `pic{delay block}` with options `cycles=` (0 → straight wire,
  1..N → that many sine cycles inside the block, snake folded in here).
- `pic{axes xy}` with options `xlabel=`, `ylabel=`, `xrange=`, `yrange=`.

Total: 3 atoms + 9 pics = 12 primitives. All accept an anchor / position
through standard TikZ `pic` placement (`\path (1,2) pic{block=Buffer};`).

### Anti-clutter conventions (codified)

These rules live in the library's header comment so they survive into
future maintenance:

1. Every macro / pic is positioned by its caller — no macro picks its own
   coordinates. Composability over convenience.
2. Every macro's bounding box is documented at the call site (in a
   one-line comment in the lib) so callers can reserve space.
3. No `\def` with `#1` parameters inside `\fitwidth{...}` or inside a
   `\foreach` body. This is what produced the
   `! Illegal parameter number in definition of \iterate` errors.
4. The library is `\input`ed in the document preamble. Never inside
   `tikzpicture`, `\fitwidth`, or `\resizebox` arguments.
5. Defaults assume the active `\figstyle{...}`. Per-figure overrides go
   through `\tikzset{figlib/...}` at the top of that figure's
   `tikzpicture`, not through hardcoded `thick` / `\scriptsize` overrides.

### Extensibility

To add a new primitive:

1. Add a labelled section to `figures-lib.tex`.
2. Define the atom (`\newcommand`) or composite (`\tikzset{pics/.../.style=...}`).
3. Use `figlib/line`, `figlib/font`, etc. for all styling — never hardcoded.
4. Document the bounding box in a one-line comment above the definition.
5. No new dependencies without spec amendment.

## Migration

- No backport. Existing figures continue to compile from their inline
  TikZ.
- New rule, added to `CLAUDE.md`: figures authored from 2026-04-24 onward
  must use `figures-lib.tex` primitives. If a needed primitive doesn't
  exist, extend the library first (per "Extensibility") and then use it.
- The Application-3 phased-array figure currently in `presentation/main.tex`
  is a candidate first conversion once the library exists, since it
  exercises every array/beam/delay primitive.

## Open questions

None at design time. Open issues will be tracked in the implementation
plan.
