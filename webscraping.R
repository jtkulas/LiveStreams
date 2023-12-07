## webscraping - 12/2/23

library(rvest)
library(tidyverse)
library(plotly)

page <- read_html("https://www.espn.com/nfl/stats/player/_/view/offense/stat/rushing/table/rushing/sort/rushingYards/dir/desc")

name <- page %>% html_nodes(".mr7 .AnchorLink") %>% html_text()
position <- page %>% html_nodes(".position") %>% html_text()     ## grabbing 100 - weird
games <- page %>% html_nodes(".position+ .Table__TD") %>% html_text()
attempts <- page %>% html_nodes(".Table__TD:nth-child(3)") %>% html_text()
yards <- page %>% html_nodes(".Table__TD:nth-child(4)") %>% html_text()
tds <- page %>% html_nodes(".Table__TD:nth-child(8)") %>% html_text()

together <- as.data.frame(cbind(games, attempts, yards, tds))
use <- data.frame(lapply(together, function(x) as.numeric(as.character(x))))
position2 <- position[c(TRUE,FALSE)]   ## appears to be reading in 2 at a time
use <- cbind(name,position2,use)


plot_ly(use, x = ~tds, y = ~yards, 
        text = ~paste("Player: ", name, "<br>Position:", position2), 
        size = ~attempts, color = ~attempts)
