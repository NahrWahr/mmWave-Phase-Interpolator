<!-- v1.0 -->
# Novel mm-Wave Techniques for Phase Interpolation, VGAs, Combiners, and Frequency Synthesis

**Date:** 2026-05-03
**Context:** Survey of unconventional circuit techniques applicable to the
70 GHz CMPI + ×2 doubler chain (35 GHz CMPI → ×2 → 70 GHz, with 35 GHz
direct injection lock). Emphasis on candidates that could **replace** or
**augment** existing blocks while remaining feasible in CMOS at 35/70 GHz.
Distilled from a brainstorming pass; the second half of this document
expands the five most promising candidates.

---

## Part I — Inventory

For each item: short description, fit to the current chain, and a novelty
rating relative to mainstream mm-wave clocking literature.

### 1. Phase shifting / interpolation

| # | Technique | Fit | Novelty |
|---|-----------|-----|---------|
| 1a | Parametric phase shifter (varactor pump-modulated) | Drop-in CMPI replacement | High |
| 1b | Injection-locked oscillator (ILO) phase rotator | Replaces CMPI; reuses IL structure | Medium |
| 1c | CRLH metamaterial / composite-line phase shifter | Replaces y-phase TL | Medium-high |
| 1d | Slow-wave loaded transmission line | Drop-in for y-phase TL | Low |
| 1e | N-path / commutated phase shifter | Awkward at 35 GHz, OK on reference path | High at mmwave |

### 2. Interpolation VGAs and amp cells

| # | Technique | Fit | Novelty |
|---|-----------|-----|---------|
| 2a | $Q$-enhanced active load (cross-coupled $G_m$) | Add to CMPI tank | Medium |
| 2b | Current-reuse / stacked-$G_m$ interpolator | CMPI variant | Medium |
| 2c | Outphasing (Chireix) as interpolator | Replaces CMPI + VGA + combiner | Medium-high |
| 2d | Class-F (or F$^{-1}$) merged with doubler | Replaces buffer + doubler | High |

### 3. Combiners

| # | Technique | Fit | Novelty |
|---|-----------|-----|---------|
| 3a | Distributed (traveling-wave) drain-line combiner | Output buffer / TTD combiner | Medium |
| 3b | Magic-T / 180° hybrid in CMOS | Balanced doubling | Medium |
| 3c | Non-Foster compensated combiner (NIC-loaded) | Wider-band passive combiner | High, possibly impractical |
| 3d | Standing-wave / coupled-resonator quasi-optical | On-chip field combining | High |

### 4. Distributed amplification + summing as a unifier

The non-obvious construction that fuses §1, §2, and §3: a synthetic
transmission line (gate line + drain line) with $N$ tap-injecting
$G_m$ cells whose enable/scale signals encode phase. See expansion §A.

### 5. Varactor / parametric / pump-doubling

| # | Technique | Fit | Novelty |
|---|-----------|-----|---------|
| 5a | Varactor parametric ×2 doubler (Manley-Rowe) | Replaces transistor doubler | Medium-high |
| 5b | NLTL doubler (varactor-loaded TL with shock edges) | Wideband; narrowband output needs filter | High |
| 5c | Self-pumped varactor phase shifter | Niche | High |
| 5d | Pumped varactor as $Q$-multiplier / regen phase shifter | Combined gain + phase | High |

---

## Part II — The Five Candidates Worth Investigating

These are the items most likely to yield publishable contributions or
real architectural wins for the 35→70 GHz chain. Each is expanded with
operating principle, design parameters, phase-noise reasoning,
tradeoffs, and pointers to the literature.

---

### A. Distributed phase interpolator (§4)

#### A.1 Concept

Replace the entire 35 GHz half of the chain — coupler + $y$-phase TL +
CMPI + buffer — with a single distributed structure.

Build a synthetic transmission line consisting of a gate line and a
drain line, each loaded periodically with $LC$ sections to set
characteristic impedance $Z_0 = \sqrt{L/C}$ and per-section delay
$\tau_s = \sqrt{LC}$. At each section $k \in \{0, 1, \dots, N-1\}$,
attach a small $G_m$ cell whose input taps the gate line and whose
output current injects into the drain line.

A signal $V_\text{in}(t) = V_0 \cos(\omega_0 t)$ propagates down the
gate line. At tap $k$ it has phase
$\phi_k = -\omega_0 k \tau_s = -k \,\Delta\phi$
relative to the input port, with $\Delta\phi = \omega_0 \tau_s$.
The $G_m$ cell at tap $k$, when enabled with weight $w_k$, contributes
a current $I_k(t) = w_k g_m V_0 \cos(\omega_0 t - k \Delta\phi)$ to the
drain line. The drain line is matched at the input end and terminated
into the doubler at the output end. Forward-traveling drain waves from
all enabled taps add coherently at the output.

#### A.2 Phase synthesis

The output phasor is
$$
V_\text{out} \;\propto\; \sum_{k=0}^{N-1} w_k \, e^{-j k \Delta\phi} ,
$$
neglecting line loss and assuming matched terminations.

* **Coarse phase:** enable a single tap $k^\star$ → output phase
  $-k^\star \Delta\phi$. With $N$ taps spaced by $\Delta\phi$, coarse
  resolution is $\Delta\phi$.
* **Fine phase:** enable two adjacent taps $k$ and $k+1$ with weights
  $(w_k, w_{k+1})$. Output phase is
  $$
  \phi_\text{out} = -k\,\Delta\phi -
  \arctan\!\left(\frac{w_{k+1} \sin\Delta\phi}{w_k + w_{k+1}\cos\Delta\phi}\right) .
  $$
  Sweeping the ratio $w_{k+1}/w_k$ from $0$ to $\infty$ rotates
  $\phi_\text{out}$ continuously across $\Delta\phi$.

