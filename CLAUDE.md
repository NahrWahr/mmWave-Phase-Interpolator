# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

LaTeX document set for a 70 GHz mm-wave phase interpolator using frequency doubling: one IEEE conference paper and one Beamer presentation.

## Branch layout

| Branch | Contents | Overleaf remote |
|---|---|---|
| `master` | CLAUDE.md, Makefile, scripts | — |
| `paper` | flat paper project (main.tex, references.bib, sections/) | `overleaf-paper` |
| `presentation` | flat presentation project (main.tex, figures/) | `overleaf-presentation` |

Each document branch maps 1-to-1 with its Overleaf project root — no subdirectory prefix.

## Overleaf sync

Two Overleaf remotes are configured in `.git/config` (not committed):

Auth token is embedded in the remote URLs inside `.git/config`. To update it:
```bash
git remote set-url overleaf-paper https://git:NEW_TOKEN@git.overleaf.com/69e71020130febc4491bc0d8
git remote set-url overleaf-presentation https://git:NEW_TOKEN@git.overleaf.com/69e7110aca33bf212bc5d0d0
```

**Overleaf prohibits force pushes.** Pushes are normal fast-forwards; pulls use `git update-ref` to advance the local branch without a checkout.

```bash
make push-paper          # git push overleaf-paper paper:master
make push-presentation   # git push overleaf-presentation presentation:master
git push                 # sync all branches to GitHub (origin)

make pull-paper          # fetch + fast-forward local paper branch
make pull-presentation
```

## Build

Check out the relevant branch first, then build:

```bash
git checkout paper
latexmk -pdf main.tex    # or: make build-paper (from master, no-op if not on branch)

git checkout presentation
latexmk -pdf main.tex
```

## Python / plot scripts

Managed with `uv`. Scripts export PDF or PGF into `figures/` on the respective branch.

```bash
uv sync          # create/update .venv
uv run <script>
```

Prefer inline TikZ/PGFPlots for analytically defined plots. Use matplotlib only for data-driven plots (simulation output, measured data).

## Repository layout

**`paper` branch:**
```
main.tex              IEEEtran conference, \input{sections/*}
main.pdf
references.bib
sections/
  introduction.tex
  architecture.tex    block diagram (fig:arch)
  circuit.tex         VGA + APF Bode plot (fig:bode)
  analysis.tex        phasor diagram (fig:phasor), phase noise equations
  simulation.tex      phase noise profiles (fig:pn)
  conclusion.tex
figures/              imported PDF/PGF from Python scripts
```

**`presentation` branch:**
```
main.tex              Beamer + Moloch theme, 16:9
main.pdf
figures/
```

## Architecture and key concepts

**Signal chain:** 35 GHz wirebond input → buffer → reflection-based 90° coupler → transmission line (creates quadrature y-phase) → current-mode phase interpolator (CMPI) → ×2 frequency doubler → 70 GHz output. A direct 35 GHz injection path locks the doubler.

**Frequency doubling rationale:** CMPI operates at 35 GHz, relaxing bandwidth requirements. Phase noise degrades by exactly +6 dB (20 log₁₀ 2) but absolute jitter is preserved.

**Phase interpolation:** CMPI weights two boundary phasors V₁ and V₂ via CML tail currents. Weight ratio: W₂/W₁ = sin(φ − φ₁)/sin(φ₂ − φ). Coarse control = boundary phasor selection; fine control = tail-current ratio.

**VGA / phase shifter:** Active-feedback VGA with doublet zero-pole pair for gain shaping across 30–40 GHz. APF network provides ±90° continuous phase tuning at 35 GHz.

**Injection locking:** Clamps doubler phase noise to L_in + 6 dB within f_L ≈ 50 MHz; reverts to free-running profile beyond f_L.

## LaTeX conventions

- Wide figures use `figure*` (IEEEtran double-column). Phasor diagram is single-column `figure`.
- TikZ libraries already loaded in both `main.tex`: `shapes.geometric, arrows.meta, positioning, calc`.
- Use `\SI{}{}` and `\SIrange{}{}{}` (siunitx) for all quantities with units.
- Cross-references: `\eqref` for equations, `\ref` for figures/sections.
- Presentation theme: `moloch` (Metropolis fork, TeX Live ≥ 2024). Fallback: `\usetheme{metropolis}`.
