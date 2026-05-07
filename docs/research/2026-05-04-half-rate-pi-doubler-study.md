# Half-Rate Phase Interpolation Followed by Frequency Doubling

**Date:** 2026-05-04

**Question:** can a phase interpolator operating at half the output frequency
beat state-of-the-art direct mm-wave phase shifters after a frequency doubler,
and what block choices are required?

This note studies the architecture:

```text
35 GHz phase generation / interpolation -> amplitude cleanup -> x2 doubler /
regenerator -> 70 GHz phase-coded clock
```

The current paper already contains the right seed equations in
`paper/sections/analysis.tex`: vector interpolation, multiplier phase-noise
scaling, and absolute jitter preservation. This document expands those equations
into a comparison framework.

## 1. Phase Mapping Through a Doubler

Let the half-rate interpolator output be

$$
v_{35}(t) = A(c)\cos\left(\omega_0 t + \phi(c) + \epsilon_\phi(c)\right),
$$

where `c` is the phase code, `A(c)` is code-dependent amplitude,
`\phi(c)` is the desired 35 GHz phase, and `\epsilon_\phi(c)` is the phase
error at 35 GHz.

An ideal square-law doubler produces a second harmonic term

$$
v_{70}(t) \propto A^2(c)\cos\left(2\omega_0 t
    + 2\phi(c) + 2\epsilon_\phi(c)\right).
$$

Therefore:

$$
\Phi_{70}(c) = 2\phi_{35}(c),
\qquad
\epsilon_{\Phi,70}(c) = 2\epsilon_{\phi,35}(c).
$$

This is the first hard constraint. If the target output phase step is
`\Delta\Phi_{70}`, the half-rate interpolator must step by

$$
\Delta\phi_{35} = \frac{\Delta\Phi_{70}}{2}.
$$

For a 6-bit 70 GHz phase shifter:

$$
\Delta\Phi_{70} = \frac{360^\circ}{64}=5.625^\circ,
\qquad
\Delta\phi_{35}=2.8125^\circ.
$$

The doubler doubles electrical phase error, so the 35 GHz PI error target is
half of the final 70 GHz target:

| Desired 70 GHz RMS phase error | Required 35 GHz RMS phase error |
|---:|---:|
| <10 deg | <5 deg |
| <5 deg | <2.5 deg |
| <2 deg | <1 deg |
| <1 deg | <0.5 deg |

**Implication:** half-rate PI can beat older W-band active vector modulators
with 9-12 deg RMS phase error if the 35 GHz PI achieves <4-5 deg RMS error. To
beat newer V/E-band active phase shifters reporting about 2 deg RMS phase error,
the 35 GHz PI must be exceptionally clean: roughly <1 deg RMS before doubling.

## 2. Jitter and Phase Noise Mapping

For a frequency multiplier with factor `N`, single-sideband phase noise maps as

$$
\mathcal{L}_\mathrm{out}(f_\Delta)
= \mathcal{L}_\mathrm{in}(f_\Delta)
+ 20\log_{10}N
+ \mathcal{L}_\mathrm{add}(f_\Delta).
$$

For `N=2`, the irreducible phase-noise shift is 6 dB. This looks like a penalty
in dBc/Hz, but absolute timing jitter is preserved by an ideal multiplier:

$$
\sigma_t = \frac{\sigma_\phi}{2\pi f_c},
\qquad
\sigma_{t,\mathrm{out}}
= \frac{N\sigma_{\phi,\mathrm{in}}}{2\pi N f_\mathrm{in}}
= \sigma_{t,\mathrm{in}}.
$$

The real comparison is therefore not "does the doubler add 6 dB?" It must. The
comparison is:

$$
\sigma^2_{t,\mathrm{half-rate}}
\approx
\sigma^2_{t,\mathrm{PI35}}
+ \sigma^2_{t,\mathrm{cleanup}}
+ \sigma^2_{t,\mathrm{doubler,add}},
$$

versus

$$
\sigma^2_{t,\mathrm{direct}}
\approx
\sigma^2_{t,\mathrm{I/Q70}}
+ \sigma^2_{t,\mathrm{VM70}}
+ \sigma^2_{t,\mathrm{buffer70}}.
$$