This is identical in spirit to the CMPI's coarse/fine split — the
coarse phasor selection now happens by tap selection, the fine
interpolation by current-weight ratio. The fine ratio knob is
implemented exactly as in the existing CMPI: differential pair tail
currents.

#### A.3 Why it's worth investigating

* **Eliminates blocks.** No 90° coupler, no separate $y$-phase TL, no
  output buffer. The drain line is the buffer.
* **True-time-delay characteristic.** Each tap's contribution scales
  linearly with frequency, so the phase-versus-frequency curve is
  linear (TTD), not constant (PS). The block is broadband by
  construction — a property your current architecture lacks.
* **Distributed noise.** No single noise-dominant summing node. Each
  $G_m$ cell contributes, but the per-cell $g_m$ is small.
* **Process-tolerant resolution.** Tap spacing is set by $L$ and $C$
  values, which track. The interpolation weights are current ratios,
  also matched. CMPI suffers from absolute $g_m$ variation; the
  distributed version inherits the same fine-resolution mechanism but
  the coarse mechanism is purely geometric.

#### A.4 Design parameters and constraints

* **Tap count $N$.** Larger $N$ → finer coarse step → lower fine
  interpolation burden, but more loading capacitance per drain line
  section and lower max useful frequency.
* **Per-section delay $\tau_s$.** Choose $\Delta\phi = 2\pi / N$ for
  uniform coverage of $[0, 2\pi)$; e.g., $N = 8$ taps gives
  $\Delta\phi = 45°$, $\tau_s \approx 3.6$ ps at 35 GHz.
* **Characteristic impedance.** Match $Z_0$ of both lines to the input
  and output terminations; $Z_0 = 50\,\Omega$ is the conservative pick,
  but lower $Z_0$ (e.g., $25\,\Omega$) admits more $G_m$ cells without
  cutting bandwidth.
* **Termination.** Drain line input must be terminated to absorb the
  reverse-traveling wave; gate line output must be terminated to absorb
  the through signal. Both terminations dissipate signal power.

#### A.5 Phase-noise reasoning

Each enabled $G_m$ cell adds thermal noise current $\overline{i_n^2} =
4kT\gamma g_m$. Drain-line summation of $M$ enabled cells gives noise
power scaling as $M$, signal power as $M^2$ (coherent addition), so
output SNR scales as $M$. CMPI sums two coherent currents with the
full tail noise of both branches, so per-input SNR is comparable; the
distributed structure wins only by reducing per-cell $g_m$.

The distributed structure's PN advantage is therefore subtle and
needs simulation confirmation.

#### A.6 Open questions

* Loss along the drain line: each section's loss attenuates earlier
  taps relative to later taps, so the realized phasor magnitudes
  deviate from $w_k$. Calibration table or pre-distortion needed?
* Process-induced mismatch in $LC$ values shifts $\Delta\phi$ per
  section. Is monotonicity of phase versus tap index preserved?
* Termination loss: typical distributed amps eat 3 dB at the gate-line
  termination. Can this be reused — e.g., recycled into the
  injection-lock path?

#### A.7 References

**Foundational TTD / distributed phase shifter literature:**
* B. Cetinoneri et al., *Continuous True-Time Delay Phase Shifter
  Using Distributed Inductive and Capacitive Miller Effect*, IEEE
  T-MTT, 2019 — analog-controlled distributed delay with constant Z₀.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/8668421/)
* N. S. Barker, G. M. Rebeiz, *Distributed MEMS True-Time Delay Phase
  Shifters and Wide-Band Switches*, IEEE T-MTT, 1998.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/734503/)
* *A 12 ps True-Time-Delay Phase Shifter With 6.6% Delay Variation
  at 20–40 GHz*, IEEE conference, 2013.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/6569522/)
* *CMOS Millimeter Wave Phase Shifter Based on Tunable Transmission
  Lines*, IEEE conference, 2013.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/6658442/)
* E. Adabi Firouzjaei, *mm-Wave Phase Shifters and Switches*, UCB
  EECS Tech Report 2010-163 — broad survey including distributed
  topologies.
  [Berkeley](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2010/EECS-2010-163.pdf)

**Vector-modulator / interpolator background (closest existing
patterns to combine with tap-injected TLs):**
* *140 GHz 28 nm CMOS Vector-Sum Phase Shifter Based on Gilbert Cell
  and Current-Steering Amplifiers*, MDPI Chips, 2024.
  [MDPI](https://www.mdpi.com/2674-0729/4/4/50)
* *A Low Phase Error Vector Modulator Using TEST Tunable I/Q
  Generator for mmWave Communication*, IEEE, 2023.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/10121032/)
* *A Wideband and Low-Power mm-Wave Variable-Gain Phase Shifter
  Based on a Source-Switching Scheme*, AEÜ 2024.
  [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1434841124001158)

**Existing local reference:** *A 63.3 GHz Half-Nanosecond TTD Line
With Gain Compensation* — closest to this concept; their TTD line is
purely passive, but adding tap-injection turns it into the proposed
block.

---

### B. Class-F (or F$^{-1}$) merged with the doubler (§2d)

#### B.1 Concept

A class-F$^{-1}$ amplifier presents an open at even harmonics and a
short at odd harmonics of the fundamental at the drain. The drain
voltage waveform is a half-sinusoid; the drain current is a square
wave. The $2f_0$ component of the drain voltage is large and
deliberately not shorted — it is harvested.

