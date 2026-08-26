# Pintle Injector Spiral Manifold — MATLAB Script Development Log

A record of the design/review conversation covering the spiral (volute) manifold
feasibility script for a LOX/LCH4 movable pintle injector project.

---

## 1. Starting Materials

Three files were reviewed to establish context:

- **`pintle_injector_complete_notes.md`** — consolidated project notes: how a
  pintle injector works, parts list, METU thesis baseline geometry (Table 3.1,
  Type-1: pintle angle 20°, annular gap 0.5 mm, tip diameter 8 mm, pintle gap
  1.5 mm, rod diameter 3 mm), the spiral+vane manifold concept and its
  validating precedents (Saturn V F-1 turbine exhaust manifold, several
  patents), the SolidWorks workflow, the master project checklist, and
  LOX/LCH4 literature property values.
- **`pintle_spiral_manifold_feasibility.m`** — the original, thesis-referenced
  MATLAB script: multi-row design-point table (O/F = 1–4 from thesis Table
  2.3), ideal-gas GCH4 fuel placeholder, full non-dimensional/spray analysis,
  vane-count sensitivity sweep, console diagnostics, and a summary log.
- **`gemini-code-....txt`** — a simplified rewrite of that script ("v1"): a
  single hardcoded NASA CEA design point, real LOX/LCH4 cryogenic liquid
  properties (replacing the ideal-gas placeholder), and a 5%-of-starting-area
  floor on the spiral cross-section (to avoid a zero-area singularity at
  θ = 360°) — but with most of the diagnostics, the sensitivity sweep, and
  several plots stripped out.

---

## 2. Comparing the Original Script to the "v1" Rewrite

Beyond the three changes the user already knew about (ideal-gas placeholder
removed, CEA cryogenic data integrated, 5% area floor added), the following
differences were identified:

1. **Fuel phase changed** from gaseous methane (GCH4) to liquid methane
   (LCH4) — a full liquid-liquid architecture instead of liquid-gas. The
   Mach-number/choking check (only relevant to a compressible gas exit) was
   dropped accordingly.
2. **Design-point sourcing replaced**: the original selected from a 4-row
   thesis table (O/F = 1–4) via a `designIdx`, with a built-in sanity check
   cross-verifying C\*/Cf against thrust. v1 hardcoded a single, different
   design point (O/F = 3.2, Pc = 20 bar, C\* = 1831.2 m/s, Cf = 1.4876) and
   dropped the table/selector/cross-check.
3. **Mass-flow calculation method changed**: original read `mdotFuel`/`mdotOx`
   directly from the thesis table; v1 computes them from
   `mdotTotal = Thrust/(C*·Cf)` split by O/F ratio.
4. **Non-dimensional/spray analysis (thesis Section 5) was stripped down**:
   K1 characteristic number, Weber number, `Re_fuel`, `Re_ox`, and the
   empirical spray-angle correlation (Eqs. 15–16) were all removed; only TMR
   and the momentum-based cone angle remained.
5. **Sensitivity sweep removed** — the vane-count vs. pressure-drop study
   (original Section 10) was gone.
6. **Summary/limitations log removed** (original Section 11).
7. **Diagnostic/flagging logic removed**: the scale-effect margin flag, the
   pressure-budget-exceeded flag, and nearly all `fprintf` console output.
8. **Pressure-drop budget comparison removed** (`dP_budget` and its
   comparison against `dP_total`).
9. **One plot dropped**: the "pressure drop breakdown" bar chart.
10. **A bug was introduced**: stray `[cite: 3]` citation artifacts were left
    *outside* comments on two executable lines (the `TMR` and
    `theta_cone_deg` assignments) — this would throw an "undefined variable
    'cite'" error at runtime in MATLAB.
11. Minor property tweaks beyond the propellant swap: `rho_LOX` 1141 → 1134
    kg/m³, `mu_LOX` 1.9e-4 → 1.86e-4 Pa·s.

---

## 3. Explanation of Points 4, 5, and 7 — and Their Impact

- **Point 4 (non-dimensional numbers)**: TMR alone gives the spray *angle*,
  not whether the sheets actually atomize well. Weber number is the direct
  atomization indicator; the two Reynolds numbers indicate laminar vs.
  turbulent behavior on each exit stream; K1 is the thesis's own
  gap/opening-distance tuning number; the empirical spray-angle correlation
  cross-checks the momentum-based cone angle (thesis reports ~14.6% typical
  disagreement between the two, expected rather than an error). Without this
  section, the script could produce a geometrically valid manifold feeding an
  injector that doesn't actually atomize properly, with no way to detect it.
