# Movable Pintle Injector Project — Complete Notes

A single consolidated reference covering everything discussed: how the injector works, parts and dimensions, reference drawings, the SolidWorks workflow, the spiral+vane manifold concept, and the full project checklist.

---

## 1. How a Pintle Injector Works (Basics)

An **injector**'s job is to mix a fuel and an oxidizer into a fine, well-mixed spray right before the combustion chamber. Bad mixing means incomplete combustion, wasted propellant, uneven heating, and possible instability. The **pintle injector** is one specific injector geometry — famous from the Apollo Lunar Module descent engine and SpaceX's Merlin engines.

### Flow path, inlet to ejection

1. **The two inlets.** Propellant arrives from feed lines at two ports on the injector body. In the common **oxidizer-centered** arrangement, oxidizer goes to a central passage, fuel goes to an outer passage wrapping around it.
2. **Oxidizer's path — down the middle.** Oxidizer flows down the inside of the hollow **pintle** (the central rod that gives the injector its name).
3. **The 90° turn at the pintle tip.** At the bottom, the pintle tip forces the flow to turn from **axial** (straight down) to **radial** (spreading outward in all directions), exiting as a thin, cone-like sheet all the way around the circumference.
4. **Fuel's path — down the outside.** Fuel flows down an **annular gap** (ring-shaped gap) between the pintle rod and a fixed **sleeve** surrounding it, exiting as a thin axial sheet at the same location the oxidizer is spreading outward.
5. **Impingement.** The radial oxidizer sheet and axial fuel sheet collide at the **impingement point** — this collision shatters both sheets into droplets, a process called **atomization**.
6. **Spray cone formation.** The mixed, atomized propellant spreads into a **spray cone** with a specific **spray angle**. This is fully **axisymmetric** — the same pattern all the way around, unlike injectors built from discrete jets.
7. **Combustion.** The atomized spray enters the combustion chamber, is ignited, and burns to produce thrust.

### Static vs. movable pintle

**Static (fixed):** The pintle never moves relative to the sleeve. Flow area is constant, so thrust can only be changed by varying inlet pressure — which has real limits (too little pressure drop and atomization quality collapses; too much risks structural/thermal limits). Fixed pintles can only throttle across a narrow range.

**Movable (throttling):** The pintle slides axially, changing the **annular gap (tag)** and **opening distance (Laod)** — physically widening or narrowing the exit slot. This lets you throttle primarily via geometry rather than relying on pressure alone, which is what gives pintle injectors their famous **deep throttling** capability (e.g., the Apollo LM throttled down to ~10% thrust for controlled lunar landing). The mechanical cost: you need an actuator, guide bushings (at least two, to prevent rod wobble), dynamic seals where the rod passes through the body, and — critically — a manifold that stays symmetric at every throttle position, not just one.

---

## 2. Glossary

| Term | Meaning |
|---|---|
| Injector | Component that mixes fuel and oxidizer into a spray before combustion |
| Pintle | The central rod/shaft — defines this injector type |
| Pintle tip | Shaped end of the pintle where oxidizer turns from axial to radial flow |
| Sleeve | Fixed outer ring/tube surrounding the pintle, forming the fuel-side boundary |
| Annular / annulus | Ring-shaped; the gap between two concentric surfaces |
| Axial flow | Flow moving parallel to the centerline |
| Radial flow | Flow moving outward from the centerline in all directions |
| Annular gap (tag) | Width of the ring-shaped fuel-flow gap between pintle and sleeve |
| Opening distance (Laod) | How far the pintle tip is retracted/exposed — controls flow area when movable |
| Impingement point | Where oxidizer and fuel sheets collide |
| Atomization | Breaking a liquid sheet/jet into fine droplets |
| Spray cone / spray angle | The cone-shaped spray pattern after impingement, and how wide it opens |
| Oxidizer-centered / fuel-centered | Which propellant flows through the central passage vs. outer annulus |
| Manifold | Internal cavity that distributes propellant from the inlet around the full circumference before it reaches the exit gap |
| Throttling | Varying thrust output, typically via flow area and/or pressure |
| Deep throttling | Throttling across a very wide range (e.g., down to 10–20% of max thrust) without losing stability |
| Combustion stability | Whether combustion proceeds smoothly or develops damaging pressure oscillations |
| Discharge coefficient (Cd) | Factor (≤1) describing how efficiently a real orifice passes flow vs. an ideal orifice |
| O/F ratio | Oxidizer-to-fuel mass flow ratio |
| Volute | A spiral-shaped casing/cavity, classically used in turbines and pumps to distribute or collect flow uniformly around a circumference |

---

## 3. Parts List

