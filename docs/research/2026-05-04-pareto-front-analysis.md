# Pareto-Front View of Broadband mm-Wave Phase Shifters

**Date:** 2026-05-04

**Question:** can the 35 GHz PI -> 70 GHz doubler architecture sit on the
Pareto front when bandwidth, phase accuracy, gain/loss, power, and area are all
considered together?

## 1. Pareto Axes

A phase-shifter architecture is Pareto-competitive if no other architecture is
better or equal on all important axes and strictly better on at least one. For
this project the axes are:

| Axis | Direction | Why it matters |
|---|---:|---|
| Frequency / carrier | higher is harder | 70 GHz operation is more difficult than 28-40 GHz operation |
| Fractional bandwidth | higher is better | broadband phase accuracy matters for wideband arrays and clock distribution |
| RMS phase error | lower is better | sets beam-pointing error and phase-code quality |
| RMS gain error or output variation | lower is better | gain spread creates array taper error and AM-PM risk |
| Gain / insertion loss | higher gain or lower loss is better | passive loss must be recovered elsewhere |
| DC power | lower is better | array scaling and thermal density |
| Core area | lower is better | array pitch and routing density |
| NF / linearity / jitter | context-dependent | RX wants NF/IIP3; TX wants compression/PA drive; clock wants jitter |

There is no single universal Pareto front because passive phase shifters,
receiver front ends, transmitter front ends, and clock/LO phase interpolators
optimize different secondary metrics. The useful comparison is therefore a set
of **conditional fronts**.

## 2. Representative Points

| Work | Type | Freq. / FBW | RMS Phase Error | Gain / IL | Power | Area | Pareto Strength | Pareto Cost |
|---|---|---:|---:|---:|---:|---:|---|---|
| Qiu 15-38 GHz VSPS | active vector-sum | 15-38 GHz, 86.8% FBW | 2.23-3.5 deg | active gain, exact avg not extracted | 19.2 mW | 0.16 mm2 | Very strong bandwidth + accuracy + power below 40 GHz | Not demonstrated at V/E/W band; NF/P1dB not headline |
| Pepe/Zito W-band VM PS1 | active vector modulator | 78.8-92.8 GHz, 16.3% FBW | 9.4 deg center, <11.9 deg BW | +2.3 dB gain | 21.6 mW | 0.119 mm2 core | Direct W-band active VM with gain | High phase error, NF ~11 dB, weak IP1dB |
| Pepe/Zito W-band VM PS2 | active vector modulator | 80.2-96.8 GHz, 18.8% FBW | 11.2 deg center, <11.9 deg BW | +0.83 dB gain | 21.6 mW | 0.065 mm2 core | Compact direct W-band VM | Worse phase/gain than lower-frequency active points |
| Yu 60 GHz current-reuse VM | active vector-sum | 57-64 GHz, 11.6% FBW | 2.3-7.6 deg calibrated | -0.4 to +2.5 dB | 19.8 mW | not extracted | Good V-band active-power point | NF ~11 dB, P1dB ~-10 dBm, calibration needed |
| Afroz/Kim/Koh W-band passive PI Rx | passive PI in Rx channel | 92-100 GHz phase band, 8.3% FBW | <6 deg | 17-23 dB Rx gain | 18 mW channel | 0.66 mm2 channel | W-band low-power receiver channel | Not a standalone phase shifter; narrow BW |
| Afroz/Kim/Koh W-band passive PI Tx | passive PI in Tx channel | 85-105 GHz gain band, 21.1% FBW | <1.5 deg at 94 GHz; <8 deg near saturation | 7.5-12 dB gain; Psat 7.4 dBm | 26-49.5 mW channel | 0.77 mm2 channel | Excellent W-band center accuracy + useful Tx output | Full Tx channel, not compact PI cell |
| Garg/Natarajan 28 GHz RTPS | passive RTPS + Rx FE | 26-30 GHz, 14.3% FBW | 0.3 deg RTPS, 0.4 deg RX FE | 7.75 dB RTPS IL; 9.5 dB RX gain | 0 dc RTPS; 10 mW RX FE | 0.16 mm2 RTPS | Near-unbeatable narrowband phase accuracy / power | ~8 dB passive loss and narrow band |
| Anjos 14-50 GHz APN | passive APN switched PS | 14-50 GHz, 112.5% FBW | 3.6 deg at 28 GHz, 5.9 deg at 39 GHz, <10 deg full band | 7.4 dB IL at 28 GHz; 10 dB at 39 GHz | zero static | 0.35-0.48 mm2 | Huge bandwidth with zero static power | 2-bit resolution and high IL |
| Jiang/Cai/Huang/Que/Wang 2025 E-band active PS | active vector-sum | 72.3-82.3 GHz, 12.9% FBW | 1.78-2.55 deg uncalibrated | gain not in search snippet | 57.2 mW | 0.263 mm2 | Best high-frequency active phase-accuracy point found | High power |
| Wang/Gao/Baltus 2018 60 GHz VM | active vector modulator | 56-65 GHz, 14.9% FBW | 1.4 deg at 60 GHz | 0.4 dB IL | 38 mW | not extracted | Excellent 60 GHz phase/gain accuracy | Higher power; not W/E-band |
| KAIST 2025 Ka-band VGPS | active vector-summing amplifier | 25.3-29.6 GHz, 15.7% FBW | 0.58 deg at 28 GHz; <0.75 deg BW | +3.1 dB peak gain | 11.3 mW | 0.38 mm2 | Excellent low-frequency active Pareto point | Ka-band only; area larger than compact VM cores |

