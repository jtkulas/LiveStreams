library(shiny)
library(rmarkdown)
library(ggplot2)

data <- data.frame(
  ID = 1:10,
  Name = c("John", "Paul", "George", "Ringo", "Mick", "Keith", "Charlie", "Ronnie", "Roger", "Pete"),
  Age = c(40, 42, 38, 41, 43, 45, 39, 40, 44, 42)
)

server <- function(input, output) {
  filtered_data <- reactive({
    data[data$Age >= input$ageRange[1] & data$Age <= input$ageRange[2], ]
  })
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    #    x    <- filtered_data$Age
    #    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    ggplot(filtered_data(),aes(x=Age)) + geom_histogram()
  })
  
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
                               params = list(text = input$text, outp=input$Try, age=input$ageRange),
                               switch(input$format,
                                      PDF = pdf_document(), 
                                      HTML = html_document(), 
                                      Word = word_document()
                               ))
      file.rename(out, file)
    }
  )
}

ui <- fluidPage(
  tags$textarea(id="text", rows=10, cols=15, 
                placeholder="Some placeholder text"),
  
  flowLayout(sliderInput('ageRange', 'Age Range', 
                         min = 30, 
                         max = 45, 
                         value = c(30, 45)),
             plotOutput("distPlot"),
             radioButtons('format', 'Document format', c('HTML', 'Word','PDF'),
                          inline = FALSE),
             checkboxGroupInput("Try","Let's hope this works",choiceNames = list("include hi","include hey","include hello","include how are you"),choiceValues = list("HI","HEY","HELLO","HOW ARE YOU")),
             downloadButton('downloadReport'))
  
)

shinyApp(ui = ui, server = server)