| Part | Function |
|---|---|
| Pintle pin/tip (rod) | Central rod with conical/flat tip; primary propellant flows through/around it |
| Pintle sleeve / tip ring | Fixed ring forming the annular gap with the pintle tip |
| Outer body / manifold | Houses the pintle, feeds propellant to central + annular passages |
| Fuel annulus ring / faceplate | Forms the axial slot for the second propellant sheet |
| Support struts / guide bushings | Center the pintle inside the body — use **two** axial support points, not one |
| Retaining nut / backplate | Seals the assembly |
| Linear actuator / lead screw | Drives axial pintle travel for throttling |
| Actuator coupling | Connects actuator to rod without transmitting radial load |
| Dynamic seals (O-rings) | Seal the moving rod against the fixed body |

---

## 4. Design Decisions — Before vs. During

### Decide before any CAD work
1. Propellant pair — sets material compatibility, seals, cooling needs
2. Target thrust & chamber pressure — drives mass flow rate and all downstream sizing (use NASA CEA)
3. Oxidizer-centered vs. fuel-centered pintle
4. Throttling ratio needed (e.g., 3:1, 10:1) — sets actuator travel, seal design, bushing spacing
5. Manufacturing method (CNC vs. 3D print vs. student shop) — caps minimum wall thickness, slot width, cooling channel feasibility

### Can be tuned iteratively
- Annular gap (tag) and slot count/pattern
- Spray half-angle and pintle angle (α)
- Actuator type
- Seal type and groove dimensions
- Surface finish / cooling detail

---

## 5. Key Design Parameters & Reference Dimensions

| Symbol | Meaning |
|---|---|
| Dt | Pintle tip diameter |
| Dp | Pintle rod diameter |
| tag | Annular gap thickness (throttling range) |
| tpg | Pintle gap thickness |
| tt | Tip thickness |
| α | Pintle angle |
| θ | Shadow angle |
| Laod / Ltod | Actual / tracing opening distance (throttle stroke) |

**Sample baseline values** (METU thesis, Table 3.1, Type-1 configuration):
- Pintle angle: 20°
- Annular gap: 0.5 mm
- Pintle tip diameter: 8 mm
- Pintle gap thickness: 1.5 mm
- Pintle rod diameter: 3 mm
- Opening distance at full throttle: ~0.5 mm

---

## 6. Reference Sources

### Thesis (full design methodology + dimensioned parameter table)
- **Berksu Erkal, "Design of a Pintle Injector," MS Thesis, METU, 2019** — https://etd.lib.metu.edu.tr/upload/12624543/index.pdf
  - Figure 2.1: labeled base geometry
  - Table 3.1: 6 dimensioned injector variants
  - Figures 2.4–2.6: three internal cavity geometries for movable pintles (includes the side-fed-inlet torsional flow issue and the fix)

### Design-procedure papers
- Son, M. et al., *"Design Procedure of a Movable Pintle Injector for Liquid Rocket Engines,"* JPP, 2016 — https://arc.aiaa.org/doi/10.2514/1.B36301
- *"A Numerical Approach to Optimize the Design of a Pintle Injector for LOX/GCH4"* (MDPI, open access) — https://www.mdpi.com/2226-4310/10/7/582

### Foundational & throttling-specific patents (2D drawings)
- **US3,699,772** — Elverum/TRW, 1972 — original pintle injector patent
  - PDF: https://patentimages.storage.googleapis.com/22/30/f5/a516f4bc19b82a/US3699772.pdf
  - Drawing 1: https://patentimages.storage.googleapis.com/48/30/1e/8182a2af6ed59a/US3699772-drawings-page-2.png
  - Drawing 2: https://patentimages.storage.googleapis.com/cd/9c/6f/4adf566d8c54d3/US3699772-drawings-page-3.png
- **US20090007543A1 / US7,503,511** — SpaceX, "Pintle injector tip with active cooling"
  - https://patentimages.storage.googleapis.com/3b/db/bd/93a6dfb67538c0/US20090007543A1-20090108-D00000.png
  - https://patentimages.storage.googleapis.com/ea/ea/3e/83f2c41df38be2/US20090007543A1-20090108-D00001.png
  - Full text: https://patents.google.com/patent/US20090007543A1/en
- **US4,206,594** — Elverum/TRW — refined slot/vane geometry — https://patents.google.com/patent/US4206594A/en
- **US11,204,001** — Wooldridge — face-shutoff movable sleeve mechanism + integrated igniter — https://patents.google.com/patent/US11204001B2/en
- **US6,591,603** — TRW — pintle injector with expansion-deflection nozzle — https://patents.google.com/patent/US6591603B2/en

