fluidPage(
# Application title  
  titlePanel("File Analyzer"),
  p(a(href='https://github.com/vitorzap/ShinyApplication', 'See the source -> github'),style="text-align:right"),
# Tabs layout
  tabsetPanel(type = "tabs",
# Tab1 - "File Uploading" Sidebar layout 
     tabPanel("File upload", 
        sidebarLayout(
          sidebarPanel(
# File input widget for file browse and downloading
            fileInput('file1', 'Choose file to upload',
                      accept = c(
                        'text/csv',
                        'text/comma-separated-values',
                        'text/tab-separated-values',
                        'text/plain',
                        '.csv',
                        '.tsv'
                      )
            ),
# ActionsButtos and CheckBoxes to define the characteristics of the file to be uploaded
            actionButton('reset', 'Reset Input'),
            tags$hr(),
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
            tags$hr(),
            p('For testing purpose, in the "Sample Files" tab there are 
              links to downloading various .csv files, you can download 
              and use them for testing'
            ),
            p('File size limit is 5MB, and large files will take some 
               time to load in the "File Browser" tab')
          ),
# The main panel will display information about the file
          mainPanel( 
            h3(textOutput("tInf")),
            tableOutput("fInf"),
            h4(textOutput("tstr")),
            tableOutput("str")
            )
        ),
        value = "FileUpload"
     ),
# Tab2 - "File browser" - A main page where the contents of the file will be shown 
    tabPanel("File browser",
              bootstrapPage(
                tableOutput('grid')
              ),
        value = "Filebrowser"),
# Tab3 - "Graphic" - Sidebar layout
tabPanel("Graphic", 
              sidebarLayout(
# Side panel containing the drop down boxes to choose the graph variables
                sidebarPanel(
                  uiOutput("x_column"),
                  br(),
                  uiOutput("y_column"),
                  br()
                ),
# Main panel containing the control "plot1" that will receive the graph
                 mainPanel(
                   plotOutput("plot1")
                )
              ),value = "Graphic"
     ),
# Tab3 - "Linear regression" - Sidebar layout
     tabPanel("Linear regression", 
         sidebarLayout(
# Side panel containing check boxes to format the formula for linear regression
           sidebarPanel(
             uiOutput("est_columns"),
             br(),
             uiOutput("par_columns"),
             textOutput("mtm"),
             br(),
             uiOutput("modelButton")
           ),
# This main panel will receive the results of linear regression
           mainPanel(
             textOutput("e1"),
             hr(),
             verbatimTextOutput("regr"),
             br(),
             plotOutput("plotR1"),
             br(),
             plotOutput("plotR2"),
             br(),
             plotOutput("plotR3"),
             br(),
             plotOutput("plotR4")
           )
         ),value = "Linear regression"
    ),
# Documentation panel
    tabPanel("Documentation", 
             bootstrapPage(br(),
             includeHTML("doc.html")
             )
    ),
# This panel includes links to files that can be used to test the application
    tabPanel("Sample files", 
             bootstrapPage(br(),
               tags$table(style="width:100%",
                 tags$tr(
                   tags$td('mtcars.csv'),
                   tags$td('Motor Trend Car Road Tests'),
                   tags$td(a(href = 'https://vincentarelbundock.github.io/Rdatasets/csv/datasets/mtcars.csv', 'Download'))
                  ),
                 tags$tr(
                   tags$td('manaus.csv'),
                   tags$td('Average Heights of the Rio Negro river at Manaus'),
                   tags$td(a(href = 'https://vincentarelbundock.github.io/Rdatasets/csv/boot/manaus.csv', 'Download'))
                 ),
                 tags$tr(
                   tags$td('cottonworkers.csv'),
                   tags$td('Occupation and wage profiles of British cotton workers'),
                   tags$td(a(href = 'https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/cottonworkers.csv', 'Download'))
                 ),
                 tags$tr(
                   tags$td('dengue.csv'),
                   tags$td('Dengue prevalence, by administrative region'),
                   tags$td(a(href = 'https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/dengue.csv', 'Download'))
                 ),
                 tags$tr(
                   tags$td('carprice.csv'),
                   tags$td('US Car Price Data'),
                   tags$td(a(href = 'https://vincentarelbundock.github.io/Rdatasets/csv/DAAG/carprice.csv', 'Download'))
                 )
               ),
               br(),
               br(),
               p('Extracted from "https://vincentarelbundock.github.io/Rdatasets/datasets.html"')
              ), value = "Filesample"
      )
                                       
  )
)