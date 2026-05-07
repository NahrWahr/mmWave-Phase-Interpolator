# AGENTS.md

This repository is a research and idea-exploration workspace for creative
mm-wave phase-control circuits. The main job is to brainstorm, reason from
first principles, compare architectures, find useful papers, and turn RF /
microwave intuition into testable concepts. Coding, LaTeX, figures, and paper
implementation are support activities, not the default mode.

## Role

Act as a research collaborator. Help develop and stress-test ideas around phase
interpolation, VGAs, doublers, distributed gain/summing, and distributed
microwave techniques.

Speculation is welcome when it is physically literate and clearly labeled. Do
not reduce the interaction to implementation logistics. When work becomes
concrete editing, building, figure generation, or Overleaf sync, use
`CLAUDE.md` for the mechanical project rules.

## Current Research State

The active research direction is a 70 GHz phase-coded output generated from
lower-frequency or distributed circuitry.

Anchor non-distributed architecture:

```text
35 GHz phase generation / interpolation
    -> amplitude cleanup or limiter
    -> x2 doubler / regenerator
    -> 70 GHz phase-coded output
```

Important conclusion so far: half-rate interpolation does not automatically
improve phase error. The doubler doubles electrical phase error:

```text
epsilon_phi,70 ~= 2 * epsilon_phi,35 + doubler AM-PM + lock/cal residuals
```

The half-rate approach is competitive only if the 35 GHz PI is very clean
and/or calibrated, and if the doubler has low AM-PM. A top-tier target is about
2-3 deg RMS phase error at 70 GHz with less than 40-50 mW and less than about
0.25-0.35 mm2 core area.

Active novel direction:

```text
35 GHz travelling input/delay line
    -> weighted nonlinear tap cells
    -> 70 GHz travelling output line
    -> regenerated phase-coded output
```

This has been named, for now, a **Distributed Harmonic Phase Interpolator
(DHPI)** or **Tap-Weighted Distributed Doubler Phase Interpolator**. The key
claim is not that distributed amplifiers or doublers are new. The possible
novelty is co-designing phase interpolation and frequency multiplication in the
same travelling-wave tap network.

## Research Docs to Read First

Start with these files before continuing the discussion:

- `docs/research/2026-05-04-half-rate-pi-doubler-study.md`
- `docs/research/2026-05-04-pareto-front-analysis.md`
- `docs/research/2026-05-04-strict-baseline-metric-table.md`
- `docs/research/2026-05-04-distributed-tap-injected-interpolator-study.md`
- `docs/research/2026-05-04-existing-broadband-phase-interpolation-gaps.md`
- `docs/research/2026-05-03-mmwave-novel-techniques.md`

The distributed/tap-injected report is the most recent direction. It concludes
that the most valuable parts to distribute are:

1. interpolation/summing;
2. doubling;
3. phase/delay generation;
4. gain, only when it replaces an otherwise necessary output buffer or loss
   compensation stage.

## Key Baseline Targets

Use the strict baseline table for numbers. The most relevant comparison points
are:

- Qiu 15-38 GHz VSPS: excellent broadband sub-40 GHz active vector-sum point.
- Pepe/Zito W-band VM: compact direct W-band active VM, but high phase error.
- Yu 60 GHz current-reuse VM: good V-band active vector-sum point.
- Afroz/Koh W-band passive PI: strong embedded T/R-channel result.
- Garg/Natarajan 28 GHz RTPS: near-unbeatable passive phase accuracy, but high
  insertion loss and narrow band.
- Anjos 14-50 GHz APN: huge bandwidth and zero static power, but high loss and
  low phase resolution.

Useful Pareto target for our architecture:

| Metric | Target |
|---|---:|
| Output carrier | 70 GHz |
| RMS phase error | 2-3 deg |
| Useful phase-code bandwidth | >20%, or convincing TTD-like behavior |
| Total PI / cleanup / doubler power | <40-50 mW |
| Core area | <=0.25-0.35 mm2 |
| Output ripple | <=1 dB preferred |
| Passive loss at final carrier | avoid 7-10 dB 70 GHz loss |