- **Point 5 (vane-count sensitivity sweep)**: the pressure-drop model uses one
  assumed vane loss coefficient (`K_vane = 0.3`). The sweep shows the
  trade-off curve (more vanes → better swirl removal, more Δp) so a vane
  count can be chosen against the pressure budget before CAD, rather than
  relying on a single unexamined guess.
- **Point 7 (diagnostic/flagging logic)**: automated pass/fail gates — the
  margin check catches the boundary layer consuming the whole channel at
  *some* angle (easy to miss by eye on a plot); the budget check catches
  total Δp quietly exceeding the available feed pressure. Without these, a
  silent failure mode could go unnoticed until CFD or hardware testing.

---

## 4. Reintegration (Points 4–9) and Bug Fix

All of the above were reintegrated into a new script version ("v2"), adapted
for the liquid-liquid LOX/LCH4 architecture:

- Non-dimensional numbers (Section 5): K1, Weber number, `Re_fuel`, `Re_ox`,
  empirical spray-angle correlation — all restored.
- Sensitivity sweep (new Section 9): vane count [6, 8, 12, 16, 24] vs. total
  pressure drop, plotted against the budget line.
- Console diagnostics restored: scale-effect margin flag (Section 7),
  pressure-budget-exceeded flag (Section 8).
- Pressure-drop budget comparison (`dP_budget_fraction = 0.20`, i.e. 20% of
  Pc) restored.
- Missing "pressure drop breakdown" bar chart restored.
- Summary/limitations log restored (Section 11).
- **Bug fixed**: removed the stray `[cite: 3]` text from the `TMR` and
  `theta_cone_deg` lines, which would otherwise have thrown a MATLAB runtime
  error.

Note: no Mach-number/choking check was reintroduced, since the fuel is
liquid, not gas — that check genuinely doesn't apply to this architecture and
its removal in v1 was correct.

---

## 5. Discussion — Reference Dimensions vs. Empirical Derivation

**Question**: should the injector's exit-gap dimensions (`Dt_mm`, `tag_mm`,
etc.) come from the METU thesis baseline, or be independently derived from
empirical correlations across multiple papers?

**Conclusion reached**: use the METU Type-1 baseline geometry, but verify it
rather than blindly trust it.

- The script does need these dimensions — they directly set exit area, which
  sets exit velocity, which is the quantity the entire spiral manifold is
  built around matching.
- Re-deriving the pintle tip from scratch using scattered empirical
  correlations would introduce new variables (atomization efficiency,
  droplet sizing) unrelated to the actual research question, and would mean
  losing the ability to attribute any measured difference in flow uniformity
  specifically to the manifold design.
- However, the METU baseline geometry was validated at a **different design
  point** (thesis Table 2.3: O/F = 4, 750 N, Pc = 64.15 bar, LOX/GCH4) than
  the one now in use (O/F = 3.2, Pc = 20 bar, LOX/LCH4). So this isn't
  strictly "reusing a validated design" — it's reusing validated *geometry*
  under a *new* flow condition. This is reasonable, but not automatically
  safe, which is exactly why Sections 4–5 (velocities, TMR, Weber number,
  Reynolds numbers) exist: to check the borrowed geometry still produces sane
  numbers under the actual design point, rather than assuming it does.

---

## 6. Discussion — Is a Comparative Study the Right Approach for a Novel Contribution?

**Question**: since the spiral+vane manifold is meant to be a novel
contribution, is comparing it against a baseline (rather than presenting it
standalone) really the best research structure?

**Conclusion reached**: yes — comparative structure is not in tension with
novelty, it's what makes novelty demonstrable.

- Presenting the spiral+vane manifold in isolation, with no baseline, only
  supports a weak, unfalsifiable claim ("this looks reasonably uniform").
  With a controlled baseline (single side-inlet manifold, same pintle tip,
  same flow conditions), the claim becomes specific and defensible: "the
  spiral+vane manifold improves circumferential uniformity by X% relative to
  standard single-inlet feed at the same throttle condition."
- The project's own notes already proposed a **three-way comparison**
  (baseline single-inlet, dual-opposed-inlet, spiral+vane) — worth pursuing
  if time/budget allow, since it gives a richer result than a single
  pass/fail against one baseline.
