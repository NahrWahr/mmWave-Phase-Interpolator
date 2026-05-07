# Existing Broadband Phase Interpolation Approaches and Gaps

**Date:** 2026-05-04

**Purpose:** summarize what existing mm-wave phase-shifter and phase
interpolation papers achieve, what they give up, and where a 35 GHz
interpolator followed by 70 GHz regeneration/doubling could make a real
contribution.

This note is based primarily on the PDFs in `references/`, with review context
from Adabi Firouzjaei's *mm-Wave Phase Shifters and Switches* and a broad
mm-wave phased-array review. Values below are reported/measured values from the
papers where available; blank fields mean the extracted text did not provide a
clean value.

## Benchmark Table

| Work | Technique | Freq. / BW | Phase Range / Bits | RMS Phase Error | RMS Gain Error / Loss Variation | Gain / IL | Power | Area | NF / Linearity | Main Shortcoming |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Pepe & Zito, 2017, **Two mm-Wave Vector Modulator Active Phase Shifters With Novel IQ Generator in 28 nm FDSOI CMOS** | Active vector modulator with LE coupled-line quadrature coupler and programmable VGAs | PS1: 78.8-92.8 GHz 3-dB BW; PS2: 80.2-96.8 GHz 3-dB BW | 360 deg, 4-bit, 22.5 deg step | PS1: 9.4 deg at 87.4 GHz, <11.9 deg in BW; PS2: 11.2 deg at 89.2 GHz, <11.9 deg in BW | PS1: 1.68 dB, <2 dB in BW; PS2: 1.46 dB, <2 dB in BW | PS1: +2.3 dB avg; PS2: +0.83 dB avg | 18 mA from 1.2 V = 21.6 mW | PS1 core 0.54 x 0.22 mm2; PS2 core 0.54 x 0.12 mm2 | NF 10.8/11.9 dB; avg IP1dB -7/-6 dBm | Good W-band gain and compactness, but phase error is high for fine beamforming, NF is large, compression is weak, and only 4-bit phase resolution. Active VGA interpolation burns static current. |
| Qiu et al., 2021, **15-38 GHz Vector-Summing Phase-Shifter With Improved I/Q Generator** | Active vector-summing phase shifter with improved quadrature all-pass filter (QAF) | 15-38 GHz 3-dB BW | 360 deg, 6-bit, 64 states | 2.23-3.5 deg from 15-38 GHz | 0.7-1 dB | Active voltage gain, exact gain not cleanly extracted | 16 mA from 1.2 V = 19.2 mW | 0.16 mm2 core | Not emphasized | Excellent broadband I/Q and low phase error at 15-38 GHz, but it is not demonstrated at V/W band. The QAF uses added resistors to tame loading, so broadbanding is bought with loss/noise/power in the active summer. |
| Yu et al., 2016, **60-GHz 19.8-mW Current-Reuse Active Phase Shifter** | Vector-summing with tunable current-splitting quadrature amplitude generator; current reuse | 57-64 GHz | 360 deg, 4-bit | 2.3-7.6 deg after calibration | 0.75-1.6 dB | -0.4 to +2.5 dB at 60 GHz including 1.6 dB output balun loss | 11 mA from 1.8 V = 19.8 mW | not extracted | NF 11 +/- 1.3 dB; P1dB -9.8 +/- 0.8 dBm | Good low-power active 60 GHz result, but needs calibration, has high NF, poor compression, and only moderate phase accuracy across 57-64 GHz. |
| Garg & Natarajan, 2017, **28-GHz Low-Power RX Front-End With 360 deg RTPS** | Passive reflection-type phase shifter with optimized pi load, integrated after LNA | RTPS around 28 GHz; 26-30 GHz characterized | 360 deg, 5-bit, 11.25 deg step | RTPS: 0.3 deg at 28 GHz; RX FE: 0.4 deg at 28 GHz; <1 deg noted near 28 GHz | RTPS IL 7.75 +/- 0.3 dB; RX gain 9.5 +/- 0.4 dB | RTPS IL 7.75 dB; RX gain 9.5 dB | RX FE 10 mW; RTPS itself zero dc | RTPS 0.16 mm2; LNA 0.32 mm2 | RX NF <5.5 dB; front-end P1dB about -22 dBm; IIP3 -11.5 dBm | Very strong narrowband 28 GHz passive baseline. Main weakness is RTPS insertion loss and narrow fractional bandwidth; LNA gain is needed to hide the passive loss. |
| Basaligheh et al., 2020, **28-30 GHz CMOS RTPS With Full 360 deg Range** | Passive RTPS with Lange coupler, switched inductor, and varactors | 28-30 GHz | 360 deg, continuous analog control | not clearly extracted | average IL / return-loss over band; loss variation not cleanly extracted | 9.5 dB avg IL at 29 GHz | zero dc in RF phase shifter | 388 x 615 um2 = 0.23 mm2 | passive, high linearity expected | Zero RF dc and simple one-control load, but still about 9.5 dB loss and limited bandwidth. At array scale, the required pre/post gain costs power and NF. |
| Anjos et al., 2020, **14-50 GHz Phase Shifter With All-Pass Networks** | Switched all-pass network phase shifter | 14-50 GHz phase-error-defined BW; 5G bands 24-30 and 37-43.5 GHz | 2-bit, 45 deg resolution | <4 deg from 24-30 GHz; <6 deg from 37-43.5 GHz; ~3.6 deg at 28 GHz and 5.9 deg at 39 GHz in detailed results | <0.27 dB / <0.33 dB in the 5G bands | 7.4 dB IL at 28 GHz; 10 dB IL at 39 GHz | zero static power | 0.48 mm2 total, 0.35 mm2 effective | passive, linearity not the issue | Excellent bandwidth, but only 2-bit phase resolution and high IL. Scaling to finer resolution likely increases switch loss/area. |
| Afroz/Kim/Koh, 2018, **W-Band T/R Elements With Quadrature-Hybrid-Based Passive PI** | Quadrature-hybrid-based passive power-domain phase interpolator in SiGe BiCMOS T/R channels | Rx 92-98 GHz; Tx 85-105 GHz gain range noted | T/R channel phase control, full phase shifting implied | Rx <6 deg at 92-100 GHz; Tx <1.5 deg at 94 GHz, <8 deg near saturation | Rx <2 dB; Tx <1.28 dB over 85-105 GHz | Rx gain 17-23 dB; Tx gain 7.5-12 dB, Psat 7.4 dBm | Rx 18 mW; Tx 49.5 mW active, 26 mW quiescent | Rx 1.2 x 0.55 mm2; Tx 1.4 x 0.55 mm2 excluding pads | Rx NF 5.8-6.6 dB; Rx P-1dB -31 dBm; Tx PAE 18.2% | Power-efficient for W-band channels, but the phase-interpolation function is embedded in a full T/R channel. Narrow W-band receive window and passive hybrid area/loss remain concerns. |
| Sarkas et al., W-band CMOS/SiGe I-Q phase shifters | Lumped I/Q splitter plus weighted adder / phase rotator in full TX/RX chains | CMOS TX 80-94 GHz; SiGe RX 70-77 GHz | 360 deg, 4-bit, 22.5 deg step | CMOS TX absolute phase error up to 14 deg; SiGe RX <8 deg | CMOS amp error up to 5.5 dB; SiGe gain imbalance <3 dB | CMOS TX peak gain 3.8 dB; SiGe RX peak gain 17 dB | CMOS TX 142 mW; SiGe RX 128 mW | TX 800 x 150 um2; RX 150 x 500 um2 noted in thesis | RX min NF about 7 dB; RX IP1dB -22 dBm | Early W-band proof point; useful architecture reference, but high power and large phase/amplitude errors by modern standards. |
| Kadam et al., 2020, **28 GHz Reflective-Type Transmission-Line-Based Phase Shifter** | Passive reflective transmission-line phase shifter plus LNA/buffer | 28 GHz | 180 deg, 11.25 deg resolution | 3 deg at 28 GHz | not extracted | PS-only IL 17 dB | low/zero dc for passive PS; full chip has active LNA/buffer | full active area 0.41 mm2 | not extracted | Doubles TL phase shift, but only 180 deg range and 17 dB loss make it unsuitable as a direct scalable interpolator. |
| Wang et al., 2019, **60-GHz Low-Noise VGA and Interpolation-Based Gain Cell** | Interpolation-based gain cell for array pattern shaping, with LNA/VGA and cross-coupled feedback | 57-64 GHz region | vector interpolation for gain/array shaping, not a standalone 360 deg PS | phase variation over gain tuning reduced; exact PS error not the headline | gain tuning -2 to 15.8 dB | max gain 15.8 dB at 57 GHz | max 54 mA from 1.1 V = 59.4 mW | VGLNA 950 x 665 um2; LNA 810 x 657 um2 | NF 6.5 dB at 57 GHz; IIP3 -11.3 to -16 dBm | Interesting interpolation/gain-cell idea, but high current and area; optimized for receiver gain/noise, not fine phase synthesis. |
| Jung & Min, 2020, **3-30 GHz 68.5-ps CMOS TTD** | Passive switched-line true-time delay using coupled/noncoupled APNs | 3-30 GHz | 4-bit delay; max 68.5 ps, min 4.6 ps | delay error <2 ps | gain error <3.2 dB | avg IL 13.5 dB | zero dc in passive delay | 1.7 x 0.2 mm2 | passive, linear | Solves beam squint over huge BW, but IL is high and it is a delay block, not a compact continuous 360 deg phase interpolator. |
| Chen et al., 2026, **2-19.5 GHz 150-ps TTD** | Switched TTD with cascaded series-capacitor APNs and 8-shaped transformer | 2-19.5 GHz | 5-bit delay; max 150 ps, min step 4.838 ps | delay error <3.7 ps | not extracted | not fully extracted | zero dc in passive delay | 0.209 x 0.816 mm2 | passive, linear | Excellent area efficiency for TTD, but below mm-wave/V-band and still not a 70 GHz phase-interpolating clock generator. |
| Yu & Zhao, 2026, **6-33 GHz Half-Nanosecond TTD With Gain Compensation** | Path-selecting TTD with T-coil peaking amplifiers and gain compensation | 6-33 GHz | 6-bit delay; half-ns range | not extracted | gain compensated to ~0 dB overall | ~0 dB overall gain | active, power not extracted | 1.6 x 1.2 mm2 | not extracted | Strong wideband TTD, but large area and active complexity; aimed at array delay, not low-jitter phase-code generation. |

