# Strict Baseline Metric Table for Broadband mm-Wave Phase Interpolation

**Date:** 2026-05-04

**Scope:** tighter comparison of the six most relevant baselines for the
35 GHz PI -> 70 GHz doubler direction:

1. Qiu 15-38 GHz VSPS
2. Pepe/Zito W-band vector modulator
3. Yu 60 GHz current-reuse vector-sum phase shifter
4. Afroz/Kim/Koh W-band passive phase interpolator T/R channels
5. Garg/Natarajan 28 GHz RTPS
6. Anjos 14-50 GHz APN phase shifter

Values are taken from the local PDFs in `references/`. Derived quantities are
computed in this note:

$$
\mathrm{FBW} = \frac{f_H-f_L}{(f_H+f_L)/2},
\qquad
\mathrm{LSB} = \frac{360^\circ}{2^N},
\qquad
\epsilon_\mathrm{rms}/\mathrm{LSB}
= \frac{\epsilon_\mathrm{rms}}{\mathrm{LSB}}.
$$

## Table 1: Raw Reported Metrics

| Work | Process | Architecture | Frequency / BW | Phase Control | RMS Phase Error | RMS Gain Error / Variation | Gain or IL | DC Power | Area | NF / Linearity |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Qiu et al., 2021, 15-38 GHz VSPS | 65 nm CMOS | Active vector-summing PS with improved quadrature all-pass filter (QAF) | 15-38 GHz 3-dB BW | 360 deg, 6-bit, 64 states, 5.625 deg LSB | 2.23-3.5 deg over 15-38 GHz | 0.7-1 dB over 15-38 GHz | active voltage gain; exact average gain not cleanly extracted from text | 16 mA from 1.2 V = 19.2 mW | 0.16 mm2 core | NF / P1dB not emphasized |
| Pepe/Zito, 2017, W-band VM PS1 | 28 nm FDSOI CMOS | Active vector modulator with single-input double-output IQ generator and programmable VGAs | 78.8-92.8 GHz 3-dB BW; reported center 87.4 GHz | 360 deg, 4-bit, 16 states, 22.5 deg LSB | 9.4 deg at 87.4 GHz; <11.9 deg in 3-dB BW | 1.68 dB at 87.4 GHz; <2 dB in BW | +2.3 dB average gain | 18 mA from 1.2 V = 21.6 mW | core 0.54 x 0.22 mm2 = 0.119 mm2; total 0.54 x 0.31 mm2 | NF 10.8 dB at 87 GHz; avg IP1dB -7 dBm |
| Pepe/Zito, 2017, W-band VM PS2 | 28 nm FDSOI CMOS | Compact active vector modulator variant | 80.2-96.8 GHz 3-dB BW; reported center 89.2 GHz | 360 deg, 4-bit, 16 states, 22.5 deg LSB | 11.2 deg at 89.2/89.4 GHz; <11.9 deg in 3-dB BW | 1.46 dB at 89.2 GHz; <2 dB in BW | +0.83 dB average gain | 18 mA from 1.2 V = 21.6 mW | core 0.54 x 0.12 mm2 = 0.065 mm2; total 0.54 x 0.28 mm2 | NF 11.9 dB at 87/89 GHz; avg P1dB -6 dBm |
| Yu et al., 2016, 60 GHz current-reuse VM | 90 nm CMOS | 4-bit vector-summing PS with tunable current-splitting quadrature amplitude generator and current reuse | 57-64 GHz measured band | 360 deg, 4-bit, 16 states, 22.5 deg LSB | 2.3-7.6 deg over 57-64 GHz after calibration | 0.75-1.6 dB over 57-64 GHz | -0.4 to +2.5 dB at 60 GHz including 1.6 dB output balun loss; peak avg gain 1.1 dB at 59.7 GHz | 11 mA from 1.8 V = 19.8 mW | not cleanly extracted | NF 11 +/- 1.3 dB; P1dB -9.8 +/- 0.8 dBm |
| Afroz/Kim/Koh, 2018, W-band passive PI T/R | 0.13 um SiGe BiCMOS | Quadrature-hybrid-based passive power-domain phase interpolator embedded in T/R channels | Rx: 92-98 GHz gain/NF band, phase error <6 deg at 92-100 GHz; Tx: gain 85-105 GHz, strongest phase result at 94 GHz | 4-bit phase states in channel implementation | Rx <6 deg at 92-100 GHz; Tx <1.5 deg at 94 GHz and <8 deg near saturation | Rx <2 dB; Tx <1.28 dB over 85-105 GHz | Rx gain 17-23 dB; Tx gain 7.5-12 dB, Psat 7.4 dBm | Rx 18 mW; Tx 49.5 mW active / 26 mW quiescent | Rx 1.2 x 0.55 mm2; Tx 1.4 x 0.55 mm2 excluding pads | Rx NF 5.8-6.6 dB; Rx P-1dB -31 dBm; Tx PAE 18.2% |
| Garg/Natarajan, 2017, 28 GHz RTPS RX front end | 65 nm CMOS | Passive RTPS with optimized pi load, preceded by low-power neutralized LNA | RTPS at 28 GHz; 26-30 GHz characterized | RTPS 360 deg, 5-bit, 32 states, 11.25 deg LSB | stand-alone RTPS 0.3 deg at 28 GHz; RX front end 0.4 deg at 28 GHz; <1 deg summary | RTPS IL 7.75 +/- 0.3 dB at 28 GHz; 8 +/- 1.25 dB from 26-30 GHz; RX gain 9.5 +/- 0.4 dB | RTPS IL 7.75 dB; RX gain 9.5 dB | RTPS zero dc; full RX front end 10 mW from 0.9 V | RTPS 0.16 mm2; LNA 0.32 mm2 | RX NF <5.5 dB; RX P1dB about -22 dBm; IIP3 -11.5 dBm |
| Anjos et al., 2020, 14-50 GHz APN PS | 0.25 um BiCMOS | Passive switched all-pass-network phase shifter | 14-50 GHz phase-error-defined BW; 24-30 and 37-43.5 GHz emphasized | 2-bit, 45 deg resolution | <4 deg from 24-30 GHz; <6 deg from 37-43.5 GHz; detailed RMS 3.6 deg at 28 GHz and 5.9 deg at 39 GHz; <10 deg from 14-50 GHz | <0.27 dB from 24-30 GHz; <0.33 dB from 37-43.5 GHz; detailed RMS 0.21 dB at 28 GHz, 0.15 dB at 39 GHz | IL 7.4 +/- 0.26 dB at 28 GHz; 10 +/- 0.22 dB at 39 GHz; S21 varies -5 to -16 dB over full band | zero static power | 0.62 x 0.77 mm2 = 0.48 mm2 total; 0.35 mm2 effective | passive; NF/P1dB not emphasized |

