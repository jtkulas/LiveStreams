For classic **R Markdown** (.Rmd) documents, there aren't many dedicated **R packages** that directly provide a "watermark" button or simple function call like Quarto's extensions do. Instead, the most common and reliable approaches rely on:

- **LaTeX packages** (for PDF output) — included via YAML header includes.
- **CSS hacks** (for HTML output).
- A few **specialized R Markdown templates/packages** that build watermark support into their YAML options.

Here are the main options that involve packages or reusable extensions/templates:

### 1. **papaja package** (Best for APA manuscripts with built-in draft watermark)
The [**papaja**](https://frederikaust.com/papaja_man/) package (for creating APA-style journal articles) includes a native `draft` YAML option that automatically adds a "DRAFT" watermark to **every page** of the PDF output.

Install once:
```r
install.packages("papaja")
# or remotes::install_github("crsh/papaja") for latest
```

Then in your `.Rmd` YAML:
```yaml
output: 
  papaja::apa6_pdf:
    draft: true    # ← this adds the DRAFT watermark
```

- Very clean and automatic.
- Only works with `papaja::apa6_pdf` (or related formats).
- Great if your documents are academic/psychological science manuscripts.

### 2. **Standard LaTeX-based approach** (No extra R package needed, most flexible)
This is still the **most widely used method** for general R Markdown PDFs (works in 2026 just as in 2015–2025). No R package required — just include LaTeX via `header-includes`.

**Using `draftwatermark`** (simple background watermark):
```yaml
output:
  pdf_document:
    includes:
      in_header: preamble.tex   # or inline below
```

Or directly inline:
```yaml
output:
  pdf_document:
    latex_engine: xelatex   # or pdflatex
    includes:
      in_header:
        - \usepackage{draftwatermark}
        - \SetWatermarkText{DRAFT -- Confidential}
        - \SetWatermarkColor[gray]{0.85}
        - \SetWatermarkScale{5}
```

**Using `xwatermark`** (for foreground placement over figures):
```yaml
output:
  pdf_document:
    includes:
      in_header:
        - \usepackage[printwatermark]{xwatermark}
        - \usepackage{xcolor}
        - \newwatermark*[allpages,angle=45,scale=3,color=red!30]{DRAFT}
```

- Use the `*` version to place it in the foreground (over images/plots).
- Many corporate templates on GitHub use this pattern.

### 3. **Custom R Markdown templates with watermark support**
Several community templates bundle watermark functionality via custom YAML fields or CSS/LaTeX:

- **pinp** package (Poole IN Particular — nice for vignettes/articles)
  - Has a `watermark: true` option in some skeleton examples (adds a subtle watermark).
  - Install: `install.packages("pinp")`
  - Usage: `output: pinp::pinp`

- **INBOmd**, **memor**, or corporate-style repos on GitHub (e.g., ellisp/rmarkdown-corporate-eg)
  - These often include CSS-based watermarks for HTML and LaTeX for PDF, plus logos/fonts.

- Search GitHub for "rmarkdown template watermark" — you'll find reusable `.Rmd` skeletons with pre-configured CSS `.watermark` classes or LaTeX includes.

### 4. **CSS-only for HTML output** (No package needed)
Same as before — add this raw HTML/CSS block anywhere in your `.Rmd`:
````markdown
```{=html}
<style>
  .watermark {
    position: fixed !important;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-45deg);
    font-size: 120px;
    color: rgba(180,180,180,0.3);
    pointer-events: none;
    z-index: 9999;
  }
</style>
<div class="watermark">DRAFT</div>
```
````

Many corporate R Markdown examples (e.g., from freerangestats.info) use this for HTML reports.

### Quick Comparison (R Markdown only)

| Method                  | Output   | Requires extra package? | Custom text? | Over figures? | Ease |
|-------------------------|----------|--------------------------|--------------|---------------|------|
| papaja `draft: true`    | PDF      | Yes (papaja)            | No (fixed "DRAFT") | Yes          | ★★★★★ |
| draftwatermark LaTeX    | PDF      | No                      | Yes         | Background   | ★★★★  |
| xwatermark LaTeX        | PDF      | No                      | Yes         | Foreground   | ★★★★  |
| CSS fixed div           | HTML     | No                      | Yes         | Usually yes  | ★★★★  |
| Custom template (pinp etc.) | PDF/HTML | Sometimes               | Varies      | Varies       | ★★★   |

**Bottom line for 2026**: If you're doing general reports → stick with `draftwatermark` / `xwatermark` LaTeX includes (zero extra R dependencies). If you're writing APA papers → use **papaja** for the built-in draft watermark. For fancier branded HTML reports → CSS approach.

If none of these fit your exact use case (e.g. Word output, dynamic per-user watermarks), post-processing with tools like `qpdf` or `stamper` in an R script is still a solid fallback. Let me know your target format or style!