## Qualitative Shortcomings by Architecture

### Active vector-summing / vector-modulator phase shifters

Strengths:

- Naturally support 360 deg phase control through I/Q sign selection and current
  or gain weighting.
- Can provide conversion gain, compensating passive loss elsewhere.
- High phase resolution is easy digitally because weights can be DAC/current
  controlled.

Shortcomings:

- Static power is unavoidable because the phase interpolation is performed by
  active VGAs/current-steering cells.
- NF is often high at mm-wave because the interpolator sits in the RF path; the
  local W-band examples report around 11 dB NF.
- Linearity is weak compared with passive phase shifters. Reported IP1dB values
  around -10 to -6 dBm are common in the extracted active examples.
- Broadband I/Q generation is the hard problem. The 15-38 GHz QAF result is
  excellent, but the W-band FDSOI result still has about 10-12 deg RMS phase
  error.
- Phase and gain are coupled through vector magnitude. This is a problem if the
  following stage is nonlinear, such as a limiter, doubler, or PA.

Gap for us:

- A half-rate interpolator at 35 GHz can exploit the lower-frequency broadband
  QAF/vector-sum ideas, but the output is regenerated at 70 GHz. The key question
  is whether doubling preserves the phase-code map while suppressing the RF-path
  NF and bandwidth burden of a direct 70-90 GHz vector modulator.

