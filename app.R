library(shiny)
library(rmarkdown)
server <- function(input, output) {
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('my-report', sep = '.', switch(
        input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    content = function(file) {
      src <- normalizePath('apptest.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'apptest.Rmd', overwrite = TRUE)
      
      out <- rmarkdown::render('apptest.Rmd',
                               params = list(text = input$text,outp=input$Try),
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
  tags$textarea(id="text", rows=20, cols=155, 
                placeholder="Some placeholder text"),
  
  flowLayout(radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),
                          inline = TRUE),
             checkboxGroupInput("Try","Let's hope this works",choiceNames = list("include hi","include hey","include hello","include how are you"),choiceValues = list("HI","HEY","HELLO","HOW ARE YOU")),
             downloadButton('downloadReport'))
  
)

shinyApp(ui = ui, server = server)