### Open CAD models
- https://grabcad.com/library/pintle-injector-1
- https://grabcad.com/library/pintel_injector-1

### Manifold flow-uniformity precedent (from the spiral + dual-inlet brainstorm)
- **US9,404,441 — "Low velocity injector manifold for hypergolic rocket engine"** — multi-prong diffuser passage splitting one inlet into several exits at discrete vectors for uniform distribution — https://patents.google.com/patent/US9404441B2/en
- **Saturn V F-1 turbine exhaust manifold** — a torus of decreasing cross-sectional area from inlet to exit, with splitter plates at the inlet and flow vanes at the exit — the closest flight-proven precedent to the spiral+vane idea — https://www.enginehistory.org/Rockets/RPE08.11/RPE08.12.shtml
- **US7,077,102 — "Dual inlet port for internal combustion engine"** — two tangential ducts at 180° opposition, swirling in opposite directions, so neither's momentum distorts the other — direct precedent for the dual-opposed-inlet idea
- **US7,806,171 — "Parallel flow evaporator with spiral inlet manifold"** — spiral inlet manifold progressively diminishing in cross-section along the flow direction, to fix uneven distribution to parallel channels — cross-domain (refrigeration) precedent for the spiral concept
- **US4,500,282 — "Burner guide vane device"** — diametrically opposed symmetric gas inlet ports producing a low-non-uniformity annular flow, using matched (not cancelling) swirl direction

> Note: Patent drawings don't carry dimensions — use them as geometric/topological references, and pull actual numbers from the thesis table or your own flow calculations.

### Recent research papers (manifold uniformity / pintle injector, general)
- Zhao, F. et al., **"Review of Atomization and Mixing Characteristics of Pintle Injectors,"** Acta Astronautica, Vol. 200, 2022 — https://www.sciencedirect.com/science/article/abs/pii/S0094576522004556 (start here — consolidated review with open challenges)
- Lee, I. et al., **"Effect of the Flow Passage Area Ratio on a Double Slit-Type Pintle Injector,"** IJASS, 25, 540–554 (2024) — https://doi.org/10.1007/s42405-023-00683-4
- **"Experimental Characterization and CFD Validation of Liquid–Liquid Pintle Injector Spray Patterns Using Water as Simulant,"** Aerospace (MDPI), Jan 2026 — https://doi.org/10.3390/aerospace13020133
- **"A feasibility study of using pintle injector as sole-throttling device for shallow throttling condition,"** 2019 — https://www.sciencedirect.com/science/article/abs/pii/S0094576519313827
- **"Numerical Approach to the Design and Optimisation of a Bi-Propellant Pintle"** (MSc thesis, DiVA, 2023, open access) — https://www.diva-portal.org/smash/get/diva2:1732226/FULLTEXT01.pdf
- *"Effects of Liquid Film Instability on Spray Features of Liquid–Liquid Pintle Injectors,"* AIAA Journal — https://arc.aiaa.org/doi/10.2514/1.J064017
- *"Effect of Rectangular Orifice Structure on Spray Oscillation of Liquid–Liquid Pintle Injector,"* AIAA Journal, 2025 — https://arc.aiaa.org/doi/abs/10.2514/1.J065859

Most journal papers sit behind paywalls unless your university has access — the MDPI paper, DiVA thesis, and METU thesis are fully open access.

---

## 7. Manifold Feed Geometry — The Core Problem

Side-fed inlets (propellant entering perpendicular to the intended flow direction) impart sideways momentum that causes torsional/swirling flow inside the manifold cavity — like filling a bucket with a hose aimed from the side instead of pouring straight down. This swirl doesn't cancel out on its own.

For a **fixed** pintle this can sometimes be tuned around once. For a **movable** pintle, the annular gap geometry changes continuously as it throttles, so any swirl in the approach flow is exposed differently at every throttle position — it can't be fixed with a single tune. The result is an uneven spray cone, which hurts combustion efficiency and can create hot spots.

**Design implication:** treat the internal manifold/cavity shape as its own design problem, ideally with a symmetric or distributed feed, rather than a single side-inlet pipe bolted on as an afterthought.

### Why fixing this matters
- **Spray symmetry** — the actual spray finally matches the calculated axisymmetric geometry at every point around the circumference
- **Combustion efficiency** stays consistent across the whole throttle range, not just at one tuned setting
- **Combustion stability** — central injection is meant to sit at a pressure-field node and damp instability; a swirl-distorted feed undermines that benefit
- **Even thermal loading** on the chamber wall — no local hot spots from a lopsided spray
- **Predictable throttle response** — a clean, symmetric feed makes thrust vs. Laod one smooth, repeatable relationship instead of something to characterize point-by-point