### Passive RTPS and transmission-line phase shifters

Strengths:

- Zero RF dc power in the phase shifter core.
- High linearity.
- Very low phase error is possible at a fixed band, especially near 28 GHz.

Shortcomings:

- Insertion loss is the dominant cost. Local examples show about 7.75-9.5 dB
  loss for full 360 deg RTPS at 28-30 GHz, and 17 dB for the 180 deg reflective
  TL phase shifter.
- Loss forces an LNA/VGA/PA around the phase shifter, moving power and NF cost
  elsewhere.
- Bandwidth is typically narrow when the design is optimized for low loss and
  full 360 deg range.
- Passive elements and couplers occupy significant area at lower mm-wave bands.

Gap for us:

- If phase interpolation is done at 35 GHz and then doubled, we may avoid putting
  a lossy full-360 deg passive network directly at 70 GHz. A passive/quasi-passive
  phase generator could still be useful at 35 GHz as the quadrature or coarse
  phase source.

### All-pass-network phase shifters and true-time-delay cells

Strengths:

- Best answer to wideband beam squint; phase slope can be made delay-like rather
  than constant-phase.
- APNs can cover multiple 5G bands with good phase flatness.

Shortcomings:

- APN switched phase shifters pay in resolution and loss. The 14-50 GHz APN
  phase shifter is only 2-bit and still has 7-10 dB insertion loss in the 5G
  bands.
