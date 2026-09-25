# Migration Guidelines: 2025 Beamer → 2026 revealjs

How to port a lecture from `../econometrics-fgv-2025` (read-only) into this repo's Quarto revealjs setup. Read [AGENTS.md](AGENTS.md) first for the layout, render and publish workflows. `lectures/lecture00/lecture00.qmd` is the finished reference migration.

## Sources

| 2025 source | 2026 target | Notes |
|---|---|---|
| `lectures/lecture0/lecture0.tex` | `lecture00/` | Done. Plain Beamer. |
| `lectures/lecture1/lecture1.qmd` | `lecture01/` | Python cells; `Kernels_List.png`, `Bias_Boundary.png` |
| `lectures/lecture2/lecture2.qmd` | `lecture02/` | Python cells |
| `lectures/lecture3/lecture3.qmd` | `lecture03/` | Python cells |
| `lectures/lecture4/lecture4.qmd` | `lecture04/` | Python cells |
| `lectures/lecture5/lecture5.qmd` | `lecture05/` | Python cells |
| `lectures/lecture6/lecture6.qmd` | `lecture06/` | Python cells; TikZ figure; `likelihood_concentration.png` |
| `lectures/lecture7/lecture7.qmd` | `lecture07/` | No code |
| `lectures/lecture8/lecture8.qmd` | `lecture08/` | Python cells; `distributions.png`, `brazil_macro_data.csv`, `download_macro_data_lecture8.py` |
| `lectures/lecture9/lecture9.qmd` | `lecture09/` | No code |
| `lectures/lecture10/lecture10.qmd` | `lecture10/` | No code |

The 2025 `.qmd` files render to Beamer, so they mix Markdown with raw LaTeX. Each source folder also holds the rendered 2025 PDF. Use it to see the intended look, and never render inside the 2025 folder.

## Steps

1. **Create the deck.** Write `lectures/lectureNN/lectureNN.qmd` and delete that folder's `.gitkeep`. Copy the data and image files the deck uses into the same folder.
2. **Replace the front matter** with just this (everything else comes from `lectures/_quarto.yml`):
   ```yaml
   ---
   title: "Lecture 3: Building Blocks for Time Series"
   talkdate: "October 2026"
   jupyter: python3        # only if the deck has code cells
   ---
   ```
   Drop the whole 2025 `format: beamer` block, including `header-includes` (`\tightlist`, `unicode-math`, `tikz`, `emoji`, `multirow`) and `latex-engine`.
3. **Convert every Beamer/LaTeX construct** using the table below. Pay most attention to raw-LaTeX blocks.
4. **Refresh the content for 2026:** dates, names and anything that says "first time teaching". Mark anything you can't confirm as `[...]{.todo}` and list it for the user. Keep the instructor's voice and jokes. Trim wordiness and drop trailing semicolons on bullets.
5. **Render and verify** (see the checklist at the end).
6. **Release on the landing page** only when the user says so (see AGENTS.md). Commit only when asked.

## Raw LaTeX gets dropped silently