### Is this a good research topic?
Yes. Current review literature explicitly flags this as unresolved — thrust regulation requires flow control devices and adjustable pintle injectors to dynamically match flow rates with injection pressure drops while ensuring combustion stability across wide thrust ranges, and this remains challenging, with the field calling for breakthroughs in flow regulation during deep throttling. It's also cheaply testable (cold-flow water/air, like most cited papers), directly comparable (baseline vs. redesigned manifold), and has room for a computational angle (CFD in SolidWorks Flow Simulation) alongside the experimental side.

**Suggested thesis statement:** *Does a symmetric/distributed manifold feed measurably improve spray uniformity across the throttle range of a movable pintle injector, compared to a conventional single side-inlet feed?*

---

## 8. Manifold Concept 1 — Spiral (Volute) Cavity + Turning Vanes

**The idea:** Borrow the Francis turbine spiral casing principle. In a turbine, the spiral casing's cross-sectional area continuously shrinks as flow bleeds off through each stay vane opening, keeping velocity (and pressure) constant for whatever flow remains — which is exactly why the casing delivers uniform flow to the runner from every angle. Applying this to the pintle injector: shape the fuel (and possibly oxidizer) manifold cavity as a spiral that tapers in cross-section as it wraps around the pintle, continuously feeding the annular gap along the way. Add small radial turning vanes (the stay-vane equivalent) right where the spiral meets the exit gap, to kill any residual tangential velocity before the flow turns axial.

**Where the analogy needs adjustment:**
- A turbine volute *collects* momentum to drive a runner; your manifold only *distributes* flow — closer to a centrifugal pump volute run in reverse (as a distributor rather than a collector) than to a turbine casing
- Turbine casings operate at meter-scale and high Reynolds number, where the area-taper argument (essentially inviscid) holds cleanly. Your manifold is millimeter-scale, where viscous/boundary-layer effects are proportionally larger — need to check channel width against boundary layer thickness
- The smoothly tapering geometry will most likely require 3D printing, not conventional machining

**Validating precedent found:**
- The **Saturn V F-1 turbine exhaust manifold** used a torus of decreasing cross-sectional area from inlet to exit, with splitter plates at the inlet and flow vanes at the exit contributing to uniform distribution — essentially this exact idea, flight-proven, just applied to turbine exhaust gas rather than propellant
- A hypergolic rocket engine patent (US9,404,441) achieves uniform fuel distribution from one inlet via a multi-prong diffuser with several outlets at discrete vectors — same goal, different (discrete rather than continuous) solution
- A refrigeration industry patent (US7,806,171) independently arrived at a spiral inlet manifold progressively diminishing in cross-section along the flow direction to fix uneven distribution — proof the principle transfers across domains

**Gap found:** No evidence this has been applied specifically inside a pintle injector's propellant manifold — genuine novelty for a project-level research contribution.

**Design steps specific to this idea:**
1. Derive area-vs-angle profile A(θ) from mass conservation (area ∝ remaining flow at that angular position)
2. Set starting/ending radius and design the "tongue" transition where the spiral's start and end nearly meet
3. Place turning vanes at the inner boundary — count, angle, and thickness are tunable, trading swirl removal against pressure drop
4. Verify with CFD (SolidWorks Flow Simulation) and cold-flow testing against a baseline single-inlet manifold

---

## 9. Manifold Concept 2 — Dual Opposed Tangential Inlets

**The idea:** Instead of one side-feed inlet, use two, positioned diametrically opposite each other, each injecting tangentially but in *opposite* rotational senses. Since momentum is a vector, the two streams' tangential momentum cancels where they physically meet (roughly 90° from each inlet), forcing the flow to redirect into the radial/axial direction instead of continuing to swirl.

**Where it's not perfect:** Cancellation is exact only at the two collision points. Between an inlet and its nearest collision point, flow still carries real tangential velocity. So instead of one dominant asymmetry, you get a more repeating pattern (roughly four zones instead of one). More inlet pairs (four or six points instead of two) would shrink the "still swirling" arcs further, at the cost of more plumbing and machining complexity.

**Practical catch:** For clean cancellation, the two streams must be genuinely equal in flow rate, velocity, and timing. The reliable way to guarantee this is to split a single supply line into two equal branches right before the manifold (a symmetric Y/T-split), rather than trusting two independent feed lines to match by coincidence.

**Validating precedent found:**
- **US7,077,102, "Dual inlet port for internal combustion engine"** — two intake ducts at 180° opposition, one swirling clockwise and the other counter-clockwise, specifically so the momentum of one flow doesn't distort the momentum of the other — a near-exact match for this idea, already patented (for a different application)
- **US4,500,282, "Burner guide vane device"** — diametrically opposed symmetric inlet ports achieving a low-non-uniformity annular flow — the "sibling" version using matched rather than cancelling swirl direction, worth keeping in mind as an alternative if zero swirl turns out not to be the ideal target