- A secondary **sensitivity study on the spiral's own parameters** (the 5%
  area floor, bleed-off profile shape, vane count) can deepen the novel half
  of the story once the baseline comparison is established — these two
  approaches complement rather than compete with each other.

---

## 7. Three Issues Identified from External Review (Image-Based Feedback)

An external review of the "v2" script raised three points, evaluated as
follows:

1. **Weber number using `sigma_LOX` instead of a fuel-side surface
   tension** — a real issue, but deeper than a simple typo. The formula
   (`We = rho_CH4 * Ltod * (V_fuel - V_ox)^2 / sigma_LOX`) is the thesis's
   own Eq. 11, written for LOX/**GCH4** (gas fuel): physically an
   *aerodynamic* Weber number, where a low-density, fast gas shears a liquid
   (LOX) sheet, making `sigma_LOX` the physically correct choice **in that
   original context**. Since the fuel here is now liquid (LCH4), this is
   genuinely liquid-liquid impingement, not aerodynamic shear, and the
   thesis formula doesn't strictly apply anymore. Swapping in a new
   `sigma_CH4` term keeps density and surface tension consistently on the
   fuel side, which is the more defensible minimal fix — but the result
   should still be treated as a qualitative "is it >> 1?" check, not a
   validated liquid-liquid breakup model.
2. **Boundary layer formula (`delta_BL = 5*Dh/sqrt(Re)`) is the laminar
   flat-plate correlation, but `Re_local` is actually turbulent
   (~2×10⁵)** — correct. The real turbulent boundary layer would be thinner,
   so this formula *overestimates* `delta_BL`, which *underestimates* the
   margin — conservative in the safe direction for a go/no-go filter, not a
   correctness bug. The gap was that the limitations log didn't say so.
3. **Spiral radius interpolation (`R_spiral_start_mm = 25`,
   `R_spiral_end_mm = 15`, linear) is undocumented** — correct, and arguably
   the most important of the three: these numbers were never derived from
   anything (not mass flow, not channel size) and only feed the path-length
   calculation for the friction pressure-drop estimate. An unexplained
   "shrinks inward by exactly 10 mm" is exactly the kind of unjustified input
   a thesis reviewer would flag.

**Fixes applied to the script:**

- Added `sigma_CH4` (~0.013 N/m, literature range ~0.012–0.015 N/m) to
  Section 3 and switched the Weber number formula to use it, with an inline
  comment explaining the physical caveat.
- Added a comment in Section 7 explaining the boundary-layer formula is
  conservative (overestimates `delta_BL`) at the script's actual turbulent
  Reynolds number.
- Added a comment in Section 6 flagging `R_spiral_start_mm`/
  `R_spiral_end_mm` as unjustified placeholders pending the real injector
  body OD and packaging constraints.
- All three caveats were also added to the printed summary/limitations log
  (Section 11), so they surface at runtime, not just in code comments.

---

## 8. Assumptions Section Restored

The original script's numbered assumptions block (Section 0) — which had been
dropped during the v1 rewrite — was reinstated at the top of the script,
updated to reflect the script's current state (A1–A13): liquid-liquid
LOX/LCH4 propellants, single hardcoded CEA design point, borrowed-but-verified
baseline geometry, the linear bleed-off model with 5% area floor, the
conservative boundary-layer check, the qualitative Weber number caveat, and
the unjustified spiral envelope radii — each cross-referenced to the relevant
script section.

---

## Current Script State

**File**: `pintle_spiral_manifold_feasibility_v2.m`

Structure: Section 0 (assumptions) → Section 1 (baseline geometry) →
Section 2 (NASA CEA design point) → Section 3 (propellant properties) →
Section 4 (exit velocities) → Section 5 (non-dimensional/spray numbers) →
Section 6 (spiral manifold sizing, 5% area floor) → Section 7 (boundary-layer
scale-effect check) → Section 8 (pressure-drop estimate + budget check) →
Section 9 (vane-count sensitivity sweep) → Section 10 (plots) → Section 11
(summary/limitations log).

**Known open items** (per the assumptions block and limitations log):
- Vane loss coefficients are placeholders, not measured or CFD-derived
  values.
- Weber number is a qualitative indicator only, given the liquid-gas →
  liquid-liquid formula mismatch.
- `R_spiral_start_mm`/`R_spiral_end_mm` need to be set from the actual
  injector body envelope, not left as placeholders.
- None of this replaces CFD (SolidWorks Flow Simulation, per the project
  checklist) or cold-flow testing.
