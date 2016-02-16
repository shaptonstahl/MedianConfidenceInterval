library(shiny)

source("http://www.haptonstahl.org/R/MedianConfidenceInterval/MedianConfidenceInterval.R")

options(shiny.maxRequestSize=50*1024^2)  # changes maximum file size to be uploaded to 50mb

shinyServer(function(input, output) {
  output$bounds.output <- renderText({
    inFile <- input$file1

    if (is.null(inFile)) return("Specify data first")
    else {
      df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
        quote=input$quote)
      use.column <- ifelse(grepl("^[0-9]+$", input$column), 
                           as.numeric(input$column), 
                           input$column)
      data <- as.vector(df[,use.column])
      if(is.numeric(data)) {
        res <- QuantileConfidenceInterval(x=data, p=input$p.out.of.100/100, 
          conf=input$conf.out.of.100/100)
        return(paste("Median = ", median(data), ", Lower bound = ", res$lower, 
               ", Upper bound = ", res$upper, 
               ", Confidence = ", round(res$conf * 100, 2), sep=""))
      } else {
        return("Specify a numeric column")
      }
    }
  })
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.

    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)
    
    data <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
      quote=input$quote)
    if(nrow(data) > 100) data <- data[1:100,]
    return(data)
  })
})