Revealjs output **silently discards** ```` ```{=latex} ```` blocks: there's no error, the content just disappears. The 2025 decks have about 50 of these, holding theorems, definitions, `\pause`-d itemize lists and `\vspace`. Convert every one; after rendering, `grep -n '{=latex}' lectures/lectureNN/lectureNN.qmd` must return nothing.

## Construct map

| 2025 (Beamer / LaTeX) | 2026 (revealjs) |
|---|---|
| `\begin{theorem}[Name] … \end{theorem}` (also `definition`, `proposition`, `lemma`, `block`) | `::: {.thm}` containing `::: {.thmhead}` with `Theorem (Name)`, followed by the body |
| Key message or "takeaway" block | `::: {.thm .takeaway}` (orange variant) |
| `\pause`, or itemize split by `\pause` | Markdown list with `. . .` between chunks. The theme already evens out the spacing. |
| `\only` / `\onslide` | `::: {.fragment}` |
| `\alert{x}` | `[x]{.alert}` |
| `\textcolor{FGVBlue}{x}` | `[x]{.fgv}` |
| Green/red bullet items | `::: {.signlist}` with items `[●]{.good} …` / `[●]{.bad} …` |
| `\underline{x}`, `\texttt{x}` | `[x]{.underline}`, `` `x` `` |
| `\vspace{…}` | `::: {.gap}` + `:::`, or just delete it |
| `\small` / `\footnotesize` on a frame | Class on the slide heading: `## Title {.sc92}` (scale from `.sc96` down to `.sc84`) |
| Crowded display math | `## Title {.tightmath}`; wrap one over-wide equation in `::: {.eqfit}` |
| `\begin{columns}` | `:::: {.columns}` containing `::: {.column width="50%"}` blocks; `.polecol` adds a vertical rule |
| `\hyperlink{x}{\beamergotobutton{Label}}` | `::: {.btnbar}` containing `[Label](#slide-id){.gotobtn}`. Give the target slide `{#slide-id}`. |
| `## {.standout}` / `\begin{frame}[standout]` | `## &nbsp; {.standout background-color="var(--slate)"}` then `::: {.standout-body}` containing `Questions?` |
| `# Section` followed by body text | `# Section {visibility="uncounted"}` with nothing under it; move the text to a `##` slide |
| Appendix slides | Add `visibility="uncounted"` to the slide heading |
| `\[ … \]`, `align*` | `$$ … $$`, `$$\begin{aligned} … \end{aligned}$$` |
| `\symbf`, `\E`, `\Var`, `\plim`, … | Keep as they are; they're defined in `_theme/macros.html`. Add new macros there, not per deck. |
| `\label` / `\eqref` | Avoid, or use Quarto's `{#eq-name}` / `@eq-name` |
| `tabular` / booktabs | Markdown pipe table. The theme gives it the booktabs look. |
| `\includegraphics{x.pdf}` | `![](x.svg){width="80%" fig-alt="…"}`. Prefer SVG; PNG is fine. |
| `tikzpicture` | Redraw as an SVG in the lecture folder (hand-written or matplotlib) |
| `\emoji{…}` | A Unicode emoji character |
| Citations | Add `bibliography:` to the deck and use `@key`; end with `## References {.scrollable}` containing `::: {#refs}` + `:::` |

## Code cells

- **Keep the Python cells and their options** (`#| echo`, `#| fig-align`, …). Figures render as SVG (`fig-format: svg` is set in `_quarto.yml`).
- **Keep the 2025 matplotlib settings.** Cells set `plt.rcParams['font.family'] = 'Arial'`, which matches the slides. The default matplotlib blue also works with the palette.
- **Python environment.** Ask the user which conda/mamba environment to use before executing anything. Rendering runs locally, never on GitHub.
- **Every render re-runs the code**, including theme-only re-renders, so the Python environment must be available. There is no `freeze`. Never commit `_freeze/` or `.jupyter_cache/` (both are gitignored). Use per-deck caching (`execute: cache: true`) only if the user asks for it.
- **Reproducible randomness.** Keep or add `np.random.seed(...)` in any cell that simulates, so re-renders give the same figures.
- **Data files** stay next to the deck and are loaded by relative path (`pd.read_csv("brazil_macro_data.csv")`).

## Fitting the slides

Revealjs text (29px root at 1280×720) takes more room than Beamer at 11–12pt, so a frame that fit in 2025 may overflow now. Fix it in this order:

1. Trim the words.
2. Split the slide.
3. Apply a `.scNN` class, going no smaller than `.sc84`.

## Verification checklist

Render cleanly (`rm -rf lectureNN/lectureNN_files && quarto render lectureNN/lectureNN.qmd` from `lectures/`), serve with `python3 -m http.server 8765 --directory lectures`, then check:

- [ ] **No overflow.** With the viewport at 1280×720, this returns `[]` in the browser console:
      `[...document.querySelectorAll('.reveal .slides section.slide')].filter(s => s.scrollHeight > s.clientHeight + 2).map(s => s.id)`
- [ ] **No raw LaTeX left.** `grep -nE '\{=latex\}|\\begin\{(theorem|definition|frame|itemize)\}|\\pause|\\vspace' lectureNN.qmd` is empty.
- [ ] **Math renders.** No red MathJax errors; the macros work.
- [ ] **Pauses behave.** Each `. . .` reveals in order, and bullets stay evenly spaced across it.
- [ ] **Links work.** Go-to buttons, `#/slide-id` links and figures all load.
- [ ] **Print view works.** `lectureNN.html?print-pdf` shows one slide per page with every fragment visible.
- [ ] **No `.todo` boxes left**, unless the user knows about them.
- [ ] **Diff checked against the 2025 PDF.** No slide or result went missing.