## Table 2: Normalized Comparison

| Work | Nominal Center / Band | Fractional BW | LSB | RMS Phase Error / LSB | Power Class | Loss/Gain Class | What It Proves | What It Does Not Solve |
|---|---:|---:|---:|---:|---|---|---|---|
| Qiu 15-38 GHz VSPS | fc = 26.5 GHz, BW = 23 GHz | 86.8% | 5.625 deg | 0.40-0.62 LSB | 19.2 mW active | active gain, exact value not extracted | Broadband active vector summing can be accurate below 40 GHz | Not proven at V/W band; QAF loading is handled with lossy broadbanding; no NF/P1dB headline |
| Pepe/Zito W-band VM PS1 | fc = 85.8 GHz by 3-dB edges, BW = 14 GHz | 16.3% | 22.5 deg | 0.42 LSB at center; <0.53 LSB in BW | 21.6 mW active | +2.3 dB gain | Direct W-band active VM is feasible with gain and compact core | Phase error is high, NF ~11 dB, compression weak |
| Pepe/Zito W-band VM PS2 | fc = 88.5 GHz by 3-dB edges, BW = 16.6 GHz | 18.8% | 22.5 deg | 0.50 LSB at center; <0.53 LSB in BW | 21.6 mW active | +0.83 dB gain | Compact W-band VM variant halves core area | Same phase/NF/linearity limits; lower gain |
| Yu 60 GHz current-reuse VM | fc = 60.5 GHz, BW = 7 GHz | 11.6% | 22.5 deg | 0.10-0.34 LSB | 19.8 mW active | -0.4 to +2.5 dB gain | Current reuse can keep 60 GHz active VM near 20 mW | Needs calibration; NF ~11 dB; P1dB near -10 dBm |
| Afroz/Kim/Koh W-band passive PI Rx | phase band 92-100 GHz, fc = 96 GHz, BW = 8 GHz | 8.3% | 22.5 deg if 4-bit states | <0.27 LSB | 18 mW Rx channel | 17-23 dB channel gain | Passive power-domain PI can support low-power W-band channels | Interpolator is embedded in full channel; narrow W-band receive window |
| Afroz/Kim/Koh W-band passive PI Tx | Tx gain band 85-105 GHz, fc = 95 GHz, BW = 20 GHz | 21.1% | 22.5 deg if 4-bit states | 0.067 LSB at 94 GHz; <0.36 LSB near saturation | 26-49.5 mW Tx channel | 7.5-12 dB channel gain; Psat 7.4 dBm | Excellent W-band Tx phase accuracy at center and strong efficiency | Full Tx chain, not standalone PI; phase error worsens near saturation |
| Garg/Natarajan 28 GHz RTPS | 26-30 GHz characterized, fc = 28 GHz, BW = 4 GHz | 14.3% | 11.25 deg | 0.027 LSB RTPS; 0.036 LSB RX FE | zero-dc RTPS; 10 mW RX FE | 7.75 dB RTPS IL; 9.5 dB RX gain | Passive RTPS can be extremely accurate and low-power at 28 GHz | Insertion loss remains ~8 dB; not broad enough for wideband 70 GHz clocking |
| Anjos 14-50 GHz APN PS | fc = 32 GHz, BW = 36 GHz | 112.5% | 45 deg | 0.08 LSB at 28 GHz; 0.13 LSB at 39 GHz; <0.22 LSB over 14-50 GHz | zero static power | 7.4 dB IL at 28 GHz; 10 dB IL at 39 GHz | APNs can cover huge bandwidth with low relative phase error | Only 2-bit resolution and high IL; scaling bits likely costs loss/area |

