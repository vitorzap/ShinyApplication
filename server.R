# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

# Loading the necessary libraries
library(stringr)
library(shinyjs) 



function(input, output) {

# Creating flags to control the upload and reset of the file,
#  as well as the generation of linear regression
  values <- reactiveValues(
      upload_state = NULL,
      regression_State = 'not ready'
  )
  
  observeEvent(input$file1, {
    values$upload_state <- 'uploaded'
  })
  
  observeEvent(input$reset, {
    values$upload_state <- 'reset'
    values$regression_State  <- 'not ready'
    reset('file1')
  })
  
  observeEvent(input$domodel, {
    if (is.null(file_input())) 
    {
      values$regression_State  <- 'not ready'
    }
    else
    {  
      values$regression_State  <- 'ready'
    }
  })
  
  regressionOk <- reactive ({ return(values$regression_State) })
  
  file_input <- reactive({
    if (is.null(values$upload_state)) {
      return(NULL)
    } else if (values$upload_state == 'uploaded') {
      return(input$file1)
    } else if (values$upload_state == 'reset') {
      return(NULL)
    }
  })
  
# reading de file
  df <- reactive ({
    if (is.null(file_input())) return(NULL)
    read.csv(file_input()$datapath, header = input$header,
             sep = input$sep, quote = input$quote)
  })

  # Generating the controls and texts from the "File upload" tab
  output$tInf <- renderText({
    if (is.null(file_input())) return(NULL)
    return('File Information')
  }) 
  
  output$fInf <- renderTable({
    if (is.null(file_input())) return(NULL)
    data.frame(File_Info = c('Name','Local path','Type','Rows','Columns'),
               c(file_input()$name,file_input()$datapath,
                 file_input()$type,nrow(df()),ncol(df())
               ))
  },colnames = FALSE,bordered=TRUE, striped = TRUE)

  output$tstr <- renderText({
    if (is.null(file_input())) return(NULL)
    return('Structure')
  }) 

# Capturing command output "str" and formatting for display    
  estruct <- reactive({
    tStr <- capture.output(str(df()))
    tStr <- tStr[2:length(tStr)]
    tStr <- data.frame(Structure=tStr)
  })
# Generating the table with the file structure
  output$str <- renderTable({
    if (is.null(file_input())) return(NULL)
    return(estruct())
  },colnames = FALSE,bordered=TRUE, striped = TRUE)
 
  output$grid <- renderTable({ df() },bordered=TRUE, striped = TRUE)
  
# Generating the check boxes to obtain the variables to be plotted in the graph
  output$x_column <- renderUI({
    if(is.null(df()))
      return()
    selectInput("xaxis", "X_Axis", cbind(" ",names(df())), selected = 1)
  })
  
  output$y_column <- renderUI({
    if(is.null(df()))
      return()
    selectInput("yaxis", "Y_Axis", cbind(" ",names(df())), selected = 1)
  })  

# Rendering graphics    
  output$plot1 <- renderPlot({
    if(is.null(df()))
      return()
    if(input$xaxis==" ")
      return()
    if(input$yaxis==" ")
      return()
    plot(df()[,input$xaxis], df()[,input$yaxis], bty = "n", 
         pch = 16,xlab = input$xaxis,ylab = input$yaxis, col = "red",
         main = paste("Ploting ", input$xaxis, " X " ,input$yaxis))
    md <- lm(paste(input$yaxis ,input$xaxis, sep = "~"),data=df())
    abline(md,col="blue")
  })  
 
  
  # Generating controls for regression 
  output$par_columns <- renderUI({
    if(is.null(df()))
      return()
    selectInput("columns", "Parameters", cbind("",names(df())), selected = 1, multiple = TRUE) 
  })
  
  output$mtm <- renderText({
    if(is.null(df()))
      return()
    'You can choose more than one'
  })
    
  output$est_columns <- renderUI({
    if(is.null(df()))
      return()
    selectInput("estimate", "Estimate", cbind(" ",names(df())), selected = 1)
  })
  
  output$modelButton <- renderUI({
       if(is.null(df()))
         return()
       actionButton('domodel', 'Make model')
    })

# Formatting the formula that will be parameter for the function "glm"   
  formula <- reactive({
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    paste(input$estimate,str_c(input$columns,collapse="+"),sep="~")
  })

  output$formula <- renderText({ 
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    formula()
  })  
 
# Genaralized Linear Model   
  model <- reactive({
    if(is.null(df()))
      return(NULL)
    if (regressionOk() != 'ready')
      return(NULL)    
    glm(formula(),data = df())
  })

# Formatting the result of the linear regression's summary    
  output$regr <- renderText({
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    summ <- capture.output(summary(model()))
    summ <- sub('formula\\(\\)',formula(),summ)
    summ <- sub('df\\(\\)',file_input()$name,summ)
    summ <- paste(summ,collapse = "\n")
  })

  # Showing graphs of regression analysis
  output$plotR1 <- renderPlot({ 
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    plot(model(), which=1) 
  })
  output$plotR2 <- renderPlot({ 
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    plot(model(), which=2) 
  })
  output$plotR3 <- renderPlot({ 
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    plot(model(), which=3) 
  })
  output$plotR4 <- renderPlot({ 
    if(is.null(df()))
      return()
    if (regressionOk() != 'ready')
      return()
    plot(model(), which=4) 
  })


  
    
    
} 