**Relationship to Concept 1:** Not competing ideas — they solve different pieces of the same problem. Dual-opposed-inlet kills *net* swirl cheaply via plumbing symmetry alone (no tapering geometry needed); spiral+vanes solves the *distribution* problem (uniform arrival around the full circumference). A strong project could compare three configurations: baseline single inlet, dual-opposed inlet, and spiral+vanes.

**Decision:** Proceeding with the **spiral + vane** concept for this project.

---

## 10. SolidWorks Modeling Workflow (Parametric / Advanced Features)

### Step 1 — Equation-driven parameter sheet
- Tools → Equations → Global Variables
- Define: Dt, tag, Dp, alpha, Laod_max, tt
- Reference these variables in every downstream sketch dimension instead of raw numbers

### Step 2 — Model the pintle rod
- Revolved Boss/Base around the centerline, diameter linked to Dp
- Sketch the conical tip using alpha, tapering to Dt
- Shell the rod if hollow (oxidizer flow path)
- Circular Pattern / Sketch Driven Pattern for staggered tip slots

### Step 3 — Model the sleeve/body
- Revolve outer body and inner sleeve profile
- Link sleeve inner diameter by equation: D_sleeve_inner = Dt + 2×tag
- Revolved cut for the manifold cavity
- Wrap feature for slot patterns on the curved sleeve exit

### Step 4 — Link dimensions across parts
- Equations → Manage → Link to external file, shared by both parts, so Dt and tag update both simultaneously

### Step 5 — Build the throttle mechanism as an assembly
- Concentric mate (rod axis to sleeve axis)
- Distance mate for axial position, driven by the Laod global variable
- Advanced Mates → Distance (min/max limits) to drag the pintle within its real travel range and check interference live
- Add actuator, coupling, and two guide bushings as separate coaxially-mated parts

### Step 6 — Represent throttle states with Configurations
- Configurations: Closed, Mid-throttle, Full-open, each with a different Laod value
- Or a Design Table (Excel-embedded) for a full table of throttle positions

### Step 7 — Verify with analysis tools
- Interference Detection across the full throttle-travel range
- Motion Study (SolidWorks Premium) to animate the actuator driving the rod
- Flow Simulation for an internal flow check — sanity-check for the swirl/torsional-flow issue
- Sensors (FeatureManager → Sensors → Add Sensor → Dimension) to flag if tag drops below a minimum safe value

### Step 8 — Drawings
- Insert → Drawing, pull in all three configurations as separate views on one sheet — a "family of positions" drawing showing closed/mid/open pintle states side by side

---

## 11. Master Project Checklist — Spiral + Vane Manifold

### Phase 0 — Foundational decisions
- [ ] Define project goal: cold-flow demonstrator only, or working toward hot-fire?
- [ ] Choose propellant pair (or cold-flow simulant)
- [ ] Decide oxidizer-centered vs. fuel-centered pintle
- [ ] Set target thrust / equivalent flow target
- [ ] Set target chamber/supply pressure
- [ ] Decide required throttling ratio
- [ ] Decide manufacturing method/access
- [ ] Decide test method
- [ ] Write down the exact research question and definition of success
- [ ] Confirm budget/timeline covers building two manifold versions (baseline + spiral+vane)

### Phase 1 — Performance & flow calculations
- [ ] Run NASA CEA if hot-fire is the goal
- [ ] Calculate total propellant mass flow rate
- [ ] Split into oxidizer and fuel mass flow rates via O/F ratio
- [ ] Calculate required flow areas from mass flow, density, target injection velocity
- [ ] Assume/estimate discharge coefficient (Cd)
- [ ] Set injector pressure-drop budget
- [ ] Estimate spray velocity, Weber number, spray angle

### Phase 2 — Core pintle/sleeve geometry
- [ ] Pintle tip diameter (Dt)
- [ ] Pintle rod diameter (Dp)
- [ ] Pintle angle (α)
- [ ] Annular gap thickness (tag)
- [ ] Pintle gap thickness (tpg)
- [ ] Tip thickness (tt)
- [ ] Shadow angle (θ), if slotted tip
- [ ] Slot count/pattern, if slotted tip
- [ ] Total momentum ratio (TMR) check

