# Pintle Injector — Spiral-Vane Manifold for a Throttling LOX/LCH4 Engine

![MATLAB](https://img.shields.io/badge/MATLAB-analysis-0076A8?style=flat-square)
![NASA CEA](https://img.shields.io/badge/NASA%20CEA-thermochemistry-0B3D91?style=flat-square&logo=nasa&logoColor=white)
![SolidWorks](https://img.shields.io/badge/SolidWorks-CAD-E2231A?style=flat-square&logo=dassaultsystemes&logoColor=white)
![LaTeX](https://img.shields.io/badge/LaTeX-report-008080?style=flat-square&logo=latex&logoColor=white)
![Status](https://img.shields.io/badge/status-ongoing-f59e0b?style=flat-square)
![Paper](https://img.shields.io/badge/NCCS%202026-paper%20accepted-34d399?style=flat-square)

🚧 **Status: ongoing** — actively being developed, not a finished/archived project. Last major milestone: written technical report, August 2026.

📄 **Conference paper accepted at NCCS 2026** — presenting on 6 December 2026, with updated analysis and initial CFD.

| Design point | Value |
|---|---|
| Propellants | LOX / LCH4 |
| Mixture ratio (O/F) | 3.2 |
| Thrust | 750 N |
| Chamber pressure | 20 bar |
| Key idea | Spiral + vane manifold (after Francis-turbine spiral casings) to cut circumferential swirl while throttling |

A design and analysis project for a throttleable pintle injector (the coaxial, variable-area injector used in engines like the Apollo LM descent stage and SpaceX's Merlin), sized for a LOX/LCH4 propellant pair. Work spans analytical feasibility studies, a spiral-vane manifold design, SolidWorks CAD, and a formal writeup.

**Author:** Prathit Sharma (B.Tech. Mechanical Engineering, Indian Institute of Petroleum and Energy)

## Repo structure

```
docs/            Written deliverables: proposal, technical report (LaTeX source + PDF),
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
- [x] Technical report (Aug 2026)
- [x] Conference paper accepted (NCCS 2026)
- [ ] Updated analysis + initial CFD for the NCCS presentation (Dec 2026)
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

---

**Prathit Sharma** · [Portfolio](https://prathiitsharma-cmd.github.io) · [LinkedIn](https://linkedin.com/in/prathit-sharma) · [GitHub](https://github.com/prathiitsharma-cmd)
