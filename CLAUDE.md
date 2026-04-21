# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

LaTeX document set explaining the circuit design and theory of a 70 GHz mm-wave phase interpolator using frequency doubling. Synced to an Overleaf repository (git remote).

## Overleaf sync

The repo has two Overleaf projects, one per subdirectory, kept in sync via `git subtree`. The remotes are named `overleaf-paper` and `overleaf-presentation`.

```bash
# Push local changes to Overleaf
make push-paper
make push-presentation

# Pull Overleaf edits back (squash-merged)
make pull-paper
make pull-presentation
```

Never push the repo root to Overleaf — only the subtree targets above. Overleaf expects `main.tex` at the project root, which maps to `paper/main.tex` and `presentation/main.tex` respectively.

## Build commands

```bash
# Paper (from repo root)
latexmk -pdf -cd paper/main.tex

# Presentation
latexmk -pdf -cd presentation/main.tex

# Clean build artefacts
latexmk -C -cd paper/main.tex
latexmk -C -cd presentation/main.tex
```

## Python / plot scripts

Managed with `uv`. Scripts that produce figures must export PGF or PDF and drop the output into `paper/figures/` or `presentation/figures/`.

```bash
uv sync          # create/update .venv
uv run <script>  # run a plot script
```

Prefer inline TikZ/PGFPlots over Python/matplotlib for plots that can be expressed analytically. Use matplotlib only for data-driven plots (simulation output, measured data).

## Repository layout

```
paper/
  main.tex              IEEEtran conference, \input{sections/*}
  references.bib
  sections/
    introduction.tex
    architecture.tex    block diagram (fig:arch)
    circuit.tex         VGA + APF Bode plot (fig:bode), CML schematic
    analysis.tex        phasor diagram (fig:phasor), phase noise equations
    simulation.tex      phase noise profiles (fig:pn), post-layout results
    conclusion.tex
  figures/              imported graphics (PDF/PGF from Python scripts)

presentation/
  main.tex              Beamer + Moloch theme, 16:9
  figures/
```

## Architecture and key concepts

**Signal chain:** 35 GHz wirebond input → buffer → reflection-based 90° coupler → transmission line (creates quadrature y-phase) → current-mode phase interpolator (CMPI) → ×2 frequency doubler → 70 GHz output. A direct 35 GHz injection path locks the doubler.

**Frequency doubling rationale:** The CMPI operates at 35 GHz (half the output frequency), relaxing bandwidth requirements. The ×2 doubler then produces 70 GHz. Key consequence: phase noise degrades by exactly +6 dB (20 log₁₀ 2) but absolute jitter is preserved.

**Phase interpolation:** The CMPI weights two boundary phasors V₁ and V₂ via CML tail currents. The weight ratio follows the sine rule: W₂/W₁ = sin(φ − φ₁)/sin(φ₂ − φ). Boundary phasor selection is coarse control; tail-current ratio is fine control.

**VGA / phase shifter:** Active-feedback VGA with a doublet zero-pole pair shapes gain across 30–40 GHz. All-pass filter (APF) network provides ±90° continuous phase tuning at 35 GHz without disturbing the gain profile.

**Injection locking:** Clamps doubler output noise to the L_in + 6 dB bound within the locking bandwidth f_L ≈ 50 MHz; beyond f_L the doubler reverts to its free-running noise floor.

## LaTeX conventions

- Wide figures (block diagram, Bode plot, phase noise plot) use `figure*` in the paper for IEEEtran double-column span.
- Inline TikZ figures use `\usetikzlibrary{shapes.geometric, arrows.meta, positioning, calc}` — already loaded in both `main.tex` files.
- `\SI{}{}` and `\SIrange{}{}{}` (siunitx) for all numeric quantities with units.
- Cross-references use `\eqref` for equations, `\ref` for figures/sections.
- Overleaf compiler target must be set to `paper/main.tex` or `presentation/main.tex` in Overleaf project settings.