If the fundamental is 35 GHz, the natural class-F$^{-1}$ load network
already contains a 70 GHz resonator. **Tune the output network to
present 70 GHz to the load instead of $f_0$**: the stage becomes a
combined power amplifier and frequency doubler in one transistor
biasing decision.

#### B.2 Why it's worth investigating

* **Block elimination.** Removes the explicit transistor doubler and
  its driver buffer. The same drain network does both.
* **No ad-hoc nonlinearity.** Conventional transistor doublers rely on
  the soft transconductance nonlinearity (typically a Gilbert mixer
  with both inputs tied to $f_0$, or a single device biased near
  pinch-off). Class-F$^{-1}$ uses the hard switching waveform — the
  $2f_0$ component is deterministic and large.
* **Conversion gain.** The stage is an amplifier; the $2f_0$ component
  exists "for free" relative to the drain voltage swing. Conversion
  gain $> 0$ dB is plausible.
* **Flicker upconversion.** Switching mode (saturation–cutoff) reduces
  flicker upconversion compared to small-signal-biased doublers.

#### B.3 Topology sketch

* Cascode common-source stage. Cascode device protects oxide and
  raises $f_T$-effective.
* Gate driven hard by a CML limiting buffer (must convert the
  amplitude-modulated CMPI output to a constant-amplitude phase-only
  signal — see §B.5).
* Drain network: parallel $LC$ tank tuned to 70 GHz; series notch (or
  high-impedance presentation) at 35 GHz to suppress fundamental
  leakage; short at $3f_0 = 105$ GHz to enforce class-F$^{-1}$
  current shape.
* Output match into the next stage (or directly to load) at 70 GHz.

#### B.4 Phase-noise reasoning

In the saturation–cutoff regime, the drain switching edges occur at
the input zero-crossings; AM-to-PM conversion is suppressed because
small AM perturbations don't move the zero-crossings. The doubled
output's PN is therefore $L_\text{in}(f) + 6\,\text{dB}$ from
multiplication, plus thermal noise of the switching device (computed
via the cyclostationary noise framework — see Hajimiri & Lee).

#### B.5 The amplitude-to-phase conversion problem

This is the catch. The CMPI output amplitude varies as $\sqrt{w_1^2 +
2 w_1 w_2 \cos(\phi_2 - \phi_1) + w_2^2}$, so different interpolation
weights produce different output amplitudes. A class-F$^{-1}$ doubler
needs constant-amplitude drive, otherwise the duty cycle of the drain
square wave varies with input amplitude and the $2f_0$ component
amplitude becomes weight-dependent.

Solution: insert a CML limiting buffer or injection-locked buffer
between CMPI and the merged stage. This re-equalizes amplitude before
hard switching. Adds a stage but does not add a tank.

Alternatively, use the merged stage as the *only* large-signal stage
and accept amplitude-dependent gain — fold the gain variation into
the CMPI calibration loop.

#### B.6 Design parameters

* Drain inductor $L_d$ and shunt capacitance to set the 70 GHz tank.
* Series 35 GHz trap (parallel $LC$ in series with output, antiresonant
  at $f_0$) or an open-circuited stub of length $\lambda/4$ at $f_0$.
* Bias point: deep class-AB or class-B for sharper switching; class-C
  for higher efficiency at the cost of conversion gain.

#### B.7 References

**Direct hit — class-F frequency doubler (the merged topology):**
* H. Bameri et al., *A 120-GHz Class-F Frequency Doubler With
  7.8-dBm $P_\text{OUT}$ in 55-nm Bulk CMOS*, IEEE T-MTT, 2023 —
  the published instance of the merged class-F doubler concept.
  Bandwidth 112–125 GHz, conversion gain $-0.46$ dB, peak efficiency
  6.8%. **Read this first.**
  [IEEE Xplore](https://ieeexplore.ieee.org/document/10070744/)

**Class-F / class-F$^{-1}$ mm-wave PAs (load-network design
references):**
* *A 25–35 GHz Neutralized Continuous Class-F CMOS Power Amplifier
  for 5G Mobile*, IEEE JSSC, 2018 — 46.4% peak PAE, harmonic-tuned
  load network in CMOS at 35 GHz (directly your fundamental band).
  [IEEE Xplore](https://ieeexplore.ieee.org/document/8434091/)
* *A V-Band Inverse Class-F Power Amplifier With 16.3% PAE in 65 nm
  CMOS*, IEEE conference, 2016.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/7761675/)
* *A Wideband 60 GHz Class-E/F$_2$ Power Amplifier in 40 nm CMOS*,
  IEEE conference, 2015.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/7337743/)
* *A 43% PAE Inverse Class-F Power Amplifier at 39–42 GHz With a
  λ/4-Transformer Based Harmonic Filter in 0.13-µm SiGe BiCMOS*,
  IEEE conference, 2016.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/7540383/)
