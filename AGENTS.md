# PhD Thesis — Project Guide for Agents

## Project overview

UCI PhD dissertation in LaTeX using the `ucithesis` document class.

- **Compiler:** `lualatex` (TeX Live 2023)
- **Bibliography:** `biblatex` + `biber` backend (note: `main.tex` uses `biblatex`; the original `natbib`/`bibtex` description below is outdated)
- **Build system:** `make` (full build) / `make quick` (single pass)
- **Root file:** `main.tex`

> **⚠️ Agent note:** The Cowork sandbox does **not** have `biblatex` or `biber` installed, so `make` / `make quick` will fail inside the sandbox. Do **not** attempt to run builds here. All LaTeX compilation must be done on the user's local machine.

---

## File structure

```
main.tex                  root document
preliminaries.tex         title, abstract, committee metadata
vita.tex                  curriculum vitae (included via \input{vita} in main.tex)
thesis-style.sty          custom macros; add all personal commands here
thesis.bib                BibTeX bibliography database
Makefile                  build system
ucithesis.cls             UCI thesis class — do not modify
uci-manual/               scraped UCI thesis manual (reference only)

chapters/
  chapter1.tex            each chapter in its own file
  chapter2.tex
  ...

appendices/
  appendix.tex            supplementary material

figures/
  ch1/                    chapter-specific figures
  ch2/
  ...

tables/                   optional standalone table files
```

---

## Building

### Full build (recommended)
Runs lualatex → bibtex → lualatex → lualatex to resolve all cross-references and bibliography entries.
```bash
make
```

### Quick build (single pass)
Useful while drafting. Cross-references and bibliography may be stale.
```bash
make quick
```

### Clean auxiliary files
```bash
make clean
```

### Manual compilation sequence
If you need to run steps individually:
```bash
lualatex -interaction=nonstopmode main.tex
bibtex main
lualatex -interaction=nonstopmode main.tex
lualatex -interaction=nonstopmode main.tex
```

### Compiling a subset of chapters
Uncomment `\includeonly` in `main.tex` to build only specific chapters. All page numbers and cross-references are preserved.
```latex
\includeonly{chapters/chapter2,chapters/chapter3}
```

---

## Package load order (important — do not rearrange)

1. Math: `amsmath`, `amsthm`, `amssymb`
2. Graphics/tables: `graphicx`, `booktabs`, `caption`, `subcaption`, `multirow`, `tabularx`
3. Bibliography: `natbib`
4. Misc layout: `relsize`, `appendix`, `parskip`
5. `hyperref` (must be loaded late)
6. `tagpdf` (must be loaded after hyperref)
7. `thesis-style` (which loads `cleveref` last — cleveref must always be the very last package)

---

## Accessibility (UCI requirement)

UCI requires all PhD dissertations to produce tagged, accessible PDFs (PDF/UA-1). The project is already configured for this. Key points:

### What's already set up
- `\DocumentMetadata{pdfstandard=UA-1, lang=en-US}` before `\documentclass` — declares PDF/UA conformance and document language
- `tagpdf` with `activate-all` — enables PDF structure tags (headings, paragraphs, lists, figures, tables)
- `hyperref` with `unicode=true` and `pdfdisplaydoctitle=true` — accessible links and bookmarks
- `\hypersetup{pdftitle, pdfauthor, pdfsubject}` — document metadata populated from `preliminaries.tex`

### Alt text for figures (required)
Every `\includegraphics` must include an `alt=` key with a meaningful description. The `tagpdf` package enables this key.

```latex
\begin{figure}
  \centering
  \includegraphics[width=\linewidth, alt={Bar chart showing accuracy vs. dataset size}]{figures/ch1/accuracy}
  \caption{Model accuracy as a function of training set size.}
  \label{fig:accuracy}
\end{figure}
```

A missing `alt=` key will produce a `tagpdf` warning in the log. Search for `no alt text` warnings after building.

### Table captions above tables (UCI manual §2.9.1 + accessibility)
The UCI manual requires table numbers and titles above each table. This is also a PDF/UA requirement.

```latex
\begin{table}
  \caption{Summary of results.}   % <-- caption BEFORE tabular
  \label{tab:results}
  \centering
  \begin{tabular}{lrr}
    \toprule
    Method & Accuracy & F1 \\
    \midrule
    Baseline & 72.3 & 68.1 \\
    Ours     & 84.7 & 81.9 \\
    \bottomrule
  \end{tabular}
\end{table}
```

Use `booktabs` rules (`\toprule`, `\midrule`, `\bottomrule`), never `\hline`.

### Cross-references
Always use `\cref{label}` or `\Cref{label}` (from `cleveref`), never bare `\ref{}`. `\Cref` capitalizes the label name ("Figure", "Chapter") for use at the start of a sentence.

```latex
Results are shown in \cref{fig:accuracy}.
\Cref{tab:results} summarizes performance.
```

### Final submission
Before submitting, remove the two `uncompress` options to produce a smaller, conforming PDF:

1. In `\DocumentMetadata{...}` — remove `uncompress,`
2. In `\tagpdfsetup{...}` — remove `uncompress,`

Then verify accessibility with [PAC 2024](https://pac.pdf-accessibility.org/) or the Adobe Acrobat accessibility checker.

### Troubleshooting tagpdf
If `tagpdf` causes a compilation error:

- Check `main.log` for the specific error message.
- Temporarily disable tagging to isolate the issue:
  ```latex
  \tagpdfsetup{activate-all=false}
  ```
- Wrap a problematic environment to suppress paragraph tagging locally:
  ```latex
  \tagpdfparaOff
  ...
  \tagpdfparaOn
  ```

---

## Custom style file (thesis-style.sty)

All personal LaTeX macros go in `thesis-style.sty`. It is `\usepackage`'d from `main.tex` and loads `cleveref` as its last action.

Current contents:
- `cleveref` with `capitalize, noabbrev` options
- Math shortcuts: `\R`, `\N`, `\Z`, `\E`, `\Prob`, `\norm{}`, `\abs{}`, `\inner{}{}`
- Operators: `\argmin`, `\argmax`, `\tr`, `\rank`

Add field-specific notation, theorem environments, etc. here.

---

## Bibliography

The project uses `natbib` for citation commands and `bibtex` for processing.

Common citation commands:
- `\citep{key}` — parenthetical: (Author, 2020)
- `\citet{key}` — textual: Author (2020)
- `\cite{key}` — also parenthetical (same as `\citep` in most styles)

Add entries to `thesis.bib`. Run `make` (or `bibtex main` manually) to rebuild the bibliography.

---

## Adding chapters

1. Create `chapters/chapterN.tex` starting with `\chapter{Title}`.
2. Add `\include{chapters/chapterN}` in `main.tex` (already-commented placeholders exist).
3. Put figures for chapter N in `figures/chN/`.

---

## UCI formatting requirements (from manual)

- **Margins:** 1" minimum on all sides (enforced by `ucithesis.cls`)
- **Font size:** 12pt main body, 10pt minimum for footnotes/captions (set by `\documentclass[12pt]`)
- **Spacing:** double-spaced body; single-spaced footnotes, captions, bibliography
- **Pagination:** roman numerals for preliminary pages; arabic starting at Chapter 1
- **Preliminary pages order:** Title → Copyright → Dedication (opt.) → TOC → LoF → LoT → Acknowledgments → Vita → Abstract
- **Appendices:** come after the bibliography
- **Appendix figures/tables:** must NOT appear in the main List of Figures / List of Tables
- **Signature page:** do NOT include (not valid for electronic submission since 2013)
