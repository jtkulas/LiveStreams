**People mainly do it to keep equations accurate, consistent, and automatically up-to-date.**

Here are the most common practical reasons:

### 1. Insert dynamic or computed values into the math
You often want an equation to show the *actual numbers* from your analysis rather than placeholders.

Example:
- You fit a regression and get intercept = 2.47 and slope = 0.83.
- Instead of hard-coding those numbers (and risking them becoming outdated), you can write something like:

  $$ \hat{y} = {{< meta intercept >}} + {{< meta slope >}} x $$

  Quarto replaces the shortcodes with the real values when it renders the document. This is especially useful in scientific papers, reports, or teaching materials where the numbers come from code, data, or YAML metadata.

### 2. Reuse the same value in many places (including equations)
If a constant, sample size, parameter, or physical value appears both in the text *and* inside formulas, defining it once (via `{{< var >}}` or `{{< meta >}}`) guarantees consistency. Change it in one place and every equation updates automatically.

### 3. Custom shortcodes that produce math fragments
Some extensions or personal shortcodes generate pieces of LaTeX or specialized notation (for example, formatted units, repeated complex expressions, or domain-specific symbols). Being able to drop those shortcodes directly inside `$...$` or `$$...$$` is convenient.

### 4. Parallel to how people already use inline code
Many Quarto/R Markdown users already put computed values inside equations using inline code (e.g. `` `{r} coef` ``). Shortcodes are the cleaner, language-agnostic equivalent for values that live in metadata, variables files, or custom extensions.

In short: it’s about making equations *live* parts of a reproducible document rather than static text that can drift out of sync with the rest of the analysis. The feature was added because people were already trying to do this and hitting limitations.