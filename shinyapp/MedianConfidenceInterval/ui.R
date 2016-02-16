library(shiny)

shinyUI(
  fluidPage(
    titlePanel("Confidence Interval for the Median or Any Quantile"),
    sidebarLayout(
      sidebarPanel(
        tabsetPanel(
          tabPanel("Reading Data",
            fileInput('file1', 'Choose CSV File',
                      accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv')),
            tags$p(),
            checkboxInput('header', 'Header', TRUE),
            radioButtons('sep', 'Separator',
                         c(Comma=',',
                           Semicolon=';',
                           Tab='\t'),
                         ','),
            radioButtons('quote', 'Quote',
                         c(None='',
                           'Double Quote'='"',
                           'Single Quote'="'"),
                         '"'),
            textInput("column", "Column in file", value="1")
          ),
          tabPanel("Confidence Interval",
            sliderInput("conf.out.of.100", "Confidence level:", 
                        min=1, max=99, value=80),
            sliderInput("p.out.of.100", "Percentile (median = 50):", 
                        min=1, max=99, value=50)
          )
        )
      ),
      mainPanel(
        h4("Upper and Lower Bounds of First Column"),
        textOutput("bounds.output"),
        tags$p(),
        h4("Uploaded Data"),
        tableOutput('contents')

      )
    )
  )
)