### Phase 3 — Throttling range & mechanism
- [ ] Opening distance range (Laod_min to Laod_max)
- [ ] Actuator type selection
- [ ] Actuator travel, resolution, force requirements
- [ ] Actuator-to-rod coupling design
- [ ] Guide bushing count and locations (minimum two)
- [ ] Bushing material and fit
- [ ] Dynamic seal type and groove dimensions
- [ ] Seal material compatibility
- [ ] Confirm actuator doesn't block the central oxidizer feed path

### Phase 4 — Manifold redesign: spiral cavity
- [ ] Decide which propellant path needs the spiral fix
- [ ] Choose target uniformity metric
- [ ] Derive area-vs-angle profile A(θ)
- [ ] Set starting/ending radius
- [ ] Design the tongue transition
- [ ] Decide tangential inlet duct geometry/angle
- [ ] Check channel width vs. boundary layer thickness
- [ ] Decide manufacturing approach for the spiral cavity

### Phase 5 — Manifold redesign: turning vanes
- [ ] Vane count
- [ ] Vane radial position
- [ ] Vane angle/orientation
- [ ] Vane thickness and length
- [ ] Check vane-induced pressure drop
- [ ] Decide vane manufacturing approach

### Phase 6 — Baseline design (control case)
- [ ] Model a baseline single-side-inlet manifold with no spiral/vanes
- [ ] Keep all other dimensions identical to the spiral+vane version

### Phase 7 — SolidWorks modeling
- [ ] Set up global variables/equation sheet
- [ ] Model pintle rod
- [ ] Model sleeve/body with equation-linked inner diameter
- [ ] Model spiral manifold cavity
- [ ] Model turning vanes
- [ ] Model baseline manifold separately
- [ ] Model actuator, coupling, bushings, seals
- [ ] Assemble with concentric + limited-distance mates
- [ ] Create configurations/design table for throttle × manifold type

### Phase 8 — Verification
- [ ] Interference detection across full throttle travel
- [ ] Flow Simulation comparing baseline vs. spiral+vane
- [ ] Quantify circumferential uniformity numerically
- [ ] Structural sanity check if hot-fire is a goal
- [ ] Dimension sensors for minimum safe tag

### Phase 9 — Manufacturing
- [ ] Finalize manufacturing method per part
- [ ] Check minimum feature size vs. manufacturing capability
- [ ] Order/print/machine parts
- [ ] Inspect parts against CAD, especially tag
- [ ] Assemble and dry-fit; confirm smooth actuator travel

### Phase 10 — Test setup
- [ ] Build cold-flow rig
- [ ] Set up supply lines (equal-length symmetric branching if needed)
- [ ] Set up visualization (camera/shadowgraphy or dye injection)
- [ ] Set up pressure taps around manifold circumference if quantifying uniformity directly
- [ ] Calibrate flow meters and actuator position readout

### Phase 11 — Testing
- [ ] Run baseline manifold at multiple throttle positions
- [ ] Run spiral+vane manifold at same positions/conditions
- [ ] Repeat runs for repeatability
- [ ] Record flow rate vs. throttle position for both configurations

### Phase 12 — Analysis
- [ ] Quantify spray/flow uniformity for both configurations
- [ ] Compare against CFD predictions
- [ ] Compare throttle-curve repeatability
- [ ] Identify failure modes or unexpected behavior

### Phase 13 — Documentation
- [ ] Write up methodology, citing design equations and sources
- [ ] Present CAD drawings, including family-of-positions drawing
- [ ] Present results (uniformity comparison, throttle curves, CFD-vs-experiment)
- [ ] Discuss limitations and future work

---

## 12. Master Parameter List

### Mission & requirements
| Parameter | Notes |
|---|---|
| Target thrust | Or equivalent flow target for cold-flow |
| Chamber / supply pressure | |
| Throttle ratio | e.g. 3:1, 5:1, 10:1 |
| Propellant pair / simulant | |
| O/F ratio | |

### Propellant flow
| Parameter | Notes |
|---|---|
| Total mass flow rate | |
| Oxidizer mass flow rate | |
| Fuel mass flow rate | |
| Propellant density (each) | |
| Propellant viscosity (each) | Matters for the spiral scale-effect check |
| Injection velocity (each stream) | |
| Discharge coefficient (Cd) | |
| Injector pressure drop budget | |

### Pintle/sleeve geometry
| Parameter | Notes |
|---|---|
| Pintle tip diameter (Dt) | |
| Pintle rod diameter (Dp) | |
| Pintle angle (α) | |
| Annular gap thickness (tag) | Also the throttle variable |
| Pintle gap thickness (tpg) | |
| Tip thickness (tt) | |
| Shadow angle (θ) | If slotted tip |
| Slot count/pattern | If slotted tip |