## 3. Conditional Pareto Fronts

### 3.1 Phase Accuracy vs Power

Approximate front:

- **Garg/Natarajan RTPS:** ~0.3 deg at 28 GHz with zero RF dc, but ~8 dB IL.
- **KAIST 2025 Ka-band VGPS:** <0.75 deg over 25.3-29.6 GHz at 11.3 mW, but
  only Ka-band and 0.38 mm2.
- **Wang/Gao/Baltus 60 GHz VM:** 1.4 deg at 60 GHz at 38 mW.
- **2025 E-band active PS:** 1.78-2.55 deg over 72.3-82.3 GHz at 57.2 mW.

The trend is clear: as carrier frequency rises, sub-3-deg phase error is
available, but power rises sharply. A half-rate 70 GHz architecture must either:

1. deliver **~2-3 deg output RMS phase error at much lower than 57 mW**, or
2. deliver **wider bandwidth / lower jitter / better integration with a 70 GHz
   clock path** at comparable power.

### 3.2 Bandwidth vs Loss/Power

Approximate front:

- **Anjos APN:** 112.5% FBW, zero static power, but 7-10 dB IL and only 2-bit
  phase resolution.
- **Qiu VSPS:** 86.8% FBW at 19.2 mW with 6-bit phase resolution, but below
  40 GHz.
- **2025 wideband active VSPS with impedance compensation:** reported 52.3% FBW
  over roughly 24-41 GHz at 11.2 mW and <2.1 deg RMS, but full primary-source
  verification is still needed.
- **Pepe/Zito W-band VM:** 16-19% FBW at W-band with ~21.6 mW, but ~10 deg RMS.
- **2025 E-band active PS:** 12.9% FBW with ~2 deg RMS, but 57.2 mW.

This front says that high bandwidth and high frequency together are expensive.
Our half-rate architecture can be Pareto-relevant if it uses a broadband 35 GHz
phase-generation network and moves only a narrowband/regenerative function to
70 GHz.

### 3.3 Phase Accuracy vs Insertion Loss / Gain

Passive approaches dominate power but not loss:

- RTPS/APN cores consume zero RF dc but commonly pay 7-10 dB insertion loss.
- Active vector modulators often provide around 0 dB to positive gain but pay
  static power and NF.
- Passive W-band PI embedded in T/R channels gets good system gain by wrapping
  the passive interpolation in active LNA/PA stages.

Therefore, a half-rate PI + doubler should not try to beat passive RTPS on RF dc
power. It should beat passive approaches by avoiding a high-loss full-360 deg
network at 70 GHz and by presenting a usable regenerated 70 GHz output.

