# AGENTS.md

Entry point for coding agents working in this repo.

## What this is

Materials for **Econometrics I (Part I), FGV EPGE, 2026**, taught by Raul Riva: public repo `epge-classes/econometrics-fgv-2026`.

- Lecture slides are **Quarto → revealjs** decks, published with GitHub Pages at <https://epge-classes.github.io/econometrics-fgv-2026/>.
- Problem sets go through GitHub Classroom. The syllabus is `README.md`.
- Last year's course is in the sibling folder `../econometrics-fgv-2025` (Quarto → Beamer and LaTeX). **Read it, never write to it:** no edits, no renders, no git commands that change it. Copy anything you need first.
- To port a 2025 lecture, follow **[MIGRATION_GUIDELINES.md](MIGRATION_GUIDELINES.md)**.

## Layout

```
README.md                 syllabus, the student-facing course page on GitHub
LICENSE                   CC BY 4.0
.github/workflows/pages.yml   publishes lectures/ to GitHub Pages
lectures/                 Quarto project; its contents become the site root
  _quarto.yml             shared revealjs config (every deck inherits it)
  _theme/
    custom.scss           slide theme (colors, .thm, .signlist, .gotobtn, list spacing, ...)
    landing.scss          landing-page theme
    title-slide.html      title-slide template (title / presenter / affil / talkdate / venue)
    fonts.html            Google Fonts <link>: Arimo (Arial fallback) + Fira Mono
    mathjax-font.html     forces the Computer Modern MathJax font (slides only)
    macros.html           shared math macros: \E \Var \Cov \Corr \Pr \R \N \plim \iid \symbf
  index.qmd               landing page (plain HTML): links + one row per lecture
  lectureNN/lectureNN.qmd one deck per folder, zero-padded 00..10
extra-stuff/              gitignored, not part of the class
```

## Render

Run from `lectures/`. The rendered output (`*.html` plus the `*_files/` folder) **is committed**, because Pages publishes those files as they are.

```bash
rm -rf lecture03/lecture03_files && quarto render lecture03/lecture03.qmd   # one deck
rm -rf index_files && quarto render index.qmd                               # landing page
```

- **Always delete a page's `_files/` folder before re-rendering.** Quarto never removes superseded `quarto-<hash>.css` files, so they pile up in git.
- **After changing anything in `_theme/` or `_quarto.yml`**, clean and re-render every deck and the landing page (`rm -rf */*_files index_files && quarto render`).
- **Code re-runs on every render.** There's no `freeze`, and caches (`_freeze/`, `.jupyter_cache/`) are gitignored and never committed. A slow deck may opt into `execute: cache: true` in its own front matter, but only when the user asks.
- **Preview over HTTP:** `python3 -m http.server 8765 --directory lectures`. Opening files through `file://` breaks their assets in some viewers.

## Publish

Pushing to `main` publishes. Any push that touches `lectures/**` runs `.github/workflows/pages.yml`, which uploads `lectures/` as the site. The runner doesn't install Quarto or Python; it ships what you committed.

1. Render as above, then commit the source and the rendered output together.
2. `git push origin main`
3. Check it: `gh run list --repo epge-classes/econometrics-fgv-2026 --limit 1`, then `gh run watch <id> --exit-status`, then `curl -sI` the page URL.

Page URLs follow the folders: `…/econometrics-fgv-2026/lecture03/lecture03.html`. Links to a specific slide work (`#/slide-id`).

**Releasing a lecture:** in `lectures/index.qmd`, replace that row's `[coming soon]{.soon}` with the Slides/PDF link span copied from the lecture 00 row, and fix the folder names. Then re-render `index.qmd` and publish. The PDF link is the deck URL plus `?print-pdf`; students use the browser's Print → Save as PDF, and nobody produces PDF files.

Pages is set to "GitHub Actions" mode. Don't switch it to branch mode.

## Style contract

- **Colors:** structure `$slate` `#2D3E50` (the 2025 Beamer "slateblue"), accent/links `$FGVBlue` `#0072BC`, alerts `#EB811B`, good `#2E7D32`, bad `#C62828`. `$slate` is defined in **both** `custom.scss` and `landing.scss`, so keep them in sync.
- **Fonts:** Arial for text, with Arimo loading only where Arial is missing; Fira Mono for code; Computer Modern for math. Arial has only regular and bold, so weight 600 renders bold.
- **Slides:** 1280×720, no transitions. Slide text is terse, with no trailing semicolons on bullets.
- **Landing page:** lists only the Part I instructor. It links to the repo, the syllabus and the problem sets on GitHub; none of those get their own page.
- **`[text]{.todo}`** renders as a loud "TODO:" box for facts still to confirm. Never publish a deck that still has one.

## Gotchas

- **Google Fonts rejects the whole CSS URL (HTTP 400)** if you request a weight a family doesn't have. Arimo has no 300. Test a changed URL with `curl`.
- **Font names containing a digit** (e.g. "Source Sans 3") must be written `unquote("\"Name\"")` in SCSS. Quarto's Sass strips the quotes, and the browser then drops the whole declaration.
- **`mathjax-font.html` depends on Quarto internals** (tested on Quarto 1.10.18). After upgrading Quarto, check that math still renders.
- **Reveal.js ignores `#/slide-id` inside an iframe.** It works in a normal tab.
- **The repo lives in Dropbox, which leaves `* (… conflicted copy …)*` files.** This happens most often right after `rm -rf …_files` and a re-render. Always delete them (`find . -name "*conflicted copy*" -not -path "./.git/*" -delete`), and never rename, keep or commit them. Afterwards, check that every figure the HTML references exists. If one is missing, wait a few seconds and re-render that deck.
- **Spacing across `. . .` pauses is already fixed** in `custom.scss` ("Stitch lists split by . . ."). Don't add per-slide spacing hacks.

## Guardrails

- Commit and push only when the user asks. Group commits by topic.
- The repo is **public**. Ask before committing solutions, exams, grades or any student data, and never copy grades or student data from the 2025 folder.
- Preserve the user's own edits. Check `git status` and diffs before overwriting anything.
