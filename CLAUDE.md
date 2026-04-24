# CLAUDE.md

Guidance for Claude Code working in this repository.

## Project

LaTeX document set for a 70 GHz mm-wave phase interpolator using frequency
doubling: an IEEE conference paper and a Beamer presentation series. All work
happens on `master` in a clean monorepo layout. Two long-lived sync branches
mirror the two subdirectories to two separate Overleaf projects.

## Repository layout (clean separation)

```
.
├── CLAUDE.md
├── Makefile
├── pyproject.toml          uv-managed Python env for plot scripts
├── .gitignore              ignores LaTeX build artifacts and output/
│
├── paper/                  ALL paper work goes here
│   ├── main.tex            IEEEtran conference, \input{sections/*}
│   ├── main.pdf            committed alongside source
│   ├── references.bib
│   ├── sections/           introduction, architecture, circuit, analysis,
│   │                       simulation, conclusion
│   └── figures/            PDF/PGF imports from Python scripts
│
├── presentation/           ALL presentation work goes here
│   ├── main.tex            current week's deck (Beamer + Moloch, 16:9)
│   ├── main.pdf            committed alongside source
│   ├── figures/            shared, reusable TikZ snippets / PGF / images
│   └── archive/            past weeks' decks, one dir per week
│       ├── INDEX.md        date · topic · directory table
│       └── YYYY-MM-DD-slug/   {main.tex, main.pdf} snapshot
│
├── output/                 (gitignored) final compiled PDFs land here:
│                           output/paper.pdf, output/presentation.pdf
│
└── references/             (gitignored / untracked) reference PDFs for reading
```

**Hard rule:** anything related to the paper goes under `paper/`. Anything
related to the presentation goes under `presentation/`. The repository root
holds only project-wide infrastructure (Makefile, CLAUDE.md, pyproject,
.gitignore).

## Build

`output/` is the canonical location for the final PDFs.

```bash
make paper           # builds paper/main.pdf, copies to output/paper.pdf
make presentation    # builds presentation/main.pdf, copies to output/presentation.pdf
make all             # both
make clean           # remove latex aux files and output/
```

After any rewrite of either document, **always run the corresponding `make`
target** so the PDF in `output/` reflects the source.

## Weekly presentation workflow

The live `presentation/main.tex` is *this week's* deck. At week's end:

1. `cp presentation/main.{tex,pdf} presentation/archive/YYYY-MM-DD-slug/`
2. Append the row to `presentation/archive/INDEX.md`.
3. (Optional) `git tag pres/YYYY-MM-DD` for cheap navigation.
4. Start the new week's deck by editing `presentation/main.tex` fresh.
   Reusable figures live in `presentation/figures/` and are `\input`-able
   from any week's `main.tex`.

## Overleaf sync

Two Overleaf projects mirror the two subdirectories. Auth tokens are embedded
in `.git/config` (not committed):

```bash
git remote set-url overleaf-paper https://git:NEW_TOKEN@git.overleaf.com/69e71020130febc4491bc0d8
git remote set-url overleaf-presentation https://git:NEW_TOKEN@git.overleaf.com/69e7110aca33bf212bc5d0d0
```

Overleaf wants a flat project at root, but our work lives in subdirectories.
Sync uses an **overlay approach**: a temporary branch is built on top of
Overleaf's tip, the local subdirectory is overlaid at root, the result is
pushed. (Plain `git subtree push` cannot fast-forward Overleaf — the repo was
bootstrapped without a shared ancestor.)

```bash
make push-paper         # paper/        → overleaf-paper:master
make push-presentation  # presentation/ → overleaf-presentation:master

make pull-paper         # overleaf-paper:master → paper/
make pull-presentation  # overleaf-presentation:master → presentation/

git push                # sync master to GitHub (origin)
```

**Overleaf forbids force pushes.** All overlay commits are normal
fast-forwards on top of Overleaf's tip.

## Python / plot scripts

Managed with `uv`. Scripts export PDF or PGF into the right subdirectory's
`figures/`.

```bash
uv sync                  # create / update .venv
uv run <script>
```

Prefer inline TikZ / PGFPlots for analytically defined plots. Use matplotlib
only for data-driven plots (simulation output, measured data).

## Architecture and key concepts

**Signal chain:** 35 GHz wirebond input → buffer → reflection-based 90°
coupler → transmission line (creates quadrature y-phase) → current-mode phase
interpolator (CMPI) → ×2 frequency doubler → 70 GHz output. A direct 35 GHz
injection path locks the doubler.

**Frequency doubling rationale:** CMPI operates at 35 GHz, relaxing bandwidth
requirements. Phase noise degrades by exactly +6 dB (20 log₁₀ 2) but absolute
jitter is preserved.

**Phase interpolation:** CMPI weights two boundary phasors V₁ and V₂ via CML
tail currents. Weight ratio: W₂/W₁ = sin(φ − φ₁)/sin(φ₂ − φ). Coarse control
= boundary phasor selection; fine control = tail-current ratio.

**VGA / phase shifter:** Active-feedback VGA with doublet zero-pole pair for
gain shaping across 30–40 GHz. APF network provides ±90° continuous phase
tuning at 35 GHz.

**Injection locking:** Clamps doubler phase noise to L_in + 6 dB within
f_L ≈ 50 MHz; reverts to free-running profile beyond f_L.

## LaTeX conventions

- Wide figures use `figure*` (IEEEtran double-column). Phasor diagram is
  single-column `figure`.
- TikZ libraries already loaded in both `main.tex`s:
  `shapes.geometric, arrows.meta, positioning, calc`.
- Use `\SI{}{}` and `\SIrange{}{}{}` (siunitx) for all quantities with units.
- Cross-references: `\eqref` for equations, `\ref` for figures/sections.
- Presentation theme: `moloch` (Metropolis fork, TeX Live ≥ 2024). Fallback:
  `\usetheme{metropolis}`.