### 3.4 Area vs Performance

Compact direct active VM points:

- Pepe/Zito PS2: 0.065 mm2 core at W-band, but ~11 deg RMS phase error.
- Qiu: 0.16 mm2 core below 40 GHz with 2.23-3.5 deg RMS.
- 2025 E-band active: 0.263 mm2 core with 1.78-2.55 deg RMS but 57.2 mW.
- Garg RTPS: 0.16 mm2 passive RTPS at 28 GHz, but passive loss.
- Anjos APN: 0.35-0.48 mm2 for extreme bandwidth and passive operation.

If our half-rate architecture includes PI + limiter/ILO + doubler, the total
core area can easily exceed compact direct VM cores. To remain area-competitive,
the architecture must collapse functions:

- use the 35 GHz phase generator as the doubler injection path;
- combine limiting and doubling where possible;
- avoid a large standalone 35 GHz TTDL unless bandwidth is the main claim;
- keep multi-phase generation compact, preferably transformer/coupler based
  rather than long-line based.

## 4. Projected Pareto Position of 35 GHz PI -> 70 GHz Doubler

The output phase error is

$$
\epsilon_{\Phi,70}
\approx
2\epsilon_{\phi,35}
+ \epsilon_\mathrm{AMPM}
+ \epsilon_\mathrm{lock}
+ \epsilon_\mathrm{cal}.
$$

The output timing jitter is approximately

$$
\sigma^2_{t,70}
\approx
\sigma^2_{t,\mathrm{PI35}}
+ \sigma^2_{t,\mathrm{cleanup}}
+ \sigma^2_{t,\mathrm{doubler,add}}.
$$

The 70 GHz output power variation from vector amplitude variation is roughly

$$
\Delta P_{70}(c) \approx 2\Delta A_{35,\mathrm{dB}}(c)
$$

before saturation or limiting.

### Scenario A: Qiu-Class 35 GHz PI, Minimal Cleanup

Assume:

- 35 GHz RMS phase error: 2.2-3.5 deg.
- Output phase error after ideal doubling: 4.4-7 deg.
- Total power: PI (~20 mW) + doubler/cleanup.
- Bandwidth: potentially broad if the QAF/PI is truly 35 GHz-wide.

Pareto position:

- Beats Pepe/Zito W-band VM on phase error if AM-PM is small.
- Does not beat best 60/E-band active phase shifters on phase accuracy.
- Risks losing on power once cleanup/doubler are included.
- Useful paper claim only if we emphasize 70 GHz clock/jitter or final-carrier
  simplification.

### Scenario B: Calibrated Small-Sector 35 GHz PI + Limiter/ILO + Low-AM-PM Doubler

Assume:

- 35 GHz RMS phase error after calibration: <=1 deg.
- 35 GHz sector spacing <=45 deg, so midpoint amplitude droop <=0.69 dB.
- Doubler AM-PM: <=1 deg/dB.
- Total phase error: roughly 2-3 deg at 70 GHz.
- Total power target: <=30-40 mW.
- Core area target: <=0.25-0.35 mm2.

Pareto position:

- Competes with the 2025 E-band active PS on phase accuracy, while potentially
  using less power.
- Beats older W-band direct VMs by a large margin in phase error and likely NF.
- Does not beat zero-dc passive RTPS/APN on power, but can beat them on usable
  gain/output regeneration and avoiding 70 GHz passive loss.
- This is the strongest non-distributed version of our approach.

### Scenario C: Half-Rate TTDL / APN Phase Generation + Doubler

Assume:

- 35 GHz phase generation is delay-based, so

$$
\phi_{35}(\omega)=\omega\tau
\quad\Rightarrow\quad
\Phi_{70}(\Omega)=\Omega\tau.
$$

Pareto position:

- Strongest bandwidth / beam-squint story.
- Likely loses area and loss unless delay generation is compact or merged with
  interpolation.
- More naturally leads into the later distributed/tap-injected idea.

## 5. What We Must Beat

The table below converts the Pareto view into design targets.