### Throttling mechanism
| Parameter | Notes |
|---|---|
| Opening distance range (Laod min/max) | |
| Actuator type | Stepper/lead screw, micrometer, pneumatic |
| Actuator travel, resolution, force | |
| Guide bushing count & location | Minimum two |
| Bushing material/fit | |
| Seal type & groove dimensions | |
| Seal material compatibility | |

### Spiral manifold
| Parameter | Notes |
|---|---|
| Target uniformity metric | Constant velocity vs. constant pressure |
| Starting radius (θ=0°) | |
| Ending radius (θ=360°) | |
| Area-vs-angle profile A(θ) | Derived from mass conservation |
| Tangential inlet duct geometry/angle | |
| Tongue transition design | |
| Channel width vs. boundary layer thickness | Scale-effect check |

### Turning vanes
| Parameter | Notes |
|---|---|
| Vane count | |
| Vane radial position | |
| Vane angle/orientation | |
| Vane thickness & length | |
| Vane-induced pressure drop | Check against budget |

### Structural / material
| Parameter | Notes |
|---|---|
| Wall thickness (body, sleeve) | |
| Material choice | Compatibility + manufacturing method |
| Pressure rating / safety factor | If hot-fire |
| Thermal considerations | If hot-fire |

### Manufacturing
| Parameter | Notes |
|---|---|
| Manufacturing method per part | CNC / 3D print / shop |
| Minimum feature size achievable | Especially spiral cavity, vanes |
| Tolerances | Especially tag |

### Test & instrumentation
| Parameter | Notes |
|---|---|
| Flow meter range/accuracy | |
| Pressure tap locations | If quantifying manifold uniformity directly |
| Camera/shadowgraphy setup | |
| Actuator position readout | |
| Number of repeat runs | For repeatability |

---

## 13. Fluid Mechanics Refresher — Concepts & Videos

Recommended learning order, since each concept builds on the last:

1. **Fluid properties** (density, viscosity, pressure) — 10-15 min refresher, any basic intro video
2. **Continuity equation (conservation of mass)** — https://www.youtube.com/watch?v=wykn-JTnacE , https://www.youtube.com/watch?v=Mx2M5MuAUFo
3. **Bernoulli's equation** — https://www.youtube.com/watch?v=DW4rItB20h4 (The Efficient Engineer)
4. **Reynolds number, laminar vs. turbulent flow** — https://www.youtube.com/watch?v=MGxHVAfaAuc
5. **Boundary layers** — search "boundary layer explained The Efficient Engineer" or "boundary layer NPTEL"
6. **Conservation of momentum (linear and angular)** — https://www.youtube.com/watch?v=hgcudPr73LU ; for the fluid-specific version, search "free vortex forced vortex fluid mechanics" (this is the language for what the spiral/dual-inlet ideas are trying to cancel)
7. **Orifice flow & discharge coefficient** — search "discharge coefficient orifice flow explained"
8. **Turbomachinery — Francis turbine spiral casing** — https://www.youtube.com/watch?v=SpuoNN8xcoY
9. **Impinging jets & atomization (Weber number)** — no strong beginner explainer found; search "impinging jet atomization high speed camera" for real lab footage instead

**If short on time:** prioritize #3 (Bernoulli), #4 (Reynolds number), and #8 (Francis turbine) — those three cover most of the vocabulary needed to follow the spiral+vane manifold argument.

---

## 14. MATLAB Feasibility Script — Spiral Manifold

File: `pintle_spiral_manifold_feasibility.m`

A preliminary, extensively-commented MATLAB script that checks the spiral+vane manifold concept mathematically before any CAD/CFD work. Structure:

- **Section 0** — All assumptions stated explicitly up front (propellants, architecture, design point, baseline geometry, thin-annulus approximation, placeholder gas properties, linear bleed-off model, constant-velocity target, circular cross-section, boundary-layer approximation, pressure-drop model)
- **Section 1** — Constants and reference data pulled directly from the METU thesis (Table 2.3 LOX/GCH4 design points, Table 3.1 Type-1 baseline geometry)
- **Section 2** — Design point selection (O/F=4, 750 N, Pc=64.15 bar)
- **Section 3** — Propellant properties (LOX from literature; GCH4 as placeholder ideal gas — see Section 15 below for real values to substitute)
- **Section 4** — Exit velocities via thin-annulus approximation, plus a Mach number choking check
- **Section 5** — Non-dimensional numbers from the thesis: K1 (Eq. 1), TMR (Eq. 10), spray half-angle from momentum balance (Eq. 4) and from the empirical correlation (Eqs. 15-16), Weber number (Eq. 11), Reynolds numbers (Eqs. 12-13)
- **Section 6** — Spiral manifold sizing (original concept, not from the thesis): linear bleed-off model, area-vs-angle profile via continuity, conversion to an equivalent circular channel size
- **Section 7** — Scale-effect check: local Reynolds number, boundary layer thickness estimate, margin against channel size (the key "does this actually work at injector scale" test)
- **Section 8** — Pressure drop estimate: friction (laminar/turbulent) + vane minor loss, compared against a pressure budget
- **Section 9** — Plots: area profile, spiral plan-view shape, scale-effect margin, pressure drop breakdown
- **Section 10** — Sensitivity sweep: vane count vs. pressure drop (crude placeholder model, flagged for replacement)
- **Section 11** — Summary/limitations log printed to console