The half-rate architecture wins only if the saved 70 GHz interpolation noise and
parasitic sensitivity are larger than the cleanup and doubler additive jitter.

### Why 35 GHz Can Be Cleaner

At 35 GHz, compared with 70 GHz:

- transistor gain margin is larger;
- parasitic capacitances are less dominant;
- quadrature generation can use broader-band lower-loss networks;
- current steering has more headroom and settling margin;
- layout phase imbalance from small length errors is half as severe in
  electrical degrees;
- EM extraction and calibration are less brittle.

This is the real architectural strength. The doubler does not improve phase
error by itself; it lets the hard interpolation happen where the circuit can be
made more accurate.

## 3. Phase Error from I/Q Imperfections

For vector summing,

$$
z = \alpha I + \beta Q.
$$

With ideal quadrature, `I=1` and `Q=j`, so the desired phase is

$$
\phi = \tan^{-1}\left(\frac{\beta}{\alpha}\right).
$$

Now include I/Q amplitude mismatch `g` and quadrature error `\delta`:

$$
z = \alpha + \beta g e^{j(\pi/2+\delta)}.
$$

For small `\delta` and `g=1+\epsilon_g`, a first-order phase perturbation is
approximately

$$
\Delta\phi
\approx
\frac{\alpha\beta}{\alpha^2+\beta^2}\delta
+ \frac{\alpha\beta}{\alpha^2+\beta^2}\epsilon_g
\quad
\text{(worst near equal weights)}.
$$

The sensitivity term peaks at `\alpha=\beta`, where

$$
\frac{\alpha\beta}{\alpha^2+\beta^2}=\frac{1}{2}.
$$

After doubling:

$$
\Delta\Phi_{70}\approx
2\Delta\phi_{35}
\approx
\delta + \epsilon_g
\quad \text{near the 45 deg interpolation point}.
$$

**Implication:** a 35 GHz I/Q generator with 2 deg quadrature error can already
produce about 2 deg output error after doubling near equal weighting. To compete
with the best recent active V-band result (~2 deg RMS at 60 GHz), the half-rate
I/Q generator plus weight DAC must be very close to calibrated or intrinsically
balanced.

## 4. Amplitude Variation Is the Main Non-Ideal Doubler Coupling

Vector interpolation has code-dependent amplitude:

$$
A(c)
=
\left|\alpha e^{j\phi_1}+\beta e^{j\phi_2}\right|
=
\sqrt{\alpha^2+\beta^2+2\alpha\beta\cos\Delta\phi}.
$$

If the adjacent phasors are 90 deg apart and weights are normalized with
`\alpha+\beta=1`, the midpoint amplitude is

$$
A_\mathrm{mid} = \sqrt{0.5} = -3.01\,\mathrm{dB}
$$

relative to an endpoint. If adjacent phasors are 45 deg apart, the midpoint
amplitude is

$$
A_\mathrm{mid}
= \sqrt{0.5(1+\cos45^\circ)}
\approx 0.924
= -0.69\,\mathrm{dB}.
$$

Thus, coarse phase spacing matters. Smaller interpolation sectors reduce
code-dependent drive amplitude into the doubler.

The doubler second-harmonic amplitude scales roughly as

$$
A_{2\omega} \propto A^2(c),
$$

so a -3 dB amplitude dip at 35 GHz becomes roughly a -6 dB 70 GHz output-power
dip before saturation. Worse, real doublers exhibit AM-to-PM conversion:

$$
\Delta\Phi_\mathrm{AMPM}
\approx
k_\mathrm{AMPM}\,\Delta A_\mathrm{dB}.
$$

If `k_AMPM = 2 deg/dB`, a 3 dB code-dependent input swing can create 6 deg of
extra output phase error. That would erase the architectural benefit.

**Hard design rule:** the doubler must see either constant-envelope drive or a
calibrated amplitude trajectory. The half-rate PI is only competitive if this
is handled explicitly.

## 5. What Block Choices Make the Architecture Strong?

### 5.1 Half-Rate Phase Generation

Candidate blocks:

| Block | Strength | Risk | Fit |
|---|---|---|---|
| Broadband I/Q generator + CMPI | Most direct; builds from existing vector-sum literature | I/Q loading, amplitude variation, current-source mismatch | Good first implementation |
| APN / QAF I/Q generator | Excellent 15-38 GHz precedent | Resistors reduce Q and add loss/noise; must work at 35 GHz with real loading | Strong candidate |
| Passive hybrid / coupler at 35 GHz | Lower noise and good phase accuracy | Area, loss, calibration of amplitude/phase imbalance | Good if area is acceptable |
| TTDL / delay-line phase source at 35 GHz | True-time-delay behavior preserved after doubling | Loss and area; phase code may be coarse unless combined with interpolation | Useful for wideband/beam-squint argument |
| RTPS at 35 GHz | Zero dc, high linearity | 7-10 dB class loss in existing 28-30 GHz examples | Not attractive unless followed by gain/limiting already needed |

Best near-term choice:

```text
35 GHz broadband I/Q or 45 deg multi-phase generator
-> small-sector current-mode interpolation
-> limiter / ILO cleanup
-> low-additive-noise doubler
```

The key is **small-sector interpolation**. If the PI interpolates over 45 deg
sectors at 35 GHz, the final 70 GHz sector is 90 deg and the drive-amplitude
variation is only about 0.69 dB before doubling. If the PI interpolates over
90 deg sectors at 35 GHz, the final sector is 180 deg and midpoint amplitude
variation is too large unless a limiter is mandatory.

### 5.2 Cleanup Before the Doubler

Candidate blocks:

| Cleanup block | What it solves | Cost |
|---|---|---|
| CML limiting buffer | Flattens amplitude into the doubler; simple | Adds broadband active noise and power |
| 35 GHz ILO / resonant limiter | Constant amplitude, tank filtering, phase cleanup | Lock range and calibration complexity |
| Class-B/C hard-driven buffer | Strong zero-crossing regeneration | AM-to-PM if drive is not well controlled |
| No cleanup, calibrated doubler | Lowest block count | High risk; AM-PM must be extremely small |

Best technical choice for a clock/LO paper:

```text
PI35 -> resonant or injection-locked cleanup -> doubler
```

This makes the paper about phase-code regeneration and jitter, not just
S-parameters. It also directly attacks the biggest weakness of direct active
vector modulators: noisy active interpolation at the final mm-wave carrier.

### 5.3 Doubler Choice

Candidate blocks:

| Doubler | Strength | Risk |
|---|---|---|
| Conventional transistor doubler | Simple, known | Conversion loss, flicker/thermal added noise |
| Injection-locked doubler | Suppresses free-running noise inside lock range | Lock range, pulling, spur behavior |
| Class-F / inverse-F doubler | Potential high conversion gain/efficiency | Needs harmonic terminations and hard drive |
| Parametric varactor doubler | Low active-device noise | Varactor Q, pump swing, parametric stability |

For beating SOTA on a clock metric, the doubler must be measured or simulated as
an additive-jitter block. For beating SOTA on RF phase-shifter metrics, it must
also have low AM-PM and stable conversion gain over phase code.

## 6. Can It Beat SOTA?

### Against Older W-Band Active Vector Modulators

Pepe/Zito's W-band active vector modulators report roughly 9-12 deg RMS phase
error, about 1.5-2 dB RMS gain error, around 11 dB NF, and ~21.6 mW power.

The half-rate approach can plausibly beat this if:

$$
\epsilon_{\phi,35,\mathrm{rms}} < 5^\circ
\quad \Rightarrow \quad
\epsilon_{\Phi,70,\mathrm{rms}} < 10^\circ,
$$

and if the doubler AM-PM contribution is kept below a few degrees.

This is realistic. The 15-38 GHz vector-summing work reports 2.23-3.5 deg RMS
phase error across 15-38 GHz. If a comparable 35 GHz PI were used, the ideal
doubled output would be 4.5-7 deg RMS before doubler AM-PM. That beats the
Pepe/Zito W-band phase error, while operating closer to the target 70 GHz.

### Against Strong 60 GHz / V-Band Active Beamforming ICs

