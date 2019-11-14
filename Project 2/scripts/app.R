library(tidyverse)

source("helper_script.R")

# Define UI for app that draws a histogram and a data table----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Urban Ministries of Durham"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Integer for the number of bins ----
            radioButtons("CheckGroup", 
                         h3("Expense Paid by Financial Support"),
                         choices = list("Water Bills" = "Water Bill",
                                        "Transportation" = "Transportation",
                                        "Medical Expenses" = "Medical Expenses",
                                        "Housing" = "Housing",
                                        "Natural Gas Bill" = "Gas Bill",
                                        "Electricity Bill" = "Electricity Bill",
                                        "Other" = "Other"),
                         selected = "Water Bill"), textOutput("average"), textOutput("max"), textOutput("maxdate"), textOutput("min"), textOutput("mindate"), textOutput("count")
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram and table----
            plotOutput(outputId = "popPlot")
        )
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
    
    # renderPlot creates histogram and links to ui
    output$popPlot <- renderPlot({
        f(input$CheckGroup)
    })
    
    output$average <- renderText({
        paste("Average=", f1(input$CheckGroup))
    })
    
    output$max <- renderText({
        paste("Max =", f2(input$CheckGroup))
    })
    
    output$maxdate <- renderText({
        paste("Max (Date)=", f2_1(input$CheckGroup))
    })

    output$min <- renderText({
        paste("Min =", f3(input$CheckGroup))
    })
    
    output$mindate <- renderText({
        paste("Min (Date)=", f3_1(input$CheckGroup))
    })
    
    output$count <- renderText({
        paste("Count=", f4(input$CheckGroup))
    })
    
}

shinyApp(ui = ui, server = server)