| Claim We Want | Baseline to Beat | Required Target |
|---|---|---|
| Better than direct W-band active VM | Pepe/Zito W-band VM: ~10-12 deg RMS, 21.6 mW, +0.8 to +2.3 dB gain, ~11 dB NF | <8 deg RMS at 70 GHz, comparable or lower power for PI+doubler, lower additive jitter/NF |
| Competitive with modern E-band active PS | 2025 E-band: 1.78-2.55 deg RMS, 57.2 mW, 0.263 mm2 | 2-3 deg RMS at 70 GHz with <40-50 mW and <=0.35 mm2 |
| Better than passive RTPS/APN in system sense | Garg/Anjos: zero static power but 7-10 dB IL | avoid 7-10 dB loss at 70 GHz; provide regenerated output and clock/jitter advantage |
| Better than W-band passive PI channels as a block | Afroz/Koh: excellent system result but embedded in full T/R channels | standalone 70 GHz phase-coded output with clearer block-level phase/noise metrics |
| Better broadband story than narrow active V/E-band PS | E-band and W-band active points: ~13-20% FBW | either >20% equivalent phase-code bandwidth or TTD-preserving behavior |

## 6. Likely Pareto Claim for the Paper

The strongest claim is **not**:

> lowest phase error of any mm-wave phase shifter.

That is too hard because narrowband passive RTPS and modern active Ka/V/E-band
phase shifters are very strong.

The stronger and more defensible claim is:

> A half-rate phase interpolator followed by a low-AM-PM doubler/regenerator can
> occupy a new Pareto point for 70 GHz clock phase generation: lower final-carrier
> interpolation complexity than direct active vector modulators, no 7-10 dB
> passive phase-shifter loss at 70 GHz, and competitive phase accuracy if the
> 35 GHz interpolation error is calibrated below 1 deg.

## 7. Design Rules from the Pareto Analysis

1. **Do not interpolate over 90 deg at 35 GHz unless we have a limiter.**
   The midpoint amplitude droop is -3 dB, which becomes about -6 dB at the
   doubled output before saturation.

2. **Use <=45 deg sectors at 35 GHz.**
   This keeps midpoint amplitude droop around -0.69 dB and makes AM-PM
   manageable.

3. **Treat the doubler as part of the phase shifter.**
   Its AM-PM, additive jitter, conversion gain, and lock range determine whether
   the architecture is Pareto-competitive.

4. **Calibration is not optional for a top-tier phase-error claim.**
   To get <=2 deg RMS at 70 GHz, the 35 GHz phase error budget is roughly
   <=1 deg RMS before doubler nonidealities.

5. **Pick the comparison metric carefully.**
   If we compare only RMS phase error, passive RTPS and modern E-band active PS
   are hard to beat. If we compare phase accuracy plus final-carrier loss,
   additive jitter, and scalable 70 GHz implementation, the half-rate approach
   becomes interesting.

## 8. Immediate Next Analysis

A useful next plot would place representative works in three 2-D projections:

1. RMS phase error vs power.
2. Fractional bandwidth vs RMS phase error.
3. RMS phase error vs gain/loss.

Then overlay three projected points for our architecture:

- conservative: Qiu-class 35 GHz PI + conventional doubler;
- optimized: calibrated small-sector PI + limiter/ILO + low-AM-PM doubler;
- bandwidth-focused: TTD/APN-based half-rate phase generation + doubler.

This will make clear whether our architecture is a new Pareto point or just a
system-level rearrangement.

## Sources

Local PDFs:

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

Additional current context:

- Jiang et al., 2025, *An E-Band High-Precision Active Phase Shifter Based on
  Inductive Compensation and Series Peaking Enhancement Techniques*.
- Huang/Wang/Que, 2024, *A 71.5 to 81 GHz Active Phase Shifter in 40 nm CMOS
  Technology*.
- Wang/Gao/Baltus, 2018, *A 60 GHz 360 deg phase shifter with 2.7 deg phase
  resolution and 1.4 deg RMS phase error in 40-nm CMOS technology*.
- KAIST 2025, *A Ka-Band CMOS Variable-Gain Phase Shifter With an
  Impedance-Invariant High-Gain Vector-Summing Amplifier*.
