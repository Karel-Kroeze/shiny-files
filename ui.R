require(shiny)

#' @author Karel A. Kroeze <k.a.kroeze@utwente.nl>
#' 
#' File upload adapted from https://github.com/rstudio/shiny-examples/blob/master/009-upload/app.R
#' 

ui <- fluidPage(
  
  # Application title
  titlePanel("Experiments in file uploading"),
  
  # use tabs to separata data updloading steps from analyses
  tabsetPanel(
    
    # upload, preview and add to 'main' data set.
    tabPanel("Add data", {
      
      
      #  with a slider input for number of bins
      sidebarLayout(
          
        sidebarPanel(

          # Input: Select a file ----
          fileInput("file", "Choose CSV File",
                    multiple = FALSE,
                    accept = c("text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),

          # Horizontal line ----
          tags$hr(),

          # Input: Checkbox if file has header ----
          checkboxInput("header", "Header", TRUE),

          # Input: Select separator ----
          radioButtons("sep", "Separator",
                       choices = c(Comma = ",",
                                   Semicolon = ";",
                                   Tab = "\t"),
                       selected = ","),

          # Input: Select quotes ----
          radioButtons("quote", "Quote",
                       choices = c("None" = "",
                                   "Double Quote" = '"',
                                   "Single Quote" = "'"),
                       selected = '"'),
          
          tags$hr(),
          actionButton("add", "Add data")
        ),

        #
        mainPanel(
          # Preview inputs ---
          tags$label("Preview"),
          dataTableOutput("preview")
        )
      )
    }),
    
    # a simple tab to check the whole data table
    tabPanel("Check data", {
      dataTableOutput("main")
    }),
    
    # some demonstratitve plots
    tabPanel("Analyses", {
      plotOutput("analyses")
    })
  )
)
