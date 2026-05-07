# Distributed / Tap-Injected Phase Interpolator Study

**Date:** 2026-05-04

**Question:** can a distributed, tap-injected interpolator create a stronger
Pareto point than the simpler 35 GHz PI -> 70 GHz doubler architecture?

This note studies the more novel idea hinted in
`docs/research/2026-05-03-mmwave-novel-techniques.md`: replace the separate
35 GHz phase generator, current-mode interpolator, buffer, and doubler with a
distributed structure whose taps synthesize phase and frequency-doubled output
at the same time.

The target comparison remains the Pareto target from
`docs/research/2026-05-04-pareto-front-analysis.md`:

| Target | Why |
|---|---|
| 70 GHz output | final carrier is harder than 28-40 GHz phase shifting |
| 2-3 deg RMS phase error | competitive with modern E/V-band active phase shifters |
| >20% useful phase-code bandwidth or TTD-like behavior | stronger than narrow direct active V/E-band points |
| <40-50 mW total | below high-accuracy E-band active PS power |
| <=0.25-0.35 mm2 core | competitive with compact active/passive baselines |
| no 7-10 dB passive loss at 70 GHz | system advantage over passive RTPS/APN cores |

## 1. Candidate Architecture

The most interesting version is not just a distributed 35 GHz phase
interpolator followed by a conventional doubler. That is mostly a layout-level
rearrangement of the half-rate architecture.

The stronger idea is:

```text
35 GHz travelling gate/input line
    -> N weighted nonlinear tap cells
    -> 70 GHz travelling output line
    -> regenerated phase-coded 70 GHz output
```

Each tap samples the 35 GHz travelling wave at a different delay. The tap cell
uses either square-law, switching, injection, or push-push behavior to inject a
70 GHz current into the output line. The output line then sums these injected
second-harmonic currents.

This turns the phase shifter into a **distributed harmonic vector
interpolator**:

- coarse phase comes from selecting tap position;
- fine phase comes from weighting adjacent taps;
- frequency doubling occurs inside each tap;
- output buffering/combining occurs on the 70 GHz line.

## 2. Tap Phase Math

Let the 35 GHz input angular frequency be `\omega_0`. Tap `k` is reached after
gate-line delay `k\tau_g`. A nonlinear tap produces a second-harmonic current:

$$
i_{2,k}(t)
= a_k w_k A^2
\cos\left(2\omega_0 t - 2\omega_0 k\tau_g + \theta_k\right),
$$

where `w_k` is the programmable weight, `a_k` is the tap conversion factor, and
`\theta_k` includes local device phase and sign choices.

If the 70 GHz output line is collected at the right end and tap `k` is located
`(N-1-k)` sections from that output, the output-line propagation delay is
`(N-1-k)\tau_o`. The phasor arriving at the output is approximately:

$$
Z_\mathrm{out}
\propto
\sum_{k=0}^{N-1}
w_k a_k
e^{-j2\omega_0[k\tau_g+(N-1-k)\tau_o]}
e^{j\theta_k}.
$$

Ignoring the constant phase term, adjacent taps are spaced by:

$$
\Delta\Phi_\mathrm{tap}
=
-2\omega_0(\tau_g-\tau_o) + \Delta\theta_k.
$$

This is the first major insight.

In a normal distributed amplifier, the gate and drain/output lines are
phase-matched so contributions from all cells add coherently:

$$
\tau_g \approx \tau_o.
$$

But if `\tau_g = \tau_o`, then

$$
\Delta\Phi_\mathrm{tap}\approx 0,
$$

and the tap index gives no phase-shifter function. For phase synthesis, we must
either intentionally use differential delay, collect the output in the reverse
direction, or add local phase/sign offsets.

### Forward-Output Mode

With right-end collection:

$$
\Delta\Phi_\mathrm{tap}
= -2\omega_0(\tau_g-\tau_o).
$$

