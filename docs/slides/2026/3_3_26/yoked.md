**Yes, Quarto has more than enough mature, well-documented capability to support a solid 1-hour tutorial (or even a longer workshop) on "yoked formats"**—your term perfectly captures the core idea of a single plain-text `.qmd` source that renders reliably to multiple output types (HTML, PDF, DOCX, etc.) at the same time.

This has been a first-class, promoted feature since early Quarto versions (especially strengthened in 1.3+ with the automatic “Other Formats” section), and it remains central in the current docs and tutorials as of 2026. The outputs are *not* too dissimilar to present this way; Quarto was explicitly built to abstract the differences while giving you clean tools to handle the inevitable ones (e.g., interactivity only in HTML, print-specific layout in PDF).

### Core Capabilities That Make a Great Tutorial
You can demonstrate all of these live in under an hour with simple, reproducible examples:

1. **One source → many outputs out of the box**  
   In the YAML header:
   ```yaml
   ---
   title: "Yoked Formats Demo"
   author: "Your Name"
   format:
     html:
       toc: true
       code-fold: true
     pdf:
       toc: true
       number-sections: true
       colorlinks: true
     docx: default   # or typst, revealjs, etc.
   ---
   ```
   Then one command produces everything:
   ```bash
   quarto render mydoc.qmd          # renders ALL formats listed
   quarto render mydoc.qmd --to html,pdf   # or just the ones you want
   ```
   IDE buttons usually preview only the first format, but the CLI (or R/Python `quarto::quarto_render(..., output_format = "all")`) does simultaneous rendering perfectly.

2. **Shared vs. format-specific options**  
   Top-level options (e.g., `toc`, `fig-cap`, citations, cross-references) apply everywhere. Nested options let you tweak per format without duplication.

3. **Automatic “Other Formats” navigation (the killer “yoked” feature)**  
   When you render an HTML version that also has PDF/DOCX/etc. defined, Quarto automatically adds a nice sidebar or top section with download links to the other rendered files. You can control it with `format-links`:
   ```yaml
   format-links: [pdf, docx]          # only show these
   # or customize:
   format-links:
     - format: pdf
       text: "PDF version"
       icon: file-pdf
   ```
   This makes the HTML feel like the “hub” that yokes everything together—perfect demo material.

4. **Conditional content to handle real differences gracefully**  
   This is the secret sauce that lets you keep *one* source file while still producing polished outputs:
   ```markdown
   ::: {.content-visible when-format="html"}
   This interactive plot or video only appears in HTML.
   :::

   ::: {.content-visible when-format="pdf"}
   Here is the static screenshot for print.
   :::

   Some text that is [only in HTML.]{.content-visible when-format="html"}
   ```
   Works on divs, spans, code blocks, and even executable chunks. Aliases exist (`html` covers dashboards/revealjs, `latex` covers pdf/beamer, etc.). You can also use `unless-format` or metadata-based conditions.

5. **Cross-format consistency features**  
   - Figures/tables: automatic handling with `fig-format`, `fig-cap`, etc.
   - Math, citations (Zotero/BibTeX), cross-references, callouts—all work across HTML/PDF/DOCX.
   - Theming/branding extensions that apply to multiple formats.
   - Projects/websites: `_quarto.yml` or `_metadata.yml` can set defaults for whole folders while still letting individual docs override.

### Realistic Limitations (Easy to Cover Honestly)
- HTML excels at interactivity (Plotly, Shiny, Observable); PDF is static/print-oriented.
- Complex CSS layouts or JavaScript may need conditional fallbacks.
- PDF (via LaTeX or Typst) sometimes needs extra packages or tuning for perfect typography.
- Same-extension formats (e.g., two different HTML outputs) need `output-file:` to avoid overwriting.

These are *not* deal-breakers—they’re teaching opportunities. Show a 5-line example where conditional content fixes the exact pain point, and students will love it.

### Suggested 1-Hour Outline (Tested Conceptually on Real Quarto Docs)
- **0–10 min**: What “yoked formats” means + live demo of a 10-line `.qmd` → HTML + PDF + DOCX in one command.
- **10–25 min**: YAML setup, rendering commands, shared vs. specific options, “Other Formats” section.
- **25–45 min**: Conditional content deep-dive + hands-on exercise (add a plot that’s interactive in HTML, static in PDF).
- **45–55 min**: Projects/websites, branding, best practices, common gotchas.
- **55–60 min**: Q&A + “next steps” (custom format extensions, parameterized reports, Quarto books).

You’ll have time left over—there’s genuinely *more* material than fits in 60 minutes once people start experimenting.

**Bottom line**: Go for it. The feature set is rich, stable, and explicitly designed around the exact story you want to tell. Quarto’s own getting-started tutorials already include multi-format sections, so you’re building on official best practices rather than edge cases. Your audience will walk away impressed at how seamlessly one plain-text file can produce professional, linked, format-appropriate outputs. If you want, I can help sketch a sample `.qmd` file or slide outline for the tutorial.