Recent V-band front-end work reports about 2 deg RMS phase error at 60 GHz with
9-bit phase control, 0.1 dB RMS gain error, 20 dB gain dynamic range, and a
complete PA/front-end context. This is a very strong SOTA point.

To beat it on output electrical phase error:

$$
\epsilon_{\phi,35,\mathrm{rms}} < 1^\circ
$$

before doubler AM-PM. That is difficult but not impossible with calibration,
small-sector interpolation, and a stable I/Q generator. Without calibration, it
is probably not a fair target.

But the half-rate architecture may beat this work on different metrics:

- lower additive jitter for a clock/LO output;
- lower complexity at the final 70 GHz node;
- lower 70 GHz passive loss;
- better portability to W-band/E-band where direct active vector modulation gets
  much harder;
- cleaner phase-code generation for a doubler/LO path rather than a PA path.

### Against Passive RTPS

At 28 GHz, passive RTPS can achieve extremely low phase error (<1 deg) with zero
dc power, but it pays 7-10 dB insertion loss. The half-rate approach will not
beat RTPS on zero dc or passive linearity. It can beat RTPS only if the system
values one of these:

- no large passive loss immediately at the final carrier;
- clock jitter/PN rather than RF path IL;
- scalable high-frequency operation where 70 GHz passive couplers/loads become
  too lossy or too large;
- integration with a doubler already required by the frequency plan.

### Against APN/TTD

APN and TTD circuits beat phase shifters on beam squint and wideband delay. A
half-rate fixed-phase PI does not solve beam squint by itself.

However, if the 35 GHz phase-generation block is a delay element, then doubling
preserves the equivalent delay:

At 35 GHz:

$$
\phi_{35}(\omega)=\omega\tau.
$$

After doubling:

$$
\Phi_{70}(2\omega)=2\omega\tau.
$$

At the 70 GHz carrier `\Omega=2\omega`, this is

$$
\Phi_{70}(\Omega)=\Omega\tau.
$$

So a half-rate TTDL followed by doubling gives the same time delay at the output,
not twice the delay. This is good: true-time-delay behavior survives the doubler.

The issue is implementation. A standalone 35 GHz TTDL still has loss/area. The
more interesting block-level decision is to use TTDL/coarse delay for sector
generation and CMPI for fine interpolation.

## 7. Proposed Paper Argument

The cleanest mathematical story is:

1. **Phase-code mapping:** output phase is exactly doubled.
2. **Resolution:** half-rate phase resolution must be twice as fine in degrees
   for the same output resolution.
3. **Error:** 35 GHz phase error doubles electrically, so the architecture only
   wins if 35 GHz implementation error is less than half of direct 70 GHz error.
4. **Jitter:** ideal doubling preserves absolute timing jitter, so 6 dB phase
   noise shift is not a timing penalty.
5. **Bandwidth:** if the half-rate phase block is delay-based, TTD behavior is
   preserved after doubling.
6. **Non-ideal limiter:** amplitude variation before the doubler creates
   code-dependent output power and AM-PM. This is the dominant practical failure
   mode and must be designed out.

Suggested equation sequence for the paper:

```latex
\begin{equation}
v_{35}(t)=A(c)\cos(\omega_0 t+\phi(c)+\epsilon_\phi(c))
\end{equation}

\begin{equation}
v_{70}(t)\propto A^2(c)\cos(2\omega_0 t+2\phi(c)+2\epsilon_\phi(c))
\end{equation}

\begin{equation}
\Delta\Phi_{70}=2\Delta\phi_{35},\qquad
\epsilon_{\Phi,70}=2\epsilon_{\phi,35}
\end{equation}

\begin{equation}
\mathcal{L}_{70}(f_\Delta)
=\mathcal{L}_{35}(f_\Delta)+6\,\mathrm{dB}
+\mathcal{L}_\mathrm{add}(f_\Delta)
\end{equation}

\begin{equation}
\sigma_{t,70}=\frac{2\sigma_{\phi,35}}{2\pi(2f_0)}
=\sigma_{t,35}
\end{equation}

\begin{equation}
A(c)=\sqrt{\alpha^2+\beta^2+2\alpha\beta\cos\Delta\phi}
\end{equation}
```