For 45 deg tap spacing at 70 GHz:

$$
|\tau_g-\tau_o|
=
\frac{45^\circ}{2\omega_0}
=
\frac{\pi/4}{2(2\pi)(35\,\mathrm{GHz})}
\approx 1.79\,\mathrm{ps}.
$$

This is physically plausible: the two synthetic lines need only differ by about
1.8 ps per tap. The risk is that broadband phase accuracy now depends on how
constant this delay difference is with frequency.

### Reverse-Output Mode

If the 70 GHz output is collected from the input side, the output propagation
delay to the port is `k\tau_o`, so:

$$
Z_\mathrm{out,left}
\propto
\sum_k
w_k a_k
e^{-j2\omega_0 k(\tau_g+\tau_o)}.
$$

Adjacent tap spacing becomes:

$$
\Delta\Phi_\mathrm{tap}
= -2\omega_0(\tau_g+\tau_o).
$$

This gives tap phase without needing mismatched lines, but each section must be
short enough that `\tau_g+\tau_o` gives the desired spacing. For 45 deg at
70 GHz, the sum must also be about 1.79 ps per tap. That can become layout
aggressive if both lines need realistic loaded impedance and tap capacitance.

### Local Sign / Quadrature Injection

Another option is to keep the lines closer to phase-matched for gain, then
create tap phase with local switching:

$$
\Delta\Phi_\mathrm{tap}
\approx \Delta\theta_k.
$$

Examples:

- alternating differential polarity gives 180 deg steps;
- transformer/hybrid-assisted taps give 90 deg offsets;
- small local APN/RTPS sections give residual phase offsets;
- current-DAC sign bits provide quadrant selection while adjacent-tap weights
  provide fine phase.

This may be the best practical compromise: use the distributed line for
bandwidth, summing, and block merging, but do not force all phase spacing to
come from line-delay mismatch.

## 3. Fine Interpolation Between Taps

If two adjacent taps are enabled with weights `w_0` and `w_1`, and their output
phasors are separated by `\Delta\Phi`, the synthesized phase is:

$$
\Phi
=
\Phi_k
+
\tan^{-1}
\left(
\frac{w_1\sin\Delta\Phi}
{w_0+w_1\cos\Delta\Phi}
\right).
$$

This is the same vector interpolation law as a conventional VM/CMPI, but the
basis phasors are generated by tap location rather than by a centralized I/Q
generator.

The amplitude is:

$$
|Z|
=
\sqrt{w_0^2+w_1^2+2w_0w_1\cos\Delta\Phi}.
$$

For `\Delta\Phi = 45^\circ`, equal weights produce only:

$$
20\log_{10}\sqrt{\frac{1+\cos45^\circ}{2}}
\approx -0.69\,\mathrm{dB}
$$

midpoint droop. This is the same favorable result as the small-sector half-rate
PI study, but now it happens at the final 70 GHz output.

## 4. Why This Could Be Stronger Than Half-Rate PI + Doubler

| Mechanism | Benefit | Why it matters for Pareto |
|---|---|---|
| Merged interpolation and doubling | no single large 35 GHz PI output buffer followed by doubler | reduces block count and potentially area/power |
| 35 GHz tap drive | tap control and input distribution happen below final carrier | easier than direct 70 GHz I/Q generation |
| 70 GHz distributed output line | many small tap currents sum on a travelling-wave node | avoids one high-capacitance lumped 70 GHz summing node |
| Small-sector adjacent-tap interpolation | <=45 deg sectors possible with 8 taps | lower amplitude droop and AM-PM than 90 deg interpolation |
| Per-tap nonlinear regeneration | each tap can hard-limit/switch before injecting 2f | can reduce sensitivity to 35 GHz amplitude variation |
| Delay-based tap phasors | phase can be made more TTD-like than pure vector modulation | stronger broadband/beam-squint story |

