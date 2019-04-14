if (!require("rhandsontable")) install.packages("rhandsontable"); library(rhandsontable)

# Set up starting table
startingX <- as.numeric(0:4)
startingY <- as.numeric(c(0,0.1001,0.2,0.3,0.4))
MyDataFrame <- data.frame(Concentration = startingX, Absorbance= startingY)

ui <- fluidPage(
  titlePanel("Standard Curve for Biology 205"),
  sidebarLayout(
    sidebarPanel(
      helpText("Enter your results in the data table below."),
      helpText("Right-click on the table to delete/insert rows."), 
      helpText("Double-click on a cell to edit."),
      rHandsontableOutput("hot"),
      wellPanel(actionButton("save", "Save table")),
      helpText("Click Save table to download a .csv formatted file."),
      radioButtons('format', 'Document format', c('HTML', 'PDF', 'Word'),
                   inline = TRUE),
      downloadButton('downloadReport'),
      helpText("Choose the desired format to download the figure and linear regression model statistics.")
    ),
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("regPlot")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Table", tableOutput("table"))
                  )
      )
    )
)

server <- function(input, output) {
  
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
    write.csv(finalMyDataFrame, file="table.csv", row.names = FALSE)
  })
  

  regFormula <- reactive({
    as.formula('Absorbance ~ Concentration')
  })
  
  # Generate a plot of the data
  output$regPlot <- renderPlot({
    par(mar = c(4, 4, .1, .1))
    plot(regFormula(), data = values[["MyDataFrame"]], pch = 19,
         xlab = "Protein concentration (mg/mL)", 
         ylab = "Absorbance (at 595 nm)")
    abline(lm(regFormula(), data = values[["MyDataFrame"]]), lwd = 2)
  })
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(lm(Absorbance ~ Concentration, data = values[["MyDataFrame"]]))
  })
  
  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    values[["MyDataFrame"]]
  })

  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('my-report', sep = '.', switch(
        input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },

    content = function(file) {
      src <- normalizePath('report.Rmd')

      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'report.Rmd', overwrite = TRUE)

      library(rmarkdown)
      out <- render('report.Rmd', switch(
        input$format,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
    }
  )

}

shinyApp(ui = ui, server = server)