**Known placeholders to replace before trusting the output:** GCH4 injection temperature (currently assumed 300 K — see Section 15), and the vane loss coefficient / vane-count sensitivity model (currently a crude linear placeholder).

---

## 15. NASA CEA — How to Use It

**Portal:** https://cearun.grc.nasa.gov/index.html (free, browser-based; a downloadable version also exists at https://www1.grc.nasa.gov/research-and-engineering/ceaweb for batch runs)

### Steps
1. Select **"Rocket and Assigned Enthalpy & Pressure Problems"**
2. Enter chamber pressure (Pc) — single value or a range/sweep
3. Select fuel: **CH4** (or build via Periodic Table: select C and H → Process → choose CH4)
4. Select oxidizer: **O2**, liquid phase (not gaseous)
5. Enter reactant temperatures for each propellant (this is the number that should replace the 300 K placeholder in the MATLAB script — see literature values below)
6. Enter O/F ratio (oxidizer/fuel by weight) — single value or a series
7. Area ratio / Pi/P ratio — can be left generic for injector-focused work (matters more for nozzle design)
8. Choose **Equilibrium** (standard first-pass choice over "Frozen")
9. Submit — returns chamber temperature, C*, Cf, Isp, and gas composition/properties (molecular weight, γ, etc.)

### Important distinction
CEA's chamber temperature output is the **post-combustion** flame temperature — not the same as the pre-combustion propellant injection temperature. For manifold/injector-side gas density calculations, use the **reactant temperature you input** (Step 5), not the chamber output temperature.

### Terms explained
| Term | Meaning |
|---|---|
| Reactant temperature | Temperature at which propellant enters the chamber (affects input enthalpy) |
| O/F ratio | Oxidizer-to-fuel mass ratio |
| Chamber pressure (Pc) | Stagnation pressure in the combustion chamber |
| Equilibrium vs. Frozen | Whether combustion products keep reacting during expansion (equilibrium, standard) or composition is frozen at chamber conditions |
| C* (characteristic velocity) | Combustion efficiency parameter, independent of nozzle |
| Cf (thrust coefficient) | Nozzle expansion performance parameter |

---

## 16. LOX / LCH4 Literature Property Values

Values to substitute into the MATLAB script's placeholder Section 3, and to use as CEA reactant inputs.

### Liquid Oxygen (LOX)
| Property | Value | Source |
|---|---|---|
| Normal boiling point | 90.19 K (−182.96 °C) at 1 bar | Wikipedia/NIST-sourced |
| Freezing point | 54.36 K (−218.79 °C) | Wikipedia/NIST-sourced |
| Density at boiling point | 1141 kg/m³ | Confirmed — matches the value already used in the MATLAB script |
| Surface tension at boiling point | 13.2 mN/m (0.0132 N/m) | Confirmed — matches the value already used in the MATLAB script |

### Liquid Methane (LCH4)
| Property | Value | Source |
|---|---|---|
| Normal boiling point | ~111.6–112 K (−161.5 °C) | Multiple sources consistent |
| Freezing point | ~90.7 K | Patent literature (cryogenic propellant mixing patents) |
| Density at normal boiling point | ~423 kg/m³ | Liquid propellant performance reference table |

### Typical O/F ratio (LOX/LCH4)
| Source context | O/F value |
|---|---|
| General liquid-fuel performance reference table | 3.0 |
| RL10B-2-class methane/oxygen engine analysis | 3.6 |

**Note for the MATLAB script:** the METU thesis's own Table 2.3 design points span O/F = 1 to 4, with the 750 N / O/F = 4 point used as the script's baseline — within the range these literature sources suggest is realistic for LOX/LCH4 (roughly O/F 3.0–3.6 for near-optimal performance), so the thesis's high-O/F design point is a reasonable one to keep using.

**Caveat:** these are standard reference/NBP (normal boiling point, 1 atm) values. Real engines often use **subcooled/densified** propellants (chilled below NBP to increase density and Isp) — if that becomes relevant to your design later, the density and temperature values above would need to be adjusted accordingly rather than used as-is.
