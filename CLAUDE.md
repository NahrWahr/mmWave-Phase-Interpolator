# CLAUDE.md

## Project
LaTeX docs for a 70 GHz mm-wave phase interpolator (frequency doubling): IEEE
conference paper + Beamer presentation series. Work on `master`. Two long-lived
sync branches mirror `paper/` and `presentation/` to separate Overleaf projects.

## Layout
```
.
├── Makefile, pyproject.toml (uv), .gitignore, figures-lib.tex
├── paper/        main.tex (IEEEtran), main.pdf, references.bib,
│                 sections/{intro,architecture,circuit,analysis,sim,conclusion},
│                 figures/  (PDF/PGF from Python)
├── presentation/ main.tex (Beamer+Moloch 16:9, current week), main.pdf,
│                 uci-theme.tex (canonical theme), figures/ (incl. uci-logo),
│                 archive/INDEX.md + archive/YYYY-MM-DD-slug/{main.tex,main.pdf}
├── output/       (gitignored) final paper.pdf, presentation.pdf
└── references/   (untracked) reference PDFs
```
**Hard rule:** paper work → `paper/`, presentation work → `presentation/`. Root
holds only project-wide infra.

## Build
`output/` is canonical for final PDFs. **Always run `make` after edits** — the
PDF in `output/` is the source of truth shown to the user.
```bash
make paper | presentation | all | clean
```

## Weekly presentation workflow
`presentation/main.tex` = this week's deck. **Every week's deck must
`\input{uci-theme.tex}`** (warm-pastel palette, UCI logo top-right on titled
frames, gold footer with page counter + "HIE Lab"). Edit `uci-theme.tex` for
repo-wide look changes — don't redefine palette inline.

End of week:
1. `cp presentation/main.{tex,pdf} presentation/archive/YYYY-MM-DD-slug/`
2. Append row to `presentation/archive/INDEX.md`.
3. (Opt) `git tag pres/YYYY-MM-DD`.
4. Edit `presentation/main.tex` fresh. Reusable figures in `presentation/figures/`
   are `\input`-able from any week.

## Overleaf sync
Two Overleaf projects mirror the subdirs. Auth tokens in `.git/config` (uncommitted):
```bash
git remote set-url overleaf-paper https://git:NEW_TOKEN@git.overleaf.com/69e71020130febc4491bc0d8
git remote set-url overleaf-presentation https://git:NEW_TOKEN@git.overleaf.com/69e7110aca33bf212bc5d0d0
```
Overleaf wants flat root; we use subdirs → **overlay sync**: temp branch on
Overleaf's tip, subdir overlaid at root, pushed as fast-forward. (`git subtree
push` won't work — no shared ancestor.) **Overleaf forbids force pushes.**
```bash
make push-paper | push-presentation | pull-paper | pull-presentation
git push                # master → GitHub origin
```

## Python / plot scripts
`uv`-managed. Scripts export PDF/PGF into the right `figures/`.
```bash
uv sync; uv run <script>
```
Inline TikZ/PGFPlots for analytical plots; matplotlib only for data-driven
(simulation/measured).

## Architecture
- **Signal chain:** 35 GHz wirebond → buffer → reflection-based 90° coupler →
  TL (quadrature y-phase) → CMPI → ×2 doubler → 70 GHz. Direct 35 GHz injection
  path locks the doubler.
- **Doubling rationale:** CMPI runs at 35 GHz (relaxed BW). Phase noise +6 dB
  (20 log₁₀ 2); absolute jitter preserved.
- **Phase interpolation:** CMPI weights phasors V₁, V₂ via CML tail currents.
  W₂/W₁ = sin(φ−φ₁)/sin(φ₂−φ). Coarse = phasor selection; fine = current ratio.
- **VGA / phase shifter:** Active-feedback VGA, doublet zero-pole pair shapes
  gain over 30–40 GHz. APF gives ±90° continuous tuning at 35 GHz.
- **Injection locking:** Clamps doubler PN to L_in + 6 dB within f_L ≈ 50 MHz;
  free-running beyond f_L.

## LaTeX conventions
- Wide figs → `figure*` (IEEEtran 2-col); phasor diagram → single-col `figure`.
- TikZ libs loaded in both main.tex: `shapes.geometric, arrows.meta, positioning, calc`.
- siunitx `\SI{}{}`, `\SIrange{}{}{}` for all quantities.
- `\eqref` for equations, `\ref` for figs/sections.
- Presentation theme: `moloch` (Metropolis fork, TeX Live ≥ 2024); fallback
  `\usetheme{metropolis}`.

## Figure authoring policy
**All new figures must use `figures-lib.tex`** at repo root. Existing inline-TikZ
figures stay — no backport.
- Atoms (positional `\newcommand`, optional 1st arg = color):
  `\phasor`/`\phasorL`, `\phaseArc`, `\signal`/`\signalL`.
- Pics (keyval): `block`, `sum node`, `mixer`, `branch node`, `delay block`
  (snake via `cycles=N`), `antenna array`, `wavefronts`, `beam lobe`, `axes xy`.
- One switch in preamble: `\figstyle{paper}` (thin/semithick, `\footnotesize`)
  or `\figstyle{slides}` (thick, `\scriptsize`).
- `\input` library in preamble **only** — never inside `tikzpicture`,
  `\fitwidth{...}`, `\resizebox{...}`.
- Missing primitive? Extend library first (template in its header). Don't
  hand-roll TikZ at call site.
- Design spec: `docs/superpowers/specs/2026-04-24-figures-lib-design.md`.

## LaTeX gotchas
- **`\fitwidth` + parameterized `\def` = poison.** `\fitwidth` is
  `\resizebox{#1}{!}{#2}` — single brace group. `\def\foo#1{...}` inside it,
  then invoked from `\foreach`/PGF iterate, produces `! Illegal parameter
  number in definition of \iterate` pointing at `\end{frame}`. Fix: define
  helper **outside** `\fitwidth{...}` with `\newcommand`/`\def` at frame level,
  OR inline the drawing (fine for 3–5 antennas). Don't waste cycles on `\gdef`,
  `\makeatletter`, or doubling `#` — issue is PGF rescanning, not scope.
- Fatal LaTeX error: check `*/main.log` first `^!` line. `l.NNN` pointer often
  misleads for foreach/macro errors — search back for nearest `\foreach`/`\def`.
- TikZ `pic` (`pics/foo/.style={code={...}}`) with combined `\node[draw=COLOR,
  fill=COLOR, ...]` silently drops outline. Use `\draw rectangle`/`circle` +
  separate label `\node`. Working examples: antenna-triangle, axes pics.
- `\pgfmathsetmacro{\X}{1cm/2}` returns points, not cm. Do arithmetic on bare
  numbers, append unit at use site (or stay bare — TikZ defaults to cm). Library
  takes width/height/spacing as bare cm numbers.