* *Comprehensive Study of Class-E/F$_2$ and Inverse Class-F Power
  Amplifiers for mm-Wave Systems Utilizing 130 nm CMOS*,
  Int. J. Circ. Theor. Appl., 2024.
  [Wiley](https://onlinelibrary.wiley.com/doi/abs/10.1002/cta.4030)

**Comparison transistor doublers (baseline):**
* *A 50–70 GHz Frequency Doubler in 90 nm CMOS*, IEEE — V-band CMOS
  doubler with 11 dB conversion loss, used here as a typical
  reference point against which the merged class-F doubler's $-0.46$
  dB conversion gain is striking.
  [ResearchGate](https://www.researchgate.net/publication/261022321_A_50-70GHz_frequency_doubler_in_90nm_CMOS)

**Phase-noise framework for switching stages:**
* A. Hajimiri, T. H. Lee, *A General Theory of Phase Noise in
  Electrical Oscillators*, IEEE JSSC, 1998 — cyclostationary noise
  treatment that applies to the saturating drain waveform.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/658619/) ·
  [Caltech mirror](https://authors.library.caltech.edu/records/r11pe-dnn76)

**Textbook:** S. C. Cripps, *RF Power Amplifiers for Wireless
Communications*, Artech House — the chapters on class-F and class-F$^{-1}$
load network synthesis.

---

### C. Parametric ×2 doubler (§5a)

#### C.1 Concept

Replace the transistor doubler with a varactor whose capacitance is
modulated by the 35 GHz signal itself (signal = pump). Energy is
transferred to a tank resonant at 70 GHz via reactance modulation.
Manley-Rowe relations give the theoretical efficiency ceiling.

#### C.2 Manley-Rowe and the lossless ceiling

For a nonlinear reactance pumped at $\omega_p$ with input signal at
$\omega_s$ producing tones at $m\omega_p + n\omega_s$, Manley-Rowe
states
$$
\sum_{m,n} \frac{m\, P_{m,n}}{m\omega_p + n\omega_s} = 0, \qquad
\sum_{m,n} \frac{n\, P_{m,n}}{m\omega_p + n\omega_s} = 0 ,
$$
where $P_{m,n}$ is the power flowing into port $(m\omega_p + n\omega_s)$.

For pure frequency doubling $\omega_p = \omega_s = \omega_0$, output
at $2\omega_0$: with appropriate idler terminations (typically a
short circuit at all unwanted mixing products), the theoretical
conversion efficiency is **100%**. The transistor ×2 doubler is
typically $-6$ to $-10$ dB at mm-wave; the parametric doubler is
limited only by varactor $Q$ and parasitic loss.

#### C.3 Topology sketch

* Varactor in series between input ($f_0$) and idler termination,
  shunted by the 70 GHz output tank.
* Input port: 35 GHz matching network.
* Output port: 70 GHz tank, coupled to load.
* Idler terminations: high-$Q$ shorts (or opens, depending on
  topology) at $f_0$ on the output side and at $2f_0$ on the input
  side, to enforce only the desired $\omega_p + \omega_s = 2\omega_0$
  product.

#### C.4 Phase-noise reasoning

Conversion is reactance-only (lossless varactor → no thermal noise
contribution from the active device). Pump PN appears at the output
multiplied by $\times 2$, so output PN $= L_\text{in}(f) + 6\,\text{dB}$.
This is identical to the floor of a transistor doubler — the
parametric structure does *not* beat the multiplication limit.

The advantage shows up in the **flicker corner** and **added-noise
floor**:
* Transistor doubler: $1/f$ noise from biased-transistor flicker
  upconverts; thermal noise of bias current adds.
* Parametric doubler: no biased transistor in the conversion path;
  varactor-thermal noise is set by the loss conductance $G_\text{loss} =
  \omega C / Q$, much smaller than $g_m$ of a transistor.

The expected gain is at low offsets (in-band PN floor) and in the
flicker corner — which is exactly where the doubler hurts the
overall clock PN budget.

#### C.5 Practical limit: varactor $Q$ at mm-wave CMOS

* AMOS varactor at 35 GHz in 28/40/65 nm CMOS: $Q \approx 10$ to $20$.
* Hyperabrupt junction varactor (where available): higher $Q$,
  steeper $C(V)$, but not standard in digital CMOS.
* Tank loss at $Q = 15$: insertion loss $\approx -2$ dB at 70 GHz.

This is still better than a transistor doubler's $-6$ to $-10$ dB
conversion loss. **Worth a quantitative simulation** before adopting.

#### C.6 Pump amplitude requirement

Reactance modulation depth $\Delta C / C_0$ scales with pump voltage
across the varactor. To get reasonable conversion, need $\Delta C / C_0
\approx 0.3$, which typically requires $V_\text{pump} \gtrsim$ several
$kT/q$ × varactor turn-on slope — i.e., a few hundred mV peak. The
35 GHz pump path must therefore deliver sufficient swing into the
varactor; an LC matching network with voltage gain at $f_0$ helps.

#### C.7 Open questions

* Quantitative comparison: parametric ×2 vs. transistor ×2 in your
  process, at expected pump amplitude. PN floor, conversion gain,
  area, robustness.
* Stability: parametric oscillation at $f_0/2$ (sub-harmonic
  parametric oscillation) is a real failure mode if idler is not
  properly terminated.

#### C.8 References

**Foundational:**
* J. M. Manley, H. E. Rowe, *Some General Properties of Nonlinear
  Elements — Part I. General Energy Relations*, Proc. IRE, 1956.
  [Semantic Scholar](https://www.semanticscholar.org/paper/Some-General-Properties-of-Nonlinear-Elements-Part-Manley-Rowe/d427b76b370bbc440730ee2820f5ebbf76c26719)
* *Frequency Conversion With Nonlinear Reactance* (NIST monograph,
  follow-up analysis applying Manley-Rowe to multipliers and mixers).
  [NIST](https://nvlpubs.nist.gov/nistpubs/jres/58/jresv58n5p227_A1b.pdf)

**Design technique anchored in Manley-Rowe:**
* *Design Technique for High-Efficiency Frequency Doublers Based on
  the Manley and Rowe Energy Relations*, IBM J. R&D / IEEE — direct
  application of M-R bounds to design parameters.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/5392101)
* *Design of High-Efficiency Frequency Doublers Based on
  Manley-Rowe's Energy Relations*, IEEE conference, 2004.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/1474195)

**CMOS varactor parametric multipliers:**
* O. Momeni, E. Afshari, *A High-Power Broadband Passive Terahertz
  Frequency Doubler in CMOS* — passive (varactor) doubler reaching
  THz, low DC power.
  [ResearchGate](https://www.researchgate.net/publication/258793523_A_High-Power_Broadband_Passive_Terahertz_Frequency_Doubler_in_CMOS)
* *100 GHz Parametric CMOS Frequency Doubler* — 130 nm CMOS,
  conversion loss 14.5 dB, output 94–108 GHz.
  [IEEE Xplore](https://ieeexplore.ieee.org/iel5/7260/5634427/05617298.pdf)
* *A 300 GHz Single Varactor Doubler in 40 nm CMOS*, IEEE conference,
  2017.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/8048260)
* *300-GHz Balanced Varactor Doubler in Silicon CMOS for Ultra-High
  Speed Wireless Communications*, IEEE T-MTT, 2018.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/8316256/)
* *Parametric Conversion Using Custom MOS Varactors*, EURASIP J. Wirel.
  Comm. Networking, 2006 — discusses subharmonic pumping and varactor
  modeling for parametric circuits in CMOS.
  [EURASIP](https://jwcn-eurasipjournals.springeropen.com/articles/10.1155/WCN/2006/12945)

**Textbook:** S. A. Maas, *Nonlinear Microwave and RF Circuits*,
Artech House — chapter on parametric multipliers and varactor doublers.

**Existing local reference:** *A Phase-Interpolation and
Quadrature-Generation Method Using Parametric Energy Transfer in CMOS*
— same parametric mixing principle, applied to phase shifting; its
citation graph is the best entry point for low-frequency parametric
work in CMOS.

---

### D. Injection-locked oscillator as continuous phase rotator (§1b)

#### D.1 Concept

Replace the CMPI with a 35 GHz $LC$ oscillator that is locked to two
quadrature injection signals of programmable strength. Adler/Razavi
locking theory says the lock phase tracks the *vector sum* of the
injections. By controlling the injection amplitudes, the lock phase
rotates continuously.

#### D.2 Lock phase derivation

For an oscillator with free-running frequency $\omega_0$ and quality
factor $Q$, locked by injection $I_\text{inj}$ at frequency $\omega_0$,
the steady-state phase shift between injection and oscillator
fundamental is (Razavi 2004):
$$
\sin\phi_L = \frac{I_\text{inj}}{I_\text{osc}} \cdot \frac{2Q\,\Delta\omega}{\omega_0} ,
$$
where $\Delta\omega$ is the detuning from the oscillator's
free-running frequency. The lock range is
$$
\omega_L = \frac{\omega_0}{2Q} \cdot \frac{I_\text{inj}}{I_\text{osc}} .
$$

If two injections are applied at the same frequency but in quadrature
phase, $I_x \cos(\omega_0 t)$ and $I_y \sin(\omega_0 t)$, they
combine into a single equivalent injection
$$
I_\text{eff} = \sqrt{I_x^2 + I_y^2}\,\cos(\omega_0 t - \phi_\text{inj})
$$
with effective phase $\phi_\text{inj} = \arctan(I_y / I_x)$. The
locked oscillator output phase tracks $\phi_\text{inj}$ within the
lock range. **Programming $I_x$ and $I_y$ continuously rotates the
output phase across the full $[0, 2\pi)$ range.**

This is the same control signal as the CMPI (current-ratio
interpolation), but the output node is now an oscillator's tank
rather than a current-summing node.

#### D.3 Why it's worth investigating

* **PN filtering.** Inside the lock range, the oscillator follows the
  injection PN (low-pass filtered through the tank). Outside, it
  free-runs. For mm-wave clock generation where the loop bandwidth is
  set by the locking dynamics, this gives a clean spectral mask.
* **Architectural reuse.** You already use an ILO for the doubler.
  Inserting another ILO at 35 GHz extends an architectural pattern
  that already works.
* **Constant-amplitude output.** Output amplitude is set by tank $Q$
  and oscillator bias — independent of injection weights. This solves
  the amplitude-variation problem that complicates the class-F doubler
  (§B.5). The output of the ILO rotator is naturally suitable for
  driving a switching doubler.

#### D.4 Lock-range design

Required lock range: must cover process and temperature variation of
the free-running frequency, plus any pulling from the doubler stage.
A practical target is $\omega_L / \omega_0 \approx 5$%, i.e., $\pm 875$
MHz at 35 GHz. With $Q \approx 10$ at the oscillator tank, this
requires $I_\text{inj} / I_\text{osc} \approx 1$ — i.e., injection
currents comparable to the oscillator core current. That's a large
injection. Two design responses:
* Lower the tank $Q$ deliberately (load with resistor) to widen the
  lock range; pay PN penalty.
* Use sub-harmonic injection at $f_0/N$, locking via $N$-th harmonic
  pulling. Wider effective lock range per injection power.

#### D.5 Stability and unwanted modes

* Pulling: if injection is too weak or detuning too large, the
  oscillator free-runs; the rotation control fails silently.
  Calibration is therefore mandatory.
* Both injections at exactly $\omega_0$: the composite phase is well
  defined. If the injections drift in frequency relative to each
  other (which they cannot in this architecture, since both come from
  the same 35 GHz reference), the analysis breaks. Confirm via
  simulation.

#### D.6 Open questions

* Cascaded ILO PN: 35 GHz rotator ILO + 70 GHz doubler ILO. Does the
  cascade preserve PN? Probably yes if both lock ranges adequately
  cover the upstream PN bandwidth.
* Is the injection-current control linearity sufficient for fine
  phase resolution (e.g., 6 bits)?

#### D.7 References

**Foundational:**
* R. Adler, *A Study of Locking Phenomena in Oscillators*, Proc. IRE,
  vol. 34, pp. 351–357, June 1946.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/1697085/)
* B. Razavi, *A Study of Injection Locking and Pulling in
  Oscillators*, IEEE JSSC, 2004 — the canonical reference and the
  basis of the lock-phase derivation in §D.2.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/1327738/) ·
  [Razavi PDF](https://www.seas.ucla.edu/brweb/papers/Conferences/RCICC2003.pdf)

**Lock-range extension via multi-phase / progressive injection:**
* A. Mirzaei, M. E. Heidari, R. Bagheri, A. A. Abidi, *Multi-Phase
  Injection Widens Lock Range of Ring-Oscillator-Based Frequency
  Dividers*, IEEE JSSC, vol. 43, pp. 656–671, 2008.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/4456785/)

**ILO as phase rotator (the relevant working topology):**
* M. Hossain, A. C. Carusone, *A Programmable Phase Rotator Based on
  Time-Modulated Injection-Locking*, IEEE Symp. VLSI Circuits, 2010 —
  closest published instance of the §D concept.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/5560263/) ·
  [Author PDF](https://sites.ualberta.ca/~masum/pdfs/mhossain-vlsi2010.pdf)
* H. Hedayati et al., *Injection Locking Phase Rotator for Outphasing
  Transmitter*, Microelectronics Journal, 2015 — combines §D and §E
  in one block.
  [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0026269215000658)
* *CMOS Injection Locked Oscillators for Quadrature Generation at
  Radio-Frequency*, Microelectronics Journal — quadrature ILO topologies.
  [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0026269206001807)

**Recent ILO theory and broadband ILRO results:**
* H. Mohammadnezhad, B. Razavi et al., *A Study of Injection Locking
  in Oscillators and Frequency Dividers*, IEEE JSSC, 2023 — modern
  unified treatment.
  [Razavi PDF](http://www.seas.ucla.edu/brweb/papers/Journals/Hossein_JSSC_2023.pdf)
* *A Wideband Injection-Locked Quadrature Clock Generator*, IEEE JSSC,
  2016 — Caltech, 0.2–11.7 GHz with sub-1.5° quadrature error.
  [Caltech mirror](https://www.mics.caltech.edu/wp-content/uploads/2017/09/Raj_Saeedi_JSSC16.pdf)

**Pathological mode worth knowing:**
* *Amplitude-to-Phase Conversion in Injection-Locked CMOS Ring
  Oscillators*, arXiv 2412.20069, 2024 — characterizes AM→PM in ILOs,
  relevant to whether the rotator preserves CMPI's amplitude
  modulation as phase.
  [arXiv](https://arxiv.org/html/2412.20069v1)

---

### E. Outphasing (Chireix) as the phase interpolator (§2c)

#### E.1 Concept

Drive two saturated buffer stages with phase-modulated signals
$s_1 = A\,e^{j(\phi + \theta)}$ and $s_2 = A\,e^{j(\phi - \theta)}$,
combine them in a Chireix combiner. The output is
$$
s_\text{out} = s_1 + s_2 = 2A\cos\theta \cdot e^{j\phi} ,
$$
so $\phi$ controls phase, $\theta$ controls amplitude, both
independently. Each branch runs in saturation (constant amplitude) →
the combiner is the only place where amplitude information lives.

For pure phase rotation (CMPI replacement): vary $\phi$, hold $\theta$
constant. For phase + amplitude (e.g., to compensate process gain
variation): vary both.

#### E.2 Why it's worth investigating

* **Combiner is the interpolation node.** Different mental model
  entirely: the *passive* combiner (transformer or Chireix
  reactive network) sums the phasors. No CML tail noise at the
  summing point.
* **Branches are limiters.** Each branch is a saturated buffer →
  AM-to-PM rejection at each branch. PN comes only from the limiter's
  zero-crossing jitter, which is usually below CML tail-noise PN by
  several dB.
* **Direct compatibility with class-F doubler.** Each branch can be a
  class-F$^{-1}$ stage (§B), with the combiner doing both outphasing
  summation and 70 GHz extraction.
* **Architectural reframe.** Even if you don't adopt it, the
  outphasing perspective is useful for the discussion section of the
  paper: it casts CMPI as an "internal combiner" version of the same
  vector-summing principle, which makes the comparison framework
  cleaner.

#### E.3 The two phase-shifter branches

Outphasing requires *two* synchronized phase shifters generating
$\phi + \theta$ and $\phi - \theta$. Options:
* APF cascade with differential control (one APF gives $+\theta$, its
  mirror gives $-\theta$).
* DLL-based phase shifter (clean linear phase versus control; requires
  reference clock at $f_0$, not always available).
* Two ILO rotators (§D) sharing the same reference — clean but
  doubles the ILO count.

The complexity overhead is real. The win has to be on PN or
efficiency to justify it.

#### E.4 Combiner choice

* **Transformer (lossy) combiner.** Two primary windings driven by the
  two branches, secondary into load. Simple, robust, but the
  out-of-phase component dissipates as heat (or is reflected to the
  drivers). For *constant-amplitude* operation (phase-only
  modulation, $\theta$ fixed), the loss can be designed out.
* **Chireix (lossless reactive) combiner.** Each branch sees a
  resistive load only at the design $\theta$; off-design, sees a
  reactive component that detunes the branch. Perfect for fixed
  $\theta$ phase-only operation.

For your application (phase modulation only, amplitude held constant
or set by separate VGA), the Chireix combiner with fixed $\theta$ is
the natural pick.

#### E.5 PA flavor matters

Saturated branches mean class-D, class-E, or class-F$^{-1}$. Each
maps cleanly to a doubler-merge if the combiner is tuned to $2f_0$:
the combiner becomes both the outphasing summer *and* the 70 GHz
output filter.

#### E.6 Open questions

* Does the doubled complexity (two phase shifters + outphasing
  combiner) actually beat CMPI's PN at iso-power, in your process?
* Calibration: branch-to-branch mismatch directly maps to phase
  error; what's the calibration strategy?

#### E.7 References

**Foundational:**
* H. Chireix, *High-Power Outphasing Modulation*, Proc. IRE,
  vol. 23, no. 11, pp. 1370–1392, Nov. 1935.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/1685799/)

**mm-wave outphasing — most directly relevant:**
* *A 28-GHz Packaged Chireix Transmitter With Direct On-Antenna
  Outphasing Load Modulation Achieving 56%/38% PA Efficiency at
  Peak/6 dB Back-Off*, IEEE IMS / T-MTT extended (2018) — 45 nm CMOS
  SOI; demonstrates that mm-wave Chireix is practical.
  [IEEE Xplore (conf.)](https://ieeexplore.ieee.org/document/8429015/) ·
  [IEEE Xplore (journal)](https://ieeexplore.ieee.org/document/8654717/)
* *A 28-GHz Current-Mode Inverse-Outphasing Power Amplifier in
  65-nm CMOS*, IEEE conference, 2021.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/9660333)
* *A 28 GHz Current-Mode Outphasing Power Amplifier With 23.3 dBm
  $P_\text{sat}$ and 44.2% PAE in 40 nm CMOS*, IEEE conference, 2023.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/10090270/)
* *A 30-GHz CMOS SOI Outphasing Power Amplifier With Current-Mode
  Combining for High Backoff Efficiency and Constant-Envelope
  Operation*, UCSB tech report / IEEE.
  [UCSB PDF](https://wcsl.ece.ucsb.edu/sites/default/files/assets/a_30-ghz_cmos_soi_outphasing_power_amplifier_with_current_mode_combining_for_high_backoff_efficiency_and_constant_envelope_operation.pdf)
* B. Rabet, *A 28 GHz Single-Input Linear Chireix (SILC) Power
  Amplifier in 130 nm SiGe*, IEEE T-MWT, 2020 — single-input variant
  removes the dual phase-shifter overhead.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/9034129/)

**Lower-frequency reference designs (combiner / topology basis):**
* *A CMOS Outphasing Power Amplifier With Integrated Single-Ended
  Chireix Combiner*, IEEE TCAS-II, 2010.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/5473145/)
* *A 2.14-GHz Chireix Outphasing Transmitter*, IEEE T-MTT — the
  modern reference design that the mm-wave variants extend.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/1440733/)
* *Analysis and Design of Chireix Outphasing Switched-Mode Power
  Amplifier*, IEEE conference, 2019.
  [IEEE Xplore](https://ieeexplore.ieee.org/document/8699044)

**Cross-link with §D:** the *Injection Locking Phase Rotator for
Outphasing Transmitter* paper (cited in D.7) is exactly the
combination of these two ideas — ILO rotators feeding a Chireix
combiner. Best single starting point if you want to evaluate D and E
together.

---

## Part III — Comparison summary

| Candidate | Replaces | PN advantage source | Risk | Paper-worthiness |
|-----------|----------|---------------------|------|------------------|
| A. Distributed phase interpolator | Coupler + TL + CMPI + buffer | Distributed noise; TTD bandwidth | High (large block redesign) | High (potentially a contribution) |
| B. Class-F$^{-1}$ merged with doubler | Buffer + doubler | Switching mode, no flicker upconv. | Medium (amplitude-to-PM problem) | High |
| C. Parametric ×2 doubler | Doubler | No biased transistor; lower in-band floor | Medium (varactor $Q$, parametric oscillation) | Medium-high (clean comparison study) |
| D. ILO phase rotator | CMPI | Tank low-pass filtering of injection PN | Low-medium (lock range vs. PN tradeoff) | Medium |
| E. Outphasing as interpolator | CMPI + VGA + maybe combiner | Limiting branches reject AM noise | Medium-high (two phase shifters + combiner mismatch) | Medium |

---

## Part IV — Recommended next steps

1. **Quantify C (parametric ×2) first.** It is a single block
   replacement, has a clean PN comparison framework (Manley-Rowe vs.
   measured transistor doubler), and even a negative result is a
   useful section of the paper.
2. **Sketch A (distributed phase interpolator) at the block-diagram
   level.** Look for prior art with the exact tap-injection +
   weight-control combination at mm-wave. If none exists, it's the
   strongest paper-worthy contribution.
3. **Use B and E as discussion-section material** even if not adopted:
   they reframe the design space and clarify why you chose CMPI.
4. **Hold D in reserve** as a conservative fallback if CMPI yields
   insufficient PN.

---

## Part V — Consolidated reference index

Concrete IEEE / publisher links collected on 2026-05-03. Per-section
references appear in the §A.7–§E.7 blocks above; this part is a
quick-reference index.

### Foundational papers (must read for each candidate)

| # | Author / Year | Topic | Link |
|---|---------------|-------|------|
| F1 | Adler, 1946 | Injection locking — original locking-phase derivation | [IEEE Xplore](https://ieeexplore.ieee.org/document/1697085/) |
| F2 | Razavi, 2004 | Injection locking and pulling — modern unified treatment | [IEEE Xplore](https://ieeexplore.ieee.org/document/1327738/) |
| F3 | Manley & Rowe, 1956 | Energy relations in nonlinear reactances | [Semantic Scholar](https://www.semanticscholar.org/paper/Some-General-Properties-of-Nonlinear-Elements-Part-Manley-Rowe/d427b76b370bbc440730ee2820f5ebbf76c26719) |
| F4 | Chireix, 1935 | Outphasing modulation | [IEEE Xplore](https://ieeexplore.ieee.org/document/1685799/) |
| F5 | Hajimiri & Lee, 1998 | Cyclostationary phase-noise theory | [IEEE Xplore](https://ieeexplore.ieee.org/document/658619/) |
| F6 | Mirzaei et al., 2008 | Multi-phase injection / wider lock range | [IEEE Xplore](https://ieeexplore.ieee.org/document/4456785/) |

### Direct topology hits

| Candidate | Paper | Link |
|-----------|-------|------|
| §A (Distributed PI) | Cetinoneri, Continuous TTD via distributed Miller, T-MTT 2019 | [IEEE Xplore](https://ieeexplore.ieee.org/document/8668421/) |
| §A | Distributed MEMS TTD phase shifters (Barker/Rebeiz) | [IEEE Xplore](https://ieeexplore.ieee.org/document/734503/) |
| §B (Class-F doubler) | **120-GHz Class-F Frequency Doubler in 55-nm CMOS** | [IEEE Xplore](https://ieeexplore.ieee.org/document/10070744/) |
| §B | 25–35 GHz Continuous Class-F PA in CMOS, JSSC 2018 | [IEEE Xplore](https://ieeexplore.ieee.org/document/8434091/) |
| §B | V-band Inverse Class-F PA in 65 nm CMOS, 2016 | [IEEE Xplore](https://ieeexplore.ieee.org/document/7761675/) |
| §C (Parametric ×2) | Manley-Rowe-based doubler design technique | [IEEE Xplore](https://ieeexplore.ieee.org/document/5392101) |
| §C | 100 GHz parametric CMOS frequency doubler | [IEEE Xplore](https://ieeexplore.ieee.org/iel5/7260/5634427/05617298.pdf) |
| §C | 300 GHz single varactor doubler in 40 nm CMOS | [IEEE Xplore](https://ieeexplore.ieee.org/document/8048260) |
| §C | 300-GHz balanced varactor doubler, T-MTT 2018 | [IEEE Xplore](https://ieeexplore.ieee.org/document/8316256/) |
| §C | Parametric conversion using custom MOS varactors | [EURASIP](https://jwcn-eurasipjournals.springeropen.com/articles/10.1155/WCN/2006/12945) |
| §D (ILO rotator) | Hossain, Programmable phase rotator via time-modulated injection-locking | [IEEE Xplore](https://ieeexplore.ieee.org/document/5560263/) |
| §D | Injection-locking phase rotator for outphasing TX | [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0026269215000658) |
| §D | Mohammadnezhad/Razavi, JSSC 2023 study of ILO theory | [Razavi PDF](http://www.seas.ucla.edu/brweb/papers/Journals/Hossein_JSSC_2023.pdf) |
| §D | Wideband ILRO quadrature clock generator, JSSC 2016 | [Caltech PDF](https://www.mics.caltech.edu/wp-content/uploads/2017/09/Raj_Saeedi_JSSC16.pdf) |
| §E (Outphasing) | 28 GHz packaged Chireix TX, 56%/38% PAE | [IEEE Xplore](https://ieeexplore.ieee.org/document/8429015/) |
| §E | 28 GHz current-mode outphasing PA, 40 nm CMOS, 2023 | [IEEE Xplore](https://ieeexplore.ieee.org/document/10090270/) |
| §E | 28 GHz current-mode inverse-outphasing PA, 65 nm CMOS | [IEEE Xplore](https://ieeexplore.ieee.org/document/9660333) |
| §E | 30 GHz current-mode combining outphasing PA (UCSB) | [UCSB PDF](https://wcsl.ece.ucsb.edu/sites/default/files/assets/a_30-ghz_cmos_soi_outphasing_power_amplifier_with_current_mode_combining_for_high_backoff_efficiency_and_constant_envelope_operation.pdf) |
| §E | Single-Input Linear Chireix (SILC), 28 GHz SiGe | [IEEE Xplore](https://ieeexplore.ieee.org/document/9034129/) |

### Vector-modulator and active phase-shifter background
(useful baselines to compare each candidate against the conventional
solution)

* 140 GHz 28 nm CMOS Vector-Sum Phase Shifter (Gilbert + current
  steering): [MDPI Chips](https://www.mdpi.com/2674-0729/4/4/50)
* Low-Phase-Error Vector Modulator With TEST Tunable I/Q,
  IEEE 2023: [IEEE Xplore](https://ieeexplore.ieee.org/document/10121032/)
* Wideband Variable-Gain Phase Shifter via Source-Switching, AEÜ 2024:
  [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1434841124001158)
* Adabi Firouzjaei, *mm-Wave Phase Shifters and Switches* (Berkeley
  EECS Tech Report 2010-163) — survey of architectures including
  distributed/TTD: [Berkeley](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2010/EECS-2010-163.pdf)

### Textbooks (no online links — physical or library)

* S. C. Cripps, *RF Power Amplifiers for Wireless Communications*,
  Artech House — class-F / class-F$^{-1}$ load synthesis (§B).
* S. A. Maas, *Nonlinear Microwave and RF Circuits*, Artech House —
  parametric multipliers and varactor doublers (§C).
* T. H. Lee, *The Design of CMOS Radio-Frequency Integrated Circuits* —
  baseline reference for CMOS RF building blocks.
* B. Razavi, *Design of Integrated Circuits for Optical
  Communications* — ILO and clock-recovery treatments (§D).