The architectural claim is stronger if the block is described as a final-carrier
phase synthesizer, not as a hidden 35 GHz PI:

$$
\Phi_{70}(c)
=
\arg
\left[
\sum_k w_k(c)\,H_k(2\omega_0)\,G_k(\omega_0)^2
\right].
$$

Here `G_k` is the 35 GHz path to tap `k`, and `H_k` is the 70 GHz path from tap
`k` to the output. This makes the design problem explicit: choose the line
delays and tap weights so the product path has the desired output phasor.

## 5. What It Must Beat

The distributed/tap-injected idea is only worth pursuing if it beats Scenario B
from the half-rate PI study, because Scenario B is simpler.

| Comparison | Simpler Half-Rate PI + Doubler | Distributed/Tap-Injected Must Show |
|---|---:|---:|
| Output RMS phase error | 2-3 deg possible if 35 GHz PI <=1 deg RMS | <=2-3 deg without excessive calibration |
| Power | target <=30-40 mW | similar or lower after terminations and tap bias |
| Area | target <=0.25-0.35 mm2 | no large synthetic-line area penalty |
| Output variation | controlled by limiter/doubler | <=1 dB through tap weighting or saturation |
| Bandwidth | good if 35 GHz phase gen is broadband | stronger, ideally TTD-like or >20% phase-code BW |
| Novelty | half-rate relocation of PI | merged distributed harmonic phase synthesis |

The distributed approach should not be framed as automatically lower noise. It
has more active devices and line terminations. Its strongest potential
advantages are **bandwidth, final-carrier summing, block merging, and scalable
layout**.

## 6. Main Failure Modes

| Risk | Mathematical Symptom | Consequence | Mitigation |
|---|---|---|---|
| Tap phase dispersion | `\Delta\Phi_\mathrm{tap}(\omega)` not constant enough | phase code bends across bandwidth | EM-optimized synthetic lines; calibration vs frequency; use local phase offsets |
| Line loss gradient | `|H_k|` depends on tap position | phase and gain errors because basis vectors are unequal | taper tap weights; pre-distortion table; bidirectional/symmetric collection |
| Tap loading | gate/output line velocity changes with enabled code | code-dependent phase shift | dummy cells always connected; switch current not capacitance |
| Termination loss | input/output terminations burn RF power | power advantage disappears | reuse terminations, lower-Z lines, resonant termination, injection-lock reuse |
| AM-PM in nonlinear taps | `\Delta\Phi \approx k_\mathrm{AMPM}\Delta A` | weight-dependent phase error | saturating/switching tap operation; constant input swing; small-sector interpolation |
| Fundamental leakage | residual 35 GHz on output line | spur/pulling risk | push-push differential taps; 35 GHz rejection in output line/load |
| Reverse wave ripple | unmatched 70 GHz line reflections | frequency ripple and code-dependent error | real travelling-wave termination; EM co-design |
| Device mismatch | `a_k`, `\theta_k` vary | static phase/gain error | thermometer layout, calibration, redundant taps |

The most dangerous risks are tap loading and line-loss gradient. If enabling a
tap changes the line velocity, the phase code is no longer a linear vector sum.
This argues for always-present tap capacitance and programmable current
amplitude, not hard RF switching of tap devices on/off.

## 7. Candidate Circuit Variants