## Distributed DHPI Notes

For the tap-injected distributed architecture, the tap phase at the 70 GHz
output depends on both the 35 GHz input-line delay and the 70 GHz output-line
delay:

```text
DeltaPhi_tap = -2 * omega0 * (tau_g - tau_o) + DeltaTheta_k
```

With normal distributed-amplifier phase matching, `tau_g ~= tau_o`, so tap
index gives little phase shift. That means the architecture needs one of:

- intentional input/output line delay difference;
- reverse output collection;
- local sign/quadrature phase injection;
- local APN/RTPS-assisted tap phase offsets.

Do not assume a phase-matched distributed amplifier automatically acts as a
phase interpolator. That is a central caveat.

Current recommended DHPI prototype:

```text
8 physical taps
45 deg output basis sectors
adjacent-tap current interpolation
always-connected dummy tap capacitance
push-push or differential nonlinear tap cells
70 GHz travelling output line with real termination
local sign/quadrant assistance if line-delay spacing is fragile
```

First go/no-go targets:

- <=2.5 deg RMS phase error after static calibration;
- <=1 dB output amplitude ripple across codes;
- >=20% useful phase-code bandwidth, or TTD-like phase behavior;
- <=40-50 mW estimated total power;
- <=0.35 mm2 estimated core area;
- 35 GHz fundamental leakage at least 20 dB below 70 GHz output.

## Workflow for Future Sessions

1. Read the current research docs before proposing a new architecture.
2. Keep a running Markdown report in `docs/research/` for substantial research
   conclusions.
3. Use equations when they clarify phase mapping, noise transfer, delay,
   interpolation, gain ripple, locking, or AM-PM.
4. Compare every serious idea to the Pareto targets, not only to one hand-picked
   paper.
5. Distinguish `Likely`, `Plausible`, and `Speculative` claims.
6. When the user asks to explore, continue the technical back-and-forth rather
   than jumping straight into paper edits.
7. Search online when current or broader literature is needed, and add links to
   the relevant Markdown note.
8. When implementation begins, follow `CLAUDE.md` and run the appropriate build
   checks after LaTeX or code changes.

## Brainstorming Style

Prefer compact architectural sketches and failure-mode analysis. For each
serious idea, try to capture:

- signal path and frequency plan;
- what controls phase, what controls amplitude, and whether they are coupled;
- expected phase range, resolution, bandwidth, and insertion gain/loss;
- main nonidealities: AM-PM, PM-AM, compression, noise, mismatch, finite Q,
  quadrature error, DAC/current-source error, line loss, and layout asymmetry;
- why the approach might beat a conventional vector modulator, RTPS, APN, or
  passive PI;
- the smallest simulation that would validate or kill the idea.

Do not present clean phasor math as proof of a working mm-wave circuit. Always
ask what happens after parasitics, loss, finite device gain, headroom, harmonic
leakage, routing, EM coupling, and PVT are included.

## Useful Next Steps

Good follow-on tasks:

- Build an ideal DHPI phasor model sweeping `tau_g`, `tau_o`, line loss, tap
  mismatch, and weight quantization.
- Compare forward collection, reverse collection, and local sign/quadrature tap
  phase generation.
- Estimate line section delay and physical length for 8-tap 45 deg sectors at
  35/70 GHz.
- Sketch a push-push nonlinear tap cell and list its AM-PM, conversion gain,
  and fundamental rejection requirements.
- Make Pareto plots from the strict baseline table and overlay projected
  half-rate PI and DHPI points.

Keep the record clean. If an idea is only a sketch, say so. If it becomes part
of the paper or deck, turn it into buildable LaTeX, a coherent figure, and a
testable technical claim.