Presentation alternative:

- One figure showing phase-code doubling: 35 GHz phasor wheel maps to a 70 GHz
  wheel with doubled angle.
- One table showing output target vs required 35 GHz target.
- One "win/loss" block diagram comparing direct 70 GHz VM and 35 GHz PI + x2.
- One plot of amplitude droop versus interpolation sector width:
  90 deg sector -> -3.0 dB midpoint; 45 deg -> -0.69 dB; 22.5 deg -> -0.17 dB.

## 8. Design Decisions Required to Make It Competitive

Recommended architecture for the non-distributed version:

```text
35 GHz low-error multi-phase generator
-> small-sector current-mode PI
-> constant-envelope cleanup / ILO
-> low-AM-PM injection-locked or class-F doubler
-> 70 GHz output buffer
```

Minimum targets:

| Metric | Target | Reason |
|---|---:|---|
| 35 GHz RMS phase error | <2.5 deg uncalibrated, <1 deg calibrated | <5 deg or <2 deg at 70 GHz |
| Sector spacing at 35 GHz | <=45 deg | keeps midpoint amplitude droop <=0.69 dB |
| Doubler AM-PM | <1 deg/dB preferred | prevents amplitude code from becoming phase error |
| Additive jitter of cleanup+doubler | below direct 70 GHz VM/buffer jitter | only way to win as a clock architecture |
| 70 GHz output gain variation | calibratable to <1 dB | comparable to active VM SOTA |
| Phase-code monotonicity | guaranteed by calibration or architecture | necessary for PI credibility |

## 9. Verdict

**Likely win:** compared with older W-band active vector modulators and passive
70 GHz phase shifters, if we keep the doubler clean. The architecture can avoid
direct high-resolution interpolation at 70 GHz and replace it with lower-risk
35 GHz interpolation plus regeneration.

**Plausible but hard win:** compared with recent V-band active beamforming ICs
showing ~2 deg RMS phase error. Beating them on phase error alone requires
sub-1-deg RMS at 35 GHz plus very low AM-PM. The better claim is likely
additive jitter / clock generation / high-frequency scalability, not raw
S-parameter phase error.

**Main risk:** amplitude variation from vector interpolation driving a nonlinear
doubler. If this is not solved, the architecture will lose even if the 35 GHz PI
looks good in small-signal S-parameters.

**Best framing:** not "frequency doubling improves phase interpolation," because
it does not directly improve phase error. The correct claim is:

> Half-rate interpolation moves phase synthesis to a frequency where accurate,
> low-noise interpolation is easier; ideal doubling preserves timing jitter; and
> a carefully designed regenerator/doubler can transfer the phase code to 70 GHz
> without the power, NF, and parasitic penalties of direct mm-wave vector
> modulation.

## Sources

Local references:

- Qiu et al., *A 15-38 GHz Vector-Summing Phase-Shifter With 360 deg
  Phase-Shifting Range Using Improved I/Q Generator*.
- Pepe and Zito, *Two mm-Wave Vector Modulator Active Phase Shifters With Novel
  IQ Generator in 28 nm FDSOI CMOS*.
- Yu et al., *A 60-GHz 19.8-mW Current-Reuse Active Phase Shifter With Tunable
  Current-Splitting Technique in 90-nm CMOS*.
- Afroz/Kim/Koh, *Power-Efficient W-Band Phased-Array T/R Elements With
  Quadrature-Hybrid-Based Passive Phase Interpolator*.
- Garg and Natarajan, *A 28-GHz Low-Power Phased-Array Receiver Front-End With
  360 deg RTPS Phase Shift Range*.
- Anjos et al., *A 14-50-GHz Phase Shifter With All-Pass Networks for 5G Mobile
  Applications*.

Online/current context:

- So/Sung/Hong, 2024, V-band four-channel phased-array transmitter front-end:
  reports 2 deg RMS phase error at 60 GHz with 9-bit phase control and 20 dB
  gain dynamic range.
- 2025 E-band active vector-sum phase shifter reports 1.78-2.55 deg RMS phase
  error over 72.3-82.3 GHz, but with 57.2 mW power.