## Ranking by Relevance to Half-Rate PI + Doubling

| Rank | Baseline | Why It Matters |
|---:|---|---|
| 1 | Qiu 15-38 GHz VSPS | This is the closest frequency precedent for a 35 GHz half-rate PI. Its 2.23-3.5 deg RMS error would become 4.46-7 deg after ideal doubling, before doubler AM-PM. That is enough to beat older W-band active VM phase error, but not enough to beat the best recent 60 GHz active front ends. |
| 2 | Pepe/Zito W-band VM | This is the direct W-band active-VM target to beat. It shows the penalty of doing the vector modulation directly near 90 GHz: ~10 deg RMS phase error, ~11 dB NF, and negative-dBm compression. |
| 3 | Yu 60 GHz current-reuse VM | Shows what a carefully optimized active VM can do around 60 GHz at ~20 mW: good calibrated phase error, but still high NF and weak compression. This is a fair V-band active baseline. |
| 4 | Afroz/Kim/Koh W-band passive PI | Closest conceptual neighbor to low-noise/passive interpolation at W-band, but the function is embedded inside full T/R channels. Good benchmark for W-band power efficiency. |
| 5 | Garg/Natarajan 28 GHz RTPS | Best narrowband passive low-error reference. It sets a very high phase-error bar but pays ~8 dB insertion loss and is not directly a broadband/interpolating clock architecture. |
| 6 | Anjos 14-50 GHz APN | Best bandwidth reference. Useful if we use APN/TTDL-style phase generation at 35 GHz, but its 2-bit resolution and 7-10 dB loss show why APN alone is not enough. |

## What the Strict Table Says About Our Target

For a 70 GHz output, the half-rate approach should not claim an easy raw phase
error win. Because the doubler maps

$$
\epsilon_{\Phi,70}=2\epsilon_{\phi,35},
$$

the Qiu-style 35 GHz result would map to roughly 4.5-7 deg RMS at 70 GHz, before
AM-PM. That is better than Pepe/Zito W-band VM, similar to or better than many
older mm-wave PSs, but worse than recent best-in-class 60 GHz active front ends.

The credible win conditions are:

- **Against W-band direct VM:** achieve <4.5 deg RMS at 35 GHz and keep doubler
  AM-PM small, giving <9 deg at 70 GHz.
- **Against strong V-band active VM:** achieve <1 deg RMS at 35 GHz after
  calibration and use a low-AM-PM cleanup/doubler.
- **Against passive RTPS/APN:** avoid 7-10 dB passive loss at the final carrier
  and emphasize clock/jitter metrics rather than zero-dc passive linearity.
- **Against W-band passive PI channels:** present a cleaner standalone
  phase-code-generation block, not an embedded T/R-channel result.

## Useful Figure/Table for the Paper

A compact paper table should probably include:

| Work | f0 | Technique | Bits | RMS phase error | Gain/IL | Power | NF/P1dB | Area | Gap |
|---|---:|---|---:|---:|---:|---:|---:|---:|---|

The `Gap` column is important because a raw metric table alone makes the passive
RTPS look unbeatable on phase error. The correct comparison needs to state what
each approach pays: final-carrier passive loss, active NF/linearity, bandwidth,
or being embedded inside a full T/R chain.
