# Building the report

`main.tex` is the LaTeX source for the BSERC report. `main_preview.pdf` is a pre-built PDF if you just want to read it without compiling anything.

To build it yourself (requires a LaTeX distribution, e.g. TeX Live or MiKTeX):

```
pdflatex main.tex
pdflatex main.tex   # run twice for cross-references/TOC to resolve
```

Figures referenced by the report live in `figures/`.
