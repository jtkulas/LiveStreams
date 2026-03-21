# For the latest version of the package, updated frequently during the first
# couple weeks of March, install directly from this GitHub repository.

## mRchmadness

devtools::install_github("elishayer/mRchmadness", build_vignettes = TRUE, force=TRUE)

library(mRchmadness)

draw.bracket(bracket.empty = bracket.men.2026)


library(MMBracketR)
plotTourn(games = 64, playin = TRUE)

## not much there - probably easier to just copy the function & directly amend "regions" object

plotTourn <- function(games=32, playin = NA){
  
  # Taking into consideration a game occurs on a line
  games <- games/4
  
  # Generate start and stop for line segment plots
  lineCoord <- bracketLines(games = games, playin = playin)
  
  # Locations for labels
  regions <- c("Region Yaddup", "Region W", "Region Y", "Region Z", "Championship")
  xregion <- c(2.5, 2.5, 6.5, 6.5, 4.5)
  yregion <- c(.5, 16.5, .5, 16.5, 17)
  
  # Generating plots
  tournplot <- ggplot2::ggplot(data = lineCoord) +
    ggplot2::theme_void() +
    ggplot2::geom_segment(ggplot2::aes(x = x1, y = y1, xend = x2, yend = y2)) +
    ggplot2::annotate("text", x = xregion, y = yregion, label = regions)
  
  # Return ggplot object
  return(tournplot)
  
}

plotTourn(games = 64)
