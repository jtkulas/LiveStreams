**Yes**, there are several useful R packages that help with creating, simulating, optimizing, filling out, printing, and visualizing NCAA basketball (March Madness) brackets. These integrate directly into **Quarto** or **RMarkdown** documents via code chunks (e.g., for plots, tables, or interactive outputs with knitr/html).

I didn't find any dedicated **Quarto extensions** (like .qmd templates or shortcodes) or official RMarkdown templates specifically for NCAA brackets—most people build them custom in R code chunks using the packages below (or ggplot2 for visuals). Printable Excel/PDF templates exist outside R, but the packages here let you generate dynamic, data-driven brackets in your reports.

### Top Packages for NCAA Brackets

1. **mRchmadness** (GitHub-only, highly NCAA-specific)  
   - **What it does**: Scrapes NCAA data, estimates matchup win probabilities, simulates tournaments, optimizes brackets (e.g., to maximize your chance of winning an office pool against opponents' likely picks), and **draws** visual brackets.  
   - **Key functions**: `draw.bracket()` (plots empty or filled brackets with team names/results—perfect for embedding in Quarto/RMD), `find.bracket()` / simulation tools, plus a built-in Shiny app.  
   - **Installation**:  
     ```r
     devtools::install_github("elishayer/mRchmadness", build_vignettes = TRUE)
     ```
   - **Example in Quarto/RMD** (renders a plot directly):  
     ```r
     library(mRchmadness)
     # ... load teams + simulate ...
     draw.bracket(bracket.empty = your_64_teams, bracket.filled = sim_results, league = "men")
     ```
   - Great for visual bracket creation in documents.

2. **bracketeer** (On CRAN – most flexible/general)  
   - **What it does**: Models any tournament (explicitly supports NCAA-style single-elimination, group-to-knockout, etc.). Define bracket structure like a rulebook, input results like a scoreboard, get standings/matches/winner. Outputs clean data frames → easy tables/plots in Quarto.  
   - **Key functions**: `tournament() |> single_elim() |> ...`, `results()`, `standings()`, `matches()`. Vignettes cover FIFA/Stanley Cup (very similar to March Madness).  
   - **Installation**:  
     ```r
     install.packages("bracketeer")  # CRAN, v0.1.1 as of 2026
     ```
   - **Example**:  
     ```r
     library(bracketeer)
     tournament(teams_vector) |>
       single_elim("playoffs", take = top_n(8))  # NCAA-style knockout
     # Then pipe results and render tables in Quarto
     ```
   - Ideal for dynamic, reproducible brackets in reports.

3. **kaggleNCAA** (GitHub)  
   - **What it does**: Loads Kaggle-style prediction CSVs, simulates the full NCAA tournament (Monte Carlo or deterministic), extracts results, and generates **printable** brackets.  
   - **Key functions**: `parseBracket()`, `simTourney()` / `walkTourney()`, `extractBracket()`, **`printableBracket()`**.  
   - **Installation**:  
     ```r
     devtools::install_github("zachmayer/kaggleNCAA")
     ```
   - **Example**:  
     ```r
     library(kaggleNCAA)
     dat <- parseBracket("your_predictions.csv")
     bracket <- walkTourney(dat)  # or simTourney()
     printableBracket(bracket)  # Outputs a clean printable view
     ```
   - Excellent for simulation-based bracket creation/export.

4. **MMBracketR** (GitHub – lighter weight)  
   - Explores predictions and helps build/fill brackets.  
   - Install: `devtools::install_github("alexkaechele/MMBracketR")`.  
   - Useful companion for quick picks/exploration.

### Bonus Tips for Quarto/RMarkdown
- Combine with **ggplot2** for custom bracket drawings (StackOverflow and blogs have ready examples of connecting lines/teams).
- Use `gt`, `kableExtra`, or `reactable` on outputs from the packages above for interactive HTML tables.
- Embed Shiny apps (e.g., from mRchmadness) or `htmlwidgets` for fillable/interactive brackets in Quarto HTML output.
- For pure viz without a package: many tutorials simulate regions with base R/ggplot and knit them in.

These packages make it easy to go from raw data → simulated/optimized bracket → rendered plot/table in one Quarto document. If you share more details (e.g., "I want printable PDF output" or "simulation-heavy"), I can give exact code snippets or help set one up!