| Variant | Description | Strength | Weakness | Initial Verdict |
|---|---|---|---|---|
| A. 35 GHz distributed PI + lumped doubler | distributed tap VM at 35 GHz, then conventional doubler | easiest to simulate | least novel; still has single doubler AM-PM point | baseline only |
| B. Forward tap-injected doubler line | 35 GHz line drives nonlinear taps; 70 GHz collected forward; phase from `\tau_g-\tau_o` | compact phase law; natural travelling output | needs controlled line mismatch | promising |
| C. Reverse tap-injected doubler line | collect 70 GHz from input side; phase from `\tau_g+\tau_o` | phase without intentional mismatch | short section delay and reverse-wave design may be hard | promising but layout-sensitive |
| D. Phase-matched line + local quadrant taps | lines phase-matched for gain; local sign/quadrature creates coarse phase | robust output power; less dispersion | requires local phase/sign hardware | likely most practical |
| E. Ring / closed-loop tap line | standing/travelling wave around ring; taps inject/extract phase | compact periodic 360 deg geometry | hard mode control, stronger EM uncertainty | high-risk/high-novelty |
| F. Injection-locked distributed oscillator | taps pull phases of coupled oscillator/output line | can regenerate and clean jitter | nonlinear lock dynamics harder to prove | later-stage idea |

The best first research path is Variant D or B:

- **D** is safer for a paper because it behaves like a distributed vector
  modulator with local coarse phase.
- **B** is more elegant and more novel if EM simulations show stable
  `\tau_g-\tau_o` across bandwidth.

## 8. First-Order Design Numbers

Assume an 8-sector output phase basis at 70 GHz:

$$
\Delta\Phi_\mathrm{tap}=45^\circ.
$$

Then adjacent interpolation only spans 45 deg, giving -0.69 dB ideal midpoint
droop. With 4 fine bits per sector:

$$
\Delta\Phi_\mathrm{LSB}
=
\frac{45^\circ}{16}
=
2.8125^\circ.
$$

With 5 fine bits per sector:

$$
\Delta\Phi_\mathrm{LSB}
=
\frac{45^\circ}{32}
=
1.40625^\circ.
$$

For competitive phase error, a useful budget is:

| Error Source | Aggressive Budget |
|---|---:|
| tap phase spacing error after calibration | <=1.0 deg RMS |
| weight-DAC interpolation error | <=0.8 deg RMS |
| tap AM-PM / conversion phase variation | <=1.0 deg RMS |
| output-line reflection / dispersion residual | <=1.0 deg RMS |
| total RSS | ~1.9 deg RMS |

This is an ambitious but plausible target because the interpolation sector is
small and the difficult I/Q generator is replaced by a tap geometry plus local
coarse offsets.

## 9. Relationship to Existing Baselines

| Baseline Limitation | How Tap-Injection Could Address It | Remaining Concern |
|---|---|---|
| Qiu VSPS is excellent below 40 GHz but not final-carrier 70 GHz | keeps 35 GHz distribution but synthesizes 70 GHz directly | must prove 70 GHz output line does not erase the 35 GHz benefit |
| Pepe/Zito direct W-band VM has compact area but high phase error | avoids direct W-band I/Q vector modulator and uses smaller sectors | distributed line may exceed compact VM area |
| Yu 60 GHz VM needs calibration and has limited BW | tap delays can be more broadband than lumped I/Q | calibration probably still needed |
| Afroz/Koh passive W-band PI works well in full T/R channels | active tap injection can provide regenerated standalone output | power may exceed passive PI core |
| Garg RTPS/APN-style passive blocks have low phase error but high IL | output is active/regenerated, not a 7-10 dB lossy phase path | cannot claim zero static power |
| Anjos APN has huge BW but only 2-bit and high loss | tap interpolation adds fine resolution and gain | line dispersion still sets BW |

The potential new Pareto point is:

> a 70 GHz active phase-coded output generated by half-rate distributed taps,
> with small-sector interpolation, no high-loss 70 GHz passive phase path, and
> wider phase-code bandwidth than narrow direct active vector modulators.

## 10. Is It Actually Novel Enough?

Likely yes, if the contribution is positioned carefully.

Distributed amplifiers, travelling-wave combiners, TTD lines, vector
interpolators, and doublers all exist. The novelty would be in combining them
so that the tap index participates in **harmonic phase synthesis**:

$$
\text{tap delay at } f_0
\quad+\quad
\text{tap injection at } 2f_0
\quad+\quad
\text{weighted adjacent-tap interpolation}
\quad\rightarrow\quad
\text{phase-coded } 2f_0 \text{ output}.
$$

The paper should avoid claiming that distributed summing alone is new. The
claim should be that **phase interpolation and frequency multiplication are
co-designed in a travelling-wave tap network**.

## 11. What to Simulate First

1. **Ideal phasor model.** Sweep `\tau_g`, `\tau_o`, line loss, tap phase error,
   and weight quantization. Produce RMS phase error, gain ripple, and bandwidth.

2. **Transmission-line behavioral model.** Use lossy `RLGC` sections and fixed
   tap capacitance. Verify whether tap enabling changes the effective phase
   velocity.

3. **Single nonlinear tap.** Characterize conversion gain, 35 GHz rejection,
   AM-PM, additive phase noise, and required 35 GHz drive.

4. **Four-tap then eight-tap EM/circuit co-sim.** Check whether the output line
   remains travelling-wave at 70 GHz and whether tap phases follow the phasor
   model.

5. **Calibration study.** Determine whether one static per-code LUT can correct
   phase and amplitude across a useful bandwidth, or whether frequency-dependent
   calibration is required.

The first plot should be the distributed equivalent of the Pareto study:

| Sweep | Output Metrics |
|---|---|
| `\tau_g-\tau_o` or `\tau_g+\tau_o` | phase coverage, phase linearity |
| line loss per section | gain ripple, phase bias |
| tap conversion mismatch | RMS phase/gain error |
| tap AM-PM coefficient | final phase error under interpolation |
| number of taps | area/power vs midpoint droop |

## 12. Go / No-Go Criteria

This idea is worth elevating over the simpler half-rate PI if simulations show:

| Metric | Go Criterion |
|---|---:|
| 70 GHz RMS phase error | <=2.5 deg after static calibration |
| Output amplitude ripple | <=1 dB across codes |
| Useful phase-code bandwidth | >=20% around 70 GHz, or convincingly TTD-like |
| Total estimated power | <=40-50 mW |
| Core area estimate | <=0.35 mm2 |
| Fundamental leakage | at least 20 dB below 70 GHz output |

If it only achieves 5-8 deg RMS phase error, or needs a large synthetic line
area plus high tap current, then it is probably weaker than the simpler
calibrated half-rate PI + low-AM-PM doubler. In that case it can still be a
future-work or discussion idea, but not the main architecture.

## 13. Current Recommendation

The distributed/tap-injected idea is worth serious exploration because it has a
clear mechanism for a new Pareto point: it can merge phase interpolation,
doubling, and output combining while keeping the phase-control distribution at
35 GHz.

The strongest version to prototype first is:

```text
8 physical taps
45 deg output basis sectors
programmable adjacent-tap current weights
always-connected dummy tap capacitance
push-push or differential nonlinear tap cells
70 GHz travelling output line with real termination
local sign/quadrant assistance if line-delay spacing is too fragile
```

The key decision is whether tap phase should come mainly from line-delay
difference (`\tau_g-\tau_o`) or from local phase/sign generation. That decision
should be made with an ideal phasor/line-loss model before transistor-level
design.

## 14. Extreme Version: Everything Distributed

Yes, the extreme version is a system where **phase shifting, gain,
interpolation/summing, and frequency doubling are all distributed**. But these
four uses of "distributed" are not the same design move:

| Function | Distributed Meaning | Main Benefit | Main Cost |
|---|---|---|---|
| Phase shifting | phase is encoded by propagation delay, tap position, or tunable line velocity | TTD-like broadband phase; less reliance on lumped I/Q accuracy | line dispersion, area, insertion loss |
| Gain | several small `G_m` cells feed a travelling output line | absorbs device capacitance; avoids a single high-C summing node | terminations burn power; noise from many cells |
| Interpolation/summing | weighted taps synthesize a phasor on the line | small-sector interpolation and natural combining | tap mismatch, loss gradient, code-dependent loading |
| Doubling | each tap generates/injects second harmonic into a 70 GHz line | merges doubler and combiner; wideband harmonic generation | AM-PM, fundamental leakage, harmonic matching |

