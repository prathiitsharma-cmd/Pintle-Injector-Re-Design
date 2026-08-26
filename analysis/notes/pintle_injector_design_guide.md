# Movable Pintle Injector — Design & SolidWorks Reference Guide

A consolidated reference for designing a throttleable pintle injector (rocket engine liquid propellant injector) in SolidWorks, covering parts, dimensions, reference drawings, and a parametric modeling workflow.

---

## 1. What a Pintle Injector Is

A pintle injector is a coaxial, variable-area injector used in liquid rocket engines (Apollo LM descent engine, SpaceX Merlin). One propellant flows axially through a central pintle rod and is deflected radially outward through slots/gaps in the tip; the second propellant flows through an outer annular gap. The two streams impinge and atomize into a spray cone. A **movable** pintle slides axially to change the annular gap area, enabling thrust throttling.

---

## 2. Parts List

| Part | Function |
|---|---|
| Pintle pin/tip (rod) | Central rod with conical/flat tip; primary propellant flows through/around it |
| Pintle sleeve / tip ring | Fixed ring forming the annular gap with the pintle tip |
| Outer body / manifold | Houses the pintle, feeds propellant to central + annular passages |
| Fuel annulus ring / faceplate | Forms the axial slot for the second propellant sheet |
| Support struts / guide bushings | Center the pintle inside the body — **use two axial support points**, not one, to prevent bending/wobble during travel |
| Retaining nut / backplate | Seals the assembly |
| Linear actuator / lead screw | Drives axial pintle travel for throttling |
| Actuator coupling | Connects actuator to rod without transmitting radial load |
| Dynamic seals (O-rings) | Seal the moving rod against the fixed body |

---

## 3. Design Decisions — Before vs. During

### Decide before any CAD work
1. **Propellant pair** — sets material compatibility, seals, cooling needs
2. **Target thrust & chamber pressure** — drives mass flow rate and all downstream sizing (use NASA CEA)
3. **Oxidizer-centered vs. fuel-centered** pintle — oxidizer-centered is the common convention
4. **Throttling ratio needed** (e.g., 3:1, 10:1) — sets actuator travel, seal design, bushing spacing
5. **Manufacturing method** (CNC vs. 3D print vs. student shop) — caps minimum wall thickness, slot width, feasibility of internal cooling channels

### Can be tuned iteratively (after the above are fixed)
- Annular gap (`tag`) and slot count/pattern
- Spray half-angle and pintle angle (`α`)
- Actuator type (stepper + lead screw / manual micrometer / pneumatic)
- Seal type and groove dimensions
- Surface finish / cooling detail

---

## 4. Key Design Parameters & Reference Dimensions

| Symbol | Meaning |
|---|---|
| `Dt` | Pintle tip diameter |
| `Dp` | Pintle rod diameter |
| `tag` | Annular gap thickness (throttling range) |
| `tpg` | Pintle gap thickness |
| `tt` | Tip thickness |
| `α` | Pintle angle |
| `θ` | Shadow angle |
| `Laod` / `Ltod` | Actual / tracing opening distance (throttle stroke) |

**Sample baseline values** (from METU thesis, Table 3.1, Type-1 configuration):
- Pintle angle: 20°
- Annular gap: 0.5 mm
- Pintle tip diameter: 8 mm
- Pintle gap thickness: 1.5 mm
- Pintle rod diameter: 3 mm
- Opening distance at full throttle: ~0.5 mm

Use these as a first-pass starting point, then refine using your own thrust/flow-rate calculations.

---

## 5. Reference Sources

### Thesis (full design methodology + dimensioned parameter table)
- **Berksu Erkal, "Design of a Pintle Injector," MS Thesis, METU, 2019**
  https://etd.lib.metu.edu.tr/upload/12624543/index.pdf
  - Figure 2.1: labeled base geometry
  - Table 3.1: 6 dimensioned injector variants
  - Figures 2.4–2.6: three internal cavity geometries for movable pintles (includes the side-fed-inlet torsional flow issue and the fix)

### Design-procedure papers
- Son, M. et al., *"Design Procedure of a Movable Pintle Injector for Liquid Rocket Engines,"* Journal of Propulsion and Power, 2016 — https://arc.aiaa.org/doi/10.2514/1.B36301
- *"A Numerical Approach to Optimize the Design of a Pintle Injector for LOX/GCH4"* (MDPI, open access) — https://www.mdpi.com/2226-4310/10/7/582

### Foundational & throttling-specific patents (2D drawings)
- **US3,699,772** — Elverum/TRW, 1972 — original pintle injector patent
  - Full PDF: https://patentimages.storage.googleapis.com/22/30/f5/a516f4bc19b82a/US3699772.pdf
  - Drawing 1: https://patentimages.storage.googleapis.com/48/30/1e/8182a2af6ed59a/US3699772-drawings-page-2.png
  - Drawing 2: https://patentimages.storage.googleapis.com/cd/9c/6f/4adf566d8c54d3/US3699772-drawings-page-3.png