- TTD blocks have high insertion loss and large area when implemented in silicon.
- TTD provides time delay, not directly a compact full-360 deg high-resolution
  clock phase interpolator.
- Active gain-compensated TTDs become full analog front ends, not small phase
  cells.

Gap for us:

- Distributed/tap-injected interpolation could borrow the TTD benefit without
  using a standalone switched delay line. The open research question is whether a
  synthetic line with weighted transconductance taps can combine phase
  interpolation, gain, and delay behavior in one structure.

### Passive hybrid / power-domain phase interpolation

Strengths:

- Good W-band power efficiency has been demonstrated in full T/R channels.
- Passive hybrid interpolation avoids a noisy active current-summing node.
- Compatible with high-frequency SiGe front ends.

Shortcomings:

- The hybrid and passive power-domain network still have area/loss.
- Best results are embedded in full T/R channels, making the standalone
  interpolator tradeoff harder to isolate.
- Phase error is good at one center frequency but can rise across frequency or
  near saturation.

Gap for us:

- This is probably the closest conceptual neighbor to a low-noise phase
  interpolator. Our contribution would need to show either lower complexity, a
  cleaner clock-generation story, or a better interface to a frequency doubler.

## Cross-Cutting Gaps in Existing Work

1. **Phase error is still not uniformly low at W/V band.** The best 15-38 GHz
   vector-summing result has 2-3.5 deg RMS error, but W-band active vector
   modulators are closer to 10-12 deg. Passive W-band/T/R results can be better,
   but are narrowband or embedded in larger channels.

2. **Power is shifted, not eliminated.** Passive RTPS cores consume zero dc, but
   their loss requires LNA/PA gain. Active vector modulators avoid insertion loss
   but burn 20 mW-class static power per phase shifter, before array-level
   distribution overhead.

3. **NF and linearity are poor in active interpolators.** Around 11 dB NF and
   negative-dBm compression points are not attractive for a low-jitter RF/clock
   path.

4. **Broadband I/Q generation is the bottleneck.** Almost every vector-summing
   approach reduces to this problem. Loading of the I/Q generator by the vector
   summer corrupts quadrature unless compensated with resistors, inductive
   peaking, buffers, or calibration.

5. **Amplitude/phase coupling is under-discussed for nonlinear follow-on blocks.**
   Vector summing naturally changes output amplitude with phase code unless
   weights are constrained or calibrated. That is tolerable in an RX gain path,
   but dangerous before a doubler, limiter, or injection-locked stage because it
   can convert AM error into PM error or code-dependent conversion gain.

6. **Phase-noise/jitter is rarely the headline metric.** Most phase-shifter
   papers report S-parameters, phase/gain error, NF, and P1dB. For a clock/LO
   phase interpolator, additive phase noise and jitter are first-order metrics.
   This leaves room for a paper that frames phase interpolation as clock
   generation rather than only beamforming S-parameter control.

7. **TTD and phase-shifter literatures are not well unified.** Wideband arrays
   need TTD, but compact mm-wave phase shifters approximate delay over a narrow
   band. A distributed interpolator could bridge these by making interpolation
   happen along a delay structure instead of after a separate I/Q generator.

## Implications for Our 35 GHz -> 70 GHz Direction

The strongest opening is not simply "another vector modulator." Existing vector
modulators already do that well below W-band, and W-band examples exist. The
more interesting framing is:

- **Move interpolation to 35 GHz** where broadband I/Q generation and current
  steering are easier.
- **Regenerate at 70 GHz** with a doubler or injection-locked doubler so the
  final high-frequency node is not a broadband high-resolution vector summer.
- **Measure/argue phase noise and jitter**, not only S-parameter phase error.
- **Control amplitude before nonlinear doubling**, either by constant-envelope
  interpolation, limiting, ILO cleanup, or calibration.
- **Explore distributed interpolation** as the novel architecture that merges
  phase selection, interpolation, gain, and true-time-delay behavior.

## Immediate Research Plan

1. Build a stricter metric table for the most relevant baselines: Qiu 15-38 GHz
   VSPS, Pepe/Zito W-band VM, Yu 60 GHz current-reuse VM, Afroz/Koh W-band
   passive PI, Garg/Natarajan 28 GHz RTPS, and Anjos 14-50 GHz APN.
2. Normalize metrics into comparable figures:
   - RMS phase error per bit/LSB.
   - Power per phase state or per array element.
   - Loss/gain penalty before the next nonlinear block.
   - Fractional bandwidth.
   - Area normalized by wavelength if comparing 28/35/60/90 GHz.
3. Identify what our architecture must beat:
   - <5 deg RMS equivalent phase error after doubling.
   - lower additive jitter/PN than a direct W-band active vector modulator.
   - no 8-10 dB passive loss at 70 GHz.
   - calibration path for amplitude-dependent doubler phase error.
4. Decide whether the primary novelty claim is:
   - half-rate interpolation plus frequency doubling,
   - distributed/tap-injected phase interpolation,
   - low-noise doubler/regenerator after an interpolator,
   - or a system-level comparison framework.

## Source Notes

Local PDFs used:

- `references/Two_mm-Wave_Vector_Modulator_Active_Phase_Shifters_With_Novel_IQ_Generator_in_28_nm_FDSOI_CMOS.pdf`
- `references/A_1538_GHz_Vector-Summing_Phase-Shifter_With_360_Phase-Shifting_Range_Using_Improved_I_Q_Generator.pdf`
- `references/A_60-GHz_19.8-mW_Current-Reuse_Active_Phase_Shifter_With_Tunable_Current-Splitting_Technique_in_90-nm_CMOS.pdf`
- `references/A_28-GHz_Low-Power_Phased-Array_Receiver_Front-End_With_360_RTPS_Phase_Shift_Range.pdf`
- `references/A 28-30 GHz CMOS Reflection-Type Phase Shifter with Full 360° Phase Shift Range.pdf`
- `references/A_1450-GHz_Phase_Shifter_With_All-Pass_Networks_for_5G_Mobile_Applications.pdf`
- `references/Power-Efficient_W_-Band_9298_GHz_Phased-Array_Transmit_and_Receive_Elements_With_Quadrature-Hybrid-Based_Passive_Phase_Interpolator.pdf`
- `references/W-band_65-nm_CMOS_and_SiGe_BiCMOS_transmitter_and_receiver_with_lumped_I-Q_phase_shifters.pdf`
- `references/A 28 GHz Reflective-Type Transmission-Line-Based Phase Shifter.pdf`
- `references/60-GHz_Low-Noise_VGA_and_Interpolation-Based_Gain_Cell_in_a_40-nm_CMOS_Technology.pdf`
- `references/A_Compact_330-GHz_68.5-ps_CMOS_True-Time_Delay_for_Wideband_Phased_Array_Systems.pdf`
- `references/A_Compact_219.5-GHz_150-ps_True_Time_Delay_Circuit_With_High_Area_Efficiency_of_882.4-ps_mm2.pdf`
- `references/A_633-GHz_Half-Nanosecond_True-Time_Delay_Line_With_Gain_Compensation_for_Wideband_Large-Scale_Antenna_Array.pdf`

Online review/context checked:

- E. Adabi Firouzjaei, *mm-Wave Phase Shifters and Switches*, UCB/EECS-2010-163.
- J. S. Hong and S. Ko, *Review of Recent Phased Arrays for Millimeter-Wave
  Wireless Communication*, Sensors, 2018.