The extreme architecture is therefore:

```text
35 GHz distributed/tunable input line
    -> weighted nonlinear tap cells with programmable current/sign
    -> distributed 70 GHz harmonic output line
    -> optional injection-locked / limiting cleanup
```

The useful abstraction is a two-frequency distributed network:

$$
Z_{70}(c,\omega)
=
\sum_{k=0}^{N-1}
w_k(c)\,
\alpha_k(\omega)\,
G_k^2(\omega)\,
H_k(2\omega).
$$

Here `G_k` is the 35 GHz travelling path to the tap, `\alpha_k` is the nonlinear
second-harmonic conversion coefficient of tap `k`, and `H_k` is the 70 GHz path
from that tap to the output. The phase code is the argument of this sum; the
gain ripple is its magnitude.

This makes the full-distributed design a **distributed nonlinear vector
network**, not just a phase shifter.

## 15. Technique Menu for the Extreme Architecture

### 15.1 Distributed Phase Shifting

Relevant techniques:

- **Switched/tunable transmission lines.** Change distributed `L` and `C` while
  keeping `Z_0` roughly stable. This gives wideband delay/phase control without
  a centralized quadrature generator.
- **Distributed Miller-effect TTD.** Use active coupled-line loading so a single
  control changes effective distributed inductance and capacitance together.
- **Slow-wave loaded lines.** Use periodic capacitive/inductive loading to make
  compact delays at 35 GHz.
- **Tap-position phase coding.** Keep line velocity fixed and select/weight
  taps instead of tuning the whole line.

Prior art says this is real but costly. Woods/Valdes-Garcia/Ding/Rascoe showed
60 GHz CMOS tunable transmission-line phase shifters with about 175-185 deg
phase range, 2-3.2 deg RMS phase error, and compact 0.073-0.099 mm2 area, but
with several dB insertion loss. Lee/Valdes-Garcia's distributed Miller TTD
demonstrated 18 ps delay tuning from 11-24 GHz with constant-impedance intent,
but reported roughly 10-12 dB insertion loss and 22 mW.

**Our read:** distributed phase shifting helps the bandwidth story most. It is
not automatically the lowest-loss choice.

### 15.2 Distributed Gain

Relevant techniques:

- **Travelling-wave amplifier cells.** Split the input capacitance across a gate
  line and combine drain currents on an output line.
- **Distributed power combining.** Use 1-D or 2-D line/combiner structures so
  multiple small cells contribute to one broadband output.
- **Loss-compensated lines.** Use active negative conductance or distributed
  gain to offset line loss.

This helps because 70 GHz lumped summing nodes are expensive: every extra tap
capacitance lowers bandwidth and increases phase sensitivity. A distributed
output line can turn device capacitance into part of the line.

But this is not free. Both the input and output lines want terminations, and the
noise of many active cells adds. The gain distribution is most valuable when it
also performs another necessary function: interpolation, doubling, or output
drive.

**Our read:** distributed gain helps most if it eliminates a separate 70 GHz
buffer/combiner. It is weak if it is added as an extra amplifier around an
otherwise conventional PI.

### 15.3 Distributed Interpolation and Summing

Relevant techniques:

- **Adjacent-tap interpolation.** Use two neighboring tap currents as the basis
  phasors for each small sector.
- **Thermometer current weighting.** Keep RF capacitance fixed and vary only
  current amplitude to avoid code-dependent line velocity.
- **Local sign/quadrature injection.** Use tap polarity or small local phase
  networks for quadrant/coarse phase while the line handles broadband summing.
- **Predistorted tap weights.** Compensate line-loss gradient and tap conversion
  mismatch digitally.