- **US20090007543A1 / US7,503,511** — SpaceX, "Pintle injector tip with active cooling"
  - https://patentimages.storage.googleapis.com/3b/db/bd/93a6dfb67538c0/US20090007543A1-20090108-D00000.png
  - https://patentimages.storage.googleapis.com/ea/ea/3e/83f2c41df38be2/US20090007543A1-20090108-D00001.png
  - Full text: https://patents.google.com/patent/US20090007543A1/en
- **US4,206,594** — Elverum/TRW — refined slot/vane geometry — https://patents.google.com/patent/US4206594A/en
- **US11,204,001** — Wooldridge — face-shutoff movable sleeve mechanism + integrated igniter — https://patents.google.com/patent/US11204001B2/en
- **US6,591,603** — TRW — pintle injector with expansion-deflection nozzle — https://patents.google.com/patent/US6591603B2/en

### Open CAD models (for geometry sanity-checks)
- https://grabcad.com/library/pintle-injector-1
- https://grabcad.com/library/pintel_injector-1

> Note: Patent drawings don't carry dimensions (not required by US patent law) — use them as geometric/topological references (proportions, part relationships, mechanism layout), and pull actual numbers from the thesis table or your own flow calculations.

---

## 6. Throttling-Specific Design Note (Manifold Feed Geometry)

Side-fed inlets (propellant entering perpendicular to the intended flow direction) impart sideways momentum that causes torsional/swirling flow inside the manifold cavity — similar to filling a bucket with a hose aimed from the side instead of pouring straight down. This swirl doesn't cancel out on its own.

For a **fixed** pintle, this can sometimes be tuned around once. For a **movable** pintle, the annular gap geometry changes continuously as it throttles, so any swirl in the approach flow is exposed differently at every throttle position — it can't be fixed with a single tune. The result is an uneven, lopsided spray cone instead of a uniform one, which hurts combustion efficiency and can create hot spots.

**Design implication:** treat the internal manifold/cavity shape as its own design problem, ideally with a symmetric or distributed feed (e.g., a circular array of small feed holes) rather than a single side-inlet pipe — plan this early, not as an afterthought bolted onto the rod-and-sleeve geometry.

---

## 7. SolidWorks Modeling Workflow (Parametric / Advanced Features)

### Step 1 — Set up an equation-driven parameter sheet
- **Tools → Equations → Global Variables**
- Define driving parameters: `Dt`, `tag`, `Dp`, `alpha`, `Laod_max`, `tt`
- Reference these variables in every downstream sketch dimension instead of typing raw numbers

### Step 2 — Model the pintle rod
- **Revolved Boss/Base** around the centerline, diameter linked to `Dp`
- Sketch the conical tip using `alpha` and tapering to `Dt`
- **Shell** the rod if it needs to be hollow (oxidizer flow path)
- **Circular Pattern** / **Sketch Driven Pattern** for staggered tip slots — count and spacing as variables

### Step 3 — Model the sleeve/body
- Revolve the outer body and inner sleeve profile
- Link the sleeve inner diameter by equation: `D_sleeve_inner = Dt + 2*tag` (not a fixed number) — guarantees the gap stays correct if `Dt` changes later
- Revolved cut for the fuel/oxidizer manifold cavity
- **Wrap** feature for slot patterns cut into the curved sleeve exit (spoke-style flow)

### Step 4 — Link dimensions across parts
- **Equations → Manage → Link to external file**, shared by both parts, so `Dt` and `tag` update the rod and sleeve simultaneously from one edit

### Step 5 — Build the throttle mechanism as an assembly
- Insert rod + sleeve into an assembly
- **Concentric mate** (rod axis to sleeve axis)
- **Distance mate** for axial position, driven by the `Laod` global variable
- Use **Advanced Mates → Distance (with min/max limits)** to drag the pintle within its real travel range and check interference live
- Add actuator, coupling, and two guide bushings as separate coaxially-mated parts

### Step 6 — Represent throttle states with Configurations
- Create configurations: `Closed`, `Mid-throttle`, `Full-open`, each with a different `Laod` value
- Or use a **Design Table** (Excel-embedded) for a full table of throttle positions at once

### Step 7 — Verify with analysis tools
- **Interference Detection** across the full throttle-travel range (cone should never contact the sleeve at minimum gap)
- **Motion Study** (SolidWorks Premium) to animate the actuator driving the rod through its stroke
- **Flow Simulation** for a quick internal flow check — sanity-check for the swirl/torsional-flow issue described in Section 6
- **Sensors** (FeatureManager → Sensors → Add Sensor → Dimension) to flag if `tag` drops below a minimum safe value as other dimensions are adjusted

### Step 8 — Drawings
- **Insert → Drawing**, pull in all three configurations as separate views on one sheet — gives a "family of positions" drawing showing closed/mid/open pintle states side by side for your report

---

## 8. Quick Checklist Summary

- [ ] Propellant pair chosen
- [ ] Target thrust & chamber pressure calculated (NASA CEA)
- [ ] Oxidizer-centered or fuel-centered decided
- [ ] Throttling ratio defined
- [ ] Manufacturing method decided
- [ ] Global variables set up in SolidWorks
- [ ] Rod and sleeve modeled with linked equations
- [ ] Assembly mated with travel-limited distance mate
- [ ] Configurations/design table for throttle states created
- [ ] Interference check run across full travel range
- [ ] Manifold feed geometry checked for symmetric flow
