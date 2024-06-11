library(shiny)
library(DT)
library(ggplot2)

# Sample dataset
data <- data.frame(
  ID = 1:10,
  Name = c("John", "Paul", "George", "Ringo", "Mick", "Keith", "Charlie", "Ronnie", "Roger", "Pete"),
  Age = c(40, 42, 38, 41, 43, 45, 39, 40, 44, 42)
)

# Define UI
ui <- fluidPage(
  titlePanel("Download CSV Example"),
  fluidRow(
    sidebarPanel(
      sliderInput('ageRange', 'Age Range', 
                  min = 30, 
                  max = 45, 
                  value = c(30, 45)),
      plotOutput("distPlot"),
      downloadButton("downloadPlot", "Download Histogram")
    ),
    mainPanel(
      DTOutput("table"),
      downloadButton("downloadData", "Download CSV"),
      downloadButton("downloadReport", "Download Report")
      )
  )
)

# Define server logic
server <- function(input, output) {
  # Reactive expression to filter data based on age range
  filtered_data <- reactive({
    data[data$Age >= input$ageRange[1] & data$Age <= input$ageRange[2], ]
  })
  
  # Display the table
  output$table <- renderDT({
    filtered_data()
  })
  
  # Download handlers
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )

## Copied from above (that works) - want to download image; 5/28/24
  output$downloadPlot <- downloadHandler(          
    filename = function() {
      paste("data-", Sys.Date(), ".png", sep = "")
    },
    content = function(file) {
      png(file)
      print(ggplot(filtered_data(),aes(x=Age)) + geom_histogram()
)
      dev.off()
    }
  )
  
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('my-report', sep = '.', switch(
        input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    content = function(file) {
      src <- normalizePath('child_script.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'child_script.Rmd', overwrite = TRUE)
      
      out <- rmarkdown::render('child_script.Rmd',
                               params = list(text = input$text,outp=input$Try),
                               switch(input$format,
                                      PDF = pdf_document(), 
                                      HTML = html_document(), 
                                      Word = word_document()
                               ))
      file.rename(out, file)
    }
  )
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
#    x    <- filtered_data$Age
#    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    ggplot(filtered_data(),aes(x=Age)) + geom_histogram()
  })
}

# Run the app
shinyApp(ui = ui, server = server)

