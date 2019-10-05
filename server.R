require(shiny)
require(tidyverse)

#' @author Karel A. Kroeze <k.a.kroeze@utwente.nl>
#' 
#' File upload adapted from https://github.com/rstudio/shiny-examples/blob/master/009-upload/app.R
#' 


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # creates an object whose values are reactive
  data <- reactiveValues()
  
  # runs whenever input$add updates
  observeEvent(input$add, {
    # make sure preview data exists
    req(data$preview)
    
    # row bind, adding any new columns
    # note that this has a tendency to fail if columns are incompatible
    tryCatch({
      data$main <- bind_rows( data$main, data$preview )  
    }, error = function(e) {
      
      # note that this is not visible to the user, so we may want to pop
      # up some kind of message for them.
      cat("Caught error: ")
      print(e)
    })
    
  })
  
  # runs every time any of it's reactive dependencies update
  # e.g .input$xxx
  observe({
    req(input$file)
    
    data$preview <- readr::read_delim(
      file = input$file$datapath,
      col_names = input$header,
      delim = input$sep,
      quote = input$quote
    )
  })
  
  # updates whenever data$preview changes
  output$preview <- renderDataTable({
    # only return when data exists
    req(data$preview)
    
    return(data$preview)
  })
  
  # updates whenever data$main changes
  output$main <- renderDataTable({
    # only return when data exists
    req(data$main)
    
    return(data$main)
  })
  
  output$analyses <- renderPlot({
    req(data$main)
    
    molten <- gather(data$main, "variable", "value", names(select_if(data$main,is.numeric) ) )
    ggplot( molten, aes( value ) ) +
      geom_histogram() +
      facet_wrap( .~variable )
    
  })
}
