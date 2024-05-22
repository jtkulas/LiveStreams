library(shiny)
library(DT)

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
                  value = c(30, 40))
    ),
    mainPanel(
      DTOutput("table"),
      downloadButton("downloadData", "Download CSV")
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
  
  # Download handler
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run the app
shinyApp(ui = ui, server = server)