This is the part that most directly benefits our phase-error target. Reducing
sector spacing from 90 deg to 45 deg reduces midpoint amplitude droop from
3.01 dB to 0.69 dB. In a nonlinear doubler path, that reduction is especially
important because amplitude variation converts to both output-power ripple and
AM-PM.

**Our read:** distributed interpolation/summing is probably the highest-value
distributed move. It attacks the large lumped summing-node problem and the
large-sector AM-PM problem simultaneously.

### 15.4 Distributed Doubling

Relevant techniques:

- **Travelling-wave push-push doubler.** Multiple push-push stages inject even
  harmonic current into an output line.
- **Distributed amplifier + nonlinear transmission line doubler.** A nonlinear
  line generates harmonics while distributed active devices boost conversion
  gain and output power.
- **Standing-wave / circular travelling-wave multiplier.** Counter-propagating
  waves and symmetry make even harmonics combine constructively while odd
  harmonics cancel or combine poorly.
- **Per-tap push-push cells.** Differential tap cells reject the 35 GHz
  fundamental locally and inject 70 GHz into the output line.

Prior art is strong here. Momeni/Afshari's JSSC travelling-wave CMOS
multiplier used distributed harmonic combining and standing-wave/loss
cancellation ideas, demonstrating a 220-275 GHz doubler in 65 nm CMOS. Hao et
al. combined a distributed amplifier with an NLTL in 28 nm CMOS, reporting
96-134 GHz output, 33% instantaneous 3 dB bandwidth, -6.2 dB peak conversion
gain, 8.3% efficiency, 12 mW, and 0.72 x 0.27 mm2 area. Dedovic et al. reported
a 61-187.2 GHz travelling-wave push-push doubler in 130 nm SiGe:C BiCMOS with
101.7% fractional bandwidth and -0.48 dBm maximum measured output at 93 GHz.

**Our read:** distributed doubling has the best external validation. The novel
step is not "distributed doubler"; it is **weighted phase-code injection into a
distributed doubler**.

## 16. Which Parts Benefit Most from Being Distributed?

Ranked for this project:

| Rank | Distributed Part | Benefit Level | Reason |
|---:|---|---|---|
| 1 | interpolation/summing | very high | solves lumped 70 GHz summing capacitance and enables <=45 deg sectors |
| 2 | doubling | high | prior art shows wideband distributed harmonic generation; merges doubler/combiner |
| 3 | phase generation | medium-high | can create TTD-like phase basis, but line loss/dispersion are real |
| 4 | gain | medium | useful when merged with doubling/output drive; weak as a standalone addition |

So the recommended extreme architecture is not "distribute everything because
distributed is better." It is:

1. distribute **interpolation/summing** to avoid a lumped 70 GHz VM node;
2. distribute **doubling** so each tap contributes a 70 GHz phase-coded current;
3. use distributed **phase/delay** only as much as needed to create stable
   basis phasors;
4. use distributed **gain** only where it replaces a required output buffer or
   compensates unavoidable line loss.

## 17. Updated Architecture Recommendation

The next architecture sketch should show four explicitly distributed layers:

```text
Layer 1: 35 GHz input / delay line
    fixed or weakly tunable, with dummy-loaded taps

Layer 2: tap weighting / interpolation
    current-DAC weights, adjacent-tap interpolation, optional sign/quadrant bits

Layer 3: nonlinear tap conversion
    push-push or switching tap cells generating local 70 GHz current

Layer 4: 70 GHz travelling output line
    terminated line or symmetric combiner collecting weighted second harmonics
```

This suggests a concrete block name:

> Distributed Harmonic Phase Interpolator (DHPI)

or, more descriptive:

> Tap-Weighted Distributed Doubler Phase Interpolator

The strongest paper claim would be:

