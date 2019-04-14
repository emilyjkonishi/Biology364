library(rhandsontable)
library(shiny)

startingX <- as.numeric(0:4)
startingY <- as.numeric(c(0,0,0,0,0))
MyDataFrame <- data.frame(Concentration = startingX, Absorbance= startingY)

editTable <- function(MyDataFrame, outdir=getwd(), outfilename="table"){
  ui <- shinyUI(fluidPage(
    
    titlePanel("Edit and save a table"),
    sidebarLayout(
      sidebarPanel(
        helpText("Right-click on the table to delete/insert rows.", 
                 "Double-click on a cell to edit"),
        
        wellPanel(
          h3("Save"), 
          actionButton("save", "Save table")
        )        
        
      ),
      
      mainPanel(
        
        rHandsontableOutput("hot")
        
      )
    )
  ))
  
  server <- shinyServer(function(input, output) {
    
    values <- reactiveValues()
    
    ## Handsontable
    observe({
      if (!is.null(input$hot)) {
        MyDataFrame = hot_to_r(input$hot)
      } else {
        if (is.null(values[["MyDataFrame"]]))
          MyDataFrame <- MyDataFrame
        else
          MyDataFrame <- values[["MyDataFrame"]]
      }
      values[["MyDataFrame"]] <- MyDataFrame
    })
    
    output$hot <- renderRHandsontable({
      MyDataFrame <- values[["MyDataFrame"]]
      if (!is.null(MyDataFrame))
        rhandsontable(MyDataFrame, useTypes = FALSE, stretchH = "all", digits = 2)
    })
    
    ## Save 
    observeEvent(input$save, {
      finalMyDataFrame <- isolate(values[["MyDataFrame"]])
      write.csv(finalMyDataFrame, file=file.path(outdir, sprintf("%s.csv", outfilename)), row.names = FALSE)
    })
    
  })
  
  ## run app 
  runApp(list(ui=ui, server=server))
  return(invisible())
}

editTable(MyDataFrame)