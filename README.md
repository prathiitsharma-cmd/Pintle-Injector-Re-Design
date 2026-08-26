# Pintle Injector — Spiral-Vane Manifold for a Throttling LOX/LCH4 Engine

🚧 **Status: ongoing** — actively being developed, not a finished/archived project. Last major milestone: BSERC summer internship report, August 2026.

A design and analysis project for a throttleable pintle injector (the coaxial, variable-area injector used in engines like the Apollo LM descent stage and SpaceX's Merlin), sized for a LOX/LCH4 propellant pair. Work spans analytical feasibility studies, a spiral-vane manifold design, SolidWorks CAD, and a formal writeup.

**Authors:** Prathit Sharma (B.Tech. Mechanical Engineering, Indian Institute of Petroleum and Energy), Sreyesha Akella (B.Tech. Aerospace Engineering, SRM Institute of Technology)

## Repo structure

```
docs/            Written deliverables: proposal, BSERC report (LaTeX source + PDF),
                  SolidWorks design guide, and reference images used while designing parts
analysis/        MATLAB feasibility scripts + CEA run data, and working notes/conversation logs
cad/
  native/        SolidWorks source files (.SLDPRT/.SLDASM) — not yet checked in, see note below
  exports/       Neutral .step exports of the current CAD, importable into any CAD package
references/      Citations for the papers/textbooks that informed this design (see note below)
```

## Progress / roadmap

- [x] Proposal
- [x] Analytical feasibility study (spiral-vane manifold)
- [x] BSERC summer internship report (Aug 2026)
- [ ] Detailed CAD (native SolidWorks files not yet in this repo)
- [ ] Prototype / manufacturing
- [ ] Test data

## Building the report

See [`docs/report/README.md`](docs/report/README.md) for how to build `main.tex`, or just open `docs/report/main_preview.pdf` for a pre-built copy.

## About the `references/` folder

Several PDFs that informed this design — journal papers, a thesis, and the *Rocket Propulsion Elements* textbook — are **not** committed here since they're someone else's copyrighted work. [`references/bibliography.md`](references/bibliography.md) lists full citations instead; the actual files are kept locally and are git-ignored.

## License

Code (the MATLAB scripts under `analysis/matlab/`) is released under the [MIT License](LICENSE) — see that file.

Everything else in this repository — the report, design guide, proposal, images, and CAD files — is © Prathit Sharma and remains all rights reserved unless stated otherwise. Feel free to read/cite it, but don't redistribute or reuse it without asking first.