> A tap-weighted distributed doubler performs phase interpolation and frequency
> multiplication in the same travelling-wave network, avoiding both a lumped
> 70 GHz vector-summing node and a separate high-drive doubler.

The hardest proof point will be showing that the phase basis remains stable
when tap weights change. That means the first behavioral model must include
fixed parasitic tap loading even when a tap's current is zero.

## Sources

Local project reports:

- `docs/research/2026-05-03-mmwave-novel-techniques.md`
- `docs/research/2026-05-04-half-rate-pi-doubler-study.md`
- `docs/research/2026-05-04-pareto-front-analysis.md`
- `docs/research/2026-05-04-strict-baseline-metric-table.md`

Local reference PDFs most relevant to this idea:

- *A 15-38 GHz Vector-Summing Phase-Shifter With 360 deg Phase-Shifting Range
  Using Improved I/Q Generator*
- *Two mm-Wave Vector Modulator Active Phase Shifters With Novel IQ Generator
  in 28 nm FDSOI CMOS*
- *A 28-GHz Low-Power Phased-Array Receiver Front-End With 360 deg RTPS Phase
  Shift Range*
- *A 14-50-GHz Phase Shifter With All-Pass Networks for 5G Mobile Applications*
- *A 63.3-GHz Half-Nanosecond True-Time-Delay Line With Gain Compensation for
  Wideband Large-Scale Antenna Array*
- *A Compact 33.0-GHz 68.5-ps CMOS True-Time Delay for Wideband Phased Array
  Systems*

Online references pulled for the distributed extension:

- Woods, Valdes-Garcia, Ding, and Rascoe, *CMOS millimeter wave phase shifter
  based on tunable transmission lines*, CICC 2013. IBM summary:
  https://research.ibm.com/publications/cmos-millimeter-wave-phase-shifter-based-on-tunable-transmission-lines
- Lee and Valdes-Garcia, *Continuous True-Time Delay Phase Shifter Using
  Distributed Inductive and Capacitive Miller Effect*, IEEE T-MTT 2019. IBM
  summary:
  https://research.ibm.com/publications/continuous-true-time-delay-phase-shifter-using-distributed-inductive-and-capacitive-miller-effect
- Barker and Rebeiz, *Distributed MEMS True-Time Delay Phase Shifters and
  Wide-Band Switches*, IEEE T-MTT 1998. PDF:
  https://mtt.org/app/uploads/2019/01/2000.pdf
- Momeni and Afshari, *A Broadband mm-Wave and Terahertz Traveling-Wave
  Frequency Multiplier on CMOS*, IEEE JSSC 2011. ResearchGate record:
  https://www.researchgate.net/publication/220365743_A_Broadband_mm-Wave_and_Terahertz_Traveling-Wave_Frequency_Multiplier_on_CMOS
- Hao et al., *An 8.3% Efficiency 96-134 GHz CMOS Frequency Doubler Using
  Distributed Amplifier and Nonlinear Transmission Line*, A-SSCC 2020. NYCU
  record:
  https://scholar.nycu.edu.tw/en/publications/an-83-efficiency-96-134-ghz-cmos-frequency-doubler-using-distribu/
- Dedovic et al., *A 61-187.2-GHz Traveling Wave Push-Push Frequency Doubler in
  a 130 nm SiGe:C BiCMOS Technology With 101.7% Fractional Bandwidth*, BCICTS
  2023. Fraunhofer record:
  https://publica.fraunhofer.de/entities/publication/7e9ca5f6-fa5c-4840-bd03-ba0dfb699855
- Caruso et al., *RF/mm-Wave Frequency Doublers in CMOS Technology*, J. Low
  Power Electron. Appl. 2026. Review article:
  https://www.mdpi.com/2079-9268/16/2/14
- Kim, *Broadband Millimeter-Wave Power Amplifier Using Modified 2D Distributed
  Power Combining*, Electronics 2020:
  https://www.mdpi.com/2079-9292/